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
    @State private var selectedFeedItem: Feed.FeedItem?
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            }
            List {
                ForEach(feedItems) { item in
                    FeedItemView(
                        title: item.feedData.title ?? "",
                        date: item.feedData.pubDate ?? Date()
                    )
                    .onTapGesture {
                        selectedFeedItem = item
                    }
                }
            }
            .refreshable {
                loadData(showLoadingIndicator: false)
            }
            .listStyle(.inset)
            .fullScreenCover(item: $selectedFeedItem) { selectedFeedItem in
                if let link = selectedFeedItem.feedData.link, let url = URL(string: link) {
                    SafariView(url: url)
                }
            }
        }
        .navigationTitle(feed.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadData()
        }
    }

    private func loadData(showLoadingIndicator: Bool = true) {
        if showLoadingIndicator {
            isLoading = true
        }
        feed.loadFeedItems { feedItems in
            isLoading = false
            self.feedItems = feedItems
        }
    }
}

struct FeedItemsList_Previews: PreviewProvider {
    static var previews: some View {
        FeedItemsListView(feed: ModelData().feeds[0])
    }
}
