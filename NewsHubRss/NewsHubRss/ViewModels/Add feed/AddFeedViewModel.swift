import Foundation
import CoreData
import SwiftSoup
import FeedKit

final class AddFeedViewModel: ObservableObject {
    @Published var feedUrlString = "" {
        didSet {
            hasError = false
        }
    }
    @Published var isLoading = false
    @Published var hasError = false
    @Published var errorText = ""
    @Published var foundFeeds: [FoundFeed] = []
    @Published var showingFeedEditView: Bool = false
    var selectedItem: FoundFeed?
    var searchUrl: URL?

    func startScanningFeed() {
        if !feedUrlString.hasPrefix("https://") {
            feedUrlString = "https://\(feedUrlString)"
        }
        guard let url = URL(string: feedUrlString) else {
            return
        }

        searchUrl = url
        foundFeeds = []
        isLoading = true
        hasError = false
        Networking.detectRssFeed(by: url) { isRSS in
            if isRSS {
                Networking.loadFeedData(by: url.absoluteString) {[weak self] feed in
                    DispatchQueue.main.async {
                        self?.addFeedToFoundFeeds(url: url, feed: feed)
                        self?.isLoading = false
                    }
                }
            } else {
                Networking.getRSSPageOfSite(by: url) {[weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .failure(let error):
                            self?.isLoading = false
                            self?.hasError = true
                            self?.errorText = error.localizedDescription
                        case .success(let htmlDocument):
                            self?.parseHtmlDocumentToFindRssFeeds(htmlDocument)
                        }
                    }
                }
            }
        }
    }

    private func parseHtmlDocumentToFindRssFeeds(_ html: String) {
        guard let doc = try? SwiftSoup.parse(html), let elements = try? doc.getAllElements() else {
            hasError = true
            errorText = "Cannot parse received document"
            return
        }

        let group = DispatchGroup()
        for element in elements {
            guard element.hasAttr("href"), var link = try? element.attr("href") else {
                continue
            }

            if let url = URL(string: link), url.host == nil {
                if let searchUrl = searchUrl, let scheme = searchUrl.scheme, let host = searchUrl.host {
                    link = "\(scheme)://\(host)\(link)"
                } else {
                    assertionFailure()
                    link = feedUrlString + link
                }
            }

            guard let url = URL(string: link), url.scheme != "http" else {
                continue
            }

            group.enter()
            Networking.detectRssFeed(by: url) { isRSS in
                if isRSS {
                    Networking.loadFeedData(by: url.absoluteString) {[weak self] feed in
                        self?.addFeedToFoundFeeds(url: url, feed: feed)
                        group.leave()
                    }
                } else {
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {[weak self] in
            self?.isLoading = false
        }
    }

    private func addFeedToFoundFeeds(url: URL, feed: Feed?) {
        guard let feed = feed else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }

            switch feed {
            case .atom(let atomFeed):
                self.foundFeeds.append(FoundFeed(
                    title: atomFeed.title ?? "",
                    link: url.absoluteString
                ))
            case .rss(let rssFeed):
                self.foundFeeds.append(FoundFeed(
                    title: rssFeed.title ?? "",
                    link: url.absoluteString
                ))
            case .json(let jsonFeed):
                self.foundFeeds.append(FoundFeed(
                    title: jsonFeed.title ?? "",
                    link: url.absoluteString
                ))
            }
        }
    }
}

extension AddFeedViewModel {
    static func getMockViewModel() -> AddFeedViewModel {
        let viewModel = AddFeedViewModel()
        viewModel.foundFeeds = [
            FoundFeed(title: "Test title", link: "https://testfeedurl.xyz")
        ]
        
        return viewModel
    }
}
