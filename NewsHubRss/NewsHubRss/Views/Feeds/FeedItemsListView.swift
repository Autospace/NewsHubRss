//
//  FeedItemsList.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 17.04.23.
//

import SwiftUI
import FeedKit

struct FeedItemsListView: View {
    let feed: Feed
    @State private var feedItems: [Feed.FeedItem] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(feedItems) { item in
                    FeedItemView(
                        title: item.feedData.title ?? "",
                        date: item.feedData.pubDate ?? Date()
                    )
                }
            }
            .navigationTitle(feed.title)
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.inset)
            .onAppear {
                feed.loadFeedItems { feedItems in
                    self.feedItems = feedItems
                }
            }
        }
    }
}

struct FeedItemsList_Previews: PreviewProvider {
    static var previews: some View {
        FeedItemsListView(feed: ModelData().feeds[0])
    }
}
