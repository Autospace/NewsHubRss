//
//  Feed.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 17.04.23.
//

import Foundation
import FeedKit

struct Feed: Identifiable {
    struct FeedItem: Identifiable {
        let id: Int
        let feedData: RSSFeedItem
    }

    let id: Int
    let title: String
    let link: String

    func loadFeedItems(completion: @escaping (_ feedItems: [FeedItem]) -> Void) {
        guard let feedUrl = URL(string: link) else {
            completion([])
            return
        }

        let parser = FeedParser(URL: feedUrl)
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
            switch result {
            case .success(let feed):
                switch feed {
                case .atom:
                    assertionFailure("Need to implement functionality to work with atom feed")
                case .rss(let rssFeed):
                    if let items = rssFeed.items {
                        var feedItems: [FeedItem] = []
                        for (index, item) in items.enumerated() {
                            feedItems.append(FeedItem(id: index, feedData: item))
                        }
                        completion(feedItems)
                    }
                case .json:
                    assertionFailure("Need to implement functionality to work with JSON feed")
                }
            case .failure(let error):
                assertionFailure("\(error.localizedDescription)")
            }
        }
    }
}
