//
//  AddFeedView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 26.02.23.
//

import SwiftUI
import SwiftSoup

struct AddFeedView: View {
    @State private var feedUrlString = "https://"
    @FocusState private var textFieldIsFocused: Bool
    @State private var isLoading = false
    @State private var hasError = false
    @State private var errorText = ""
    @State private var foundFeeds: [Feed] = []

    var body: some View {
        VStack {
            VStack {
                Text(L10n.AddNewFeed.instruction)
                TextField(L10n.AddNewFeed.TextField.placeholder, text: $feedUrlString)
                    .frame(height: 44)
                    .autocapitalization(.none)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(hasError ? Color.red : Color.gray)
                    )
                    .disableAutocorrection(true)
                    .focused($textFieldIsFocused)
                    .onChange(of: feedUrlString) { _ in
                        hasError = false
                    }

                if hasError {
                    Text(errorText)
                        .listRowSeparator(.hidden)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(0)
                }

                Button(action: startScanningFeed) {
                    HStack {
                        Spacer()
                        Text(L10n.AddNewFeed.scanButtonTitle)
                            .padding(4)
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(feedUrlString.count < 3 || isLoading)
                .listRowSeparator(.hidden)
            }
            .padding()

            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }

            List {
                ForEach(foundFeeds) { item in
                    FoundFeedView(feedTitle: item.title, feedURLString: item.link)
                }
            }
            .listStyle(.inset)
        }
        .navigationTitle(L10n.AddNewFeed.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func startScanningFeed() {
        guard let url = URL(string: feedUrlString) else {
            return
        }

        textFieldIsFocused = false
        foundFeeds = []
        isLoading = true
        hasError = false
        Networking.getRSSPageOfSite(by: url) { result in
            switch result {
            case .failure(let error):
                isLoading = false
                hasError = true
                errorText = error.localizedDescription
            case .success(let htmlDocument):
                parseHtmlDocumentToFindRssFeeds(htmlDocument)
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
                link = feedUrlString + link
            }

            guard let url = URL(string: link), url.scheme != "http" else {
                continue
            }

            group.enter()
            Networking.detectRssFeed(by: url) { isRSS in
                if isRSS {
                    Networking.loadFeedData(by: url.absoluteString) { feed in
                        switch feed {
                        case .atom(let atomFeed):
                            foundFeeds.append(Feed(
                                id: Int.random(in: 0...1000),
                                title: atomFeed.title ?? "",
                                link: url.absoluteString
                            ))
                        case .rss(let rssFeed):
                            foundFeeds.append(Feed(
                                id: Int.random(in: 0...1000),
                                title: rssFeed.title ?? "",
                                link: url.absoluteString
                            ))
                        case .json(let jsonFeed):
                            foundFeeds.append(Feed(
                                id: Int.random(in: 0...1000),
                                title: jsonFeed.title ?? "",
                                link: url.absoluteString
                            ))

                        case .none:
                            ()
                        }

                        group.leave()
                    }
                } else {
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            isLoading = false
        }
    }
}

struct AddFeedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddFeedView()
        }
    }
}
