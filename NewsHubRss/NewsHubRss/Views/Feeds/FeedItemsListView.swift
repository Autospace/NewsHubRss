//
//  FeedItemsList.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 17.04.23.
//

import SwiftUI

struct FeedItemsListView: View {
    let feed: DBFeed
    @State private var feedItems: [FeedItem] = []
    @State private var selectedFeedItem: FeedItem?
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
                .onDelete(perform: deleteItems)
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
            .toolbar {
                EditButton()
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
        Networking.loadFeedItems(feedUrl: feed.url) { feedItems in
            isLoading = false
            self.feedItems = feedItems
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        feedItems.remove(atOffsets: offsets)
    }
}

struct FeedItemsList_Previews: PreviewProvider {
    static var previews: some View {
        FeedItemsListView(feed: DBFeed())
    }
}
