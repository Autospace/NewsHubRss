//
//  FeedItemsList.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 17.04.23.
//

import SwiftUI

struct FeedItemsListView: View {
    @State var selectedFeedItem: DBFeedItem?
    @StateObject var viewModel: FeedItemsListViewModel

    init(feed: DBFeed) {
        _viewModel = StateObject(wrappedValue: FeedItemsListViewModel(feed: feed))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            }
            List {
                ForEach(viewModel.feed.feedItems) { item in
                    FeedItemView(
                        title: item.title,
                        date: item.pubDate,
                        imageUrl: URL(string: item.enclosureLink ?? ""),
                        hasRead: item.hasRead
                    ) {
                        selectedFeedItem = item
                        item.hasRead = true
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button(role: .cancel) {
                            item.isFavorite = true
                        } label: {
                            Label("", systemImage: "heart")
                        }
                        .tint(.green)
                    }
                }
                .onDelete(perform: viewModel.deleteItems)
            }
            .refreshable {
                viewModel.loadData(showLoadingIndicator: false)
            }
            .listStyle(.inset)
            .fullScreenCover(item: $selectedFeedItem) { selectedFeedItem in
                if let url = URL(string: selectedFeedItem.link) {
                    SafariView(url: url)
                }
            }
            .toolbar {
                Button {
                    // TODO: need to implement
                    print("Open filter")
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .navigationTitle(viewModel.feed.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadData()
        }
    }
}

struct FeedItemsList_Previews: PreviewProvider {
    static var previews: some View {
        FeedItemsListView(feed: DBFeed())
    }
}
