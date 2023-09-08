//
//  FeedItem.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 8.09.23.
//

import FeedKit

struct FeedItem: Identifiable {
    let id: Int
    let feedData: RSSFeedItem
}
