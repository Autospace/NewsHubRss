import Foundation
import FeedKit

struct NetworkError: Error {}

struct Networking {
    static func getRSSPageOfSite(by url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        let session = URLSession(configuration: .ephemeral)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NetworkError()))
                }
                return
            }

            if let data = data, let stringData = String(data: data, encoding: .utf8) {
                completion(.success(stringData))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(NetworkError()))
            }
        }
        dataTask.resume()
    }

    static func detectRssFeed(by url: URL, completion: @escaping (_ isRSS: Bool) -> Void) {
        guard url.scheme == "https" else { // we should skip unsafe http connection
            completion(false)
            return
        }

        let session = URLSession(configuration: .ephemeral)
        var request = URLRequest(url: url)
        request.httpMethod = "Head"
        let dataTask = session.dataTask(with: request) { (_, response, _) in
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let contentType = httpResponse.allHeaderFields["Content-Type"] as? String else {
                completion(false)

                return
            }

            let isRss = contentType.hasPrefix("application/rss+xml")
                        || contentType.hasPrefix("application/xml")
                        || contentType.hasPrefix("text/xml")
                        || contentType.hasPrefix("application/json")

            completion(isRss)
        }

        dataTask.resume()
    }

    static func loadFeedData(by feedUrlString: String, completion: @escaping (_ feed: FeedKit.Feed?) -> Void) {
        guard let feedUrl = URL(string: feedUrlString) else {
            completion(nil)
            return
        }

        let parser = FeedParser(URL: feedUrl)
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
            switch result {
            case .success(let feed):
                completion(feed)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }

    static func loadFeedItems(feedUrl: String, completion: @escaping (_ feedItems: [FeedItem]) -> Void) {
        guard let feedUrl = URL(string: feedUrl) else {
            completion([])
            return
        }

        let parser = FeedParser(URL: feedUrl)
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
            switch result {
            case .success(let feed):
                switch feed {
                case .atom(let atomFeed):
                    // Atom feed example link: https://www.youtube.com/feeds/videos.xml?user=NFL
                    var feedItems: [FeedItem] = []
                    if let entities = atomFeed.entries {
                        for (index, feedEntity) in entities.enumerated() {
                            feedItems.append(FeedItem(id: index, feedItemData: .atomFeed(feedEntity)))
                        }
                        completion(feedItems)
                    } else {
                        completion([])
                    }
                case .rss(let rssFeed):
                    if let items = rssFeed.items {
                        var feedItems: [FeedItem] = []
                        for (index, item) in items.enumerated() {
                            feedItems.append(FeedItem(id: index, feedItemData: .rssFeed(item)))
                        }
                        completion(feedItems)
                    } else {
                        completion([])
                    }
                case .json(let jsonFeed):
                    // JSON feed example link: https://www.jsonfeed.org/feed.json
                    if let items = jsonFeed.items {
                        var feedItems: [FeedItem] = []
                        for (index, item) in items.enumerated() {
                            feedItems.append(FeedItem(id: index, feedItemData: .jsonFeed(item)))
                        }
                        completion(feedItems)
                    } else {
                        completion([])
                    }
                }
            case .failure(let error):
                assertionFailure("\(error.localizedDescription)")
                completion([])
            }
        }
    }
}
