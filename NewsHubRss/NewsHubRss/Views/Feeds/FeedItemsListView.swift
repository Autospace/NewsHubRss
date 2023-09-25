//
//  FeedItemsList.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 17.04.23.
//

import SwiftUI
import CoreData

struct FeedItemsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let feed: DBFeed
    @State private var selectedFeedItem: DBFeedItem?
    @State private var isLoading: Bool = false
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.pubDate, order: .reverse)],
        predicate: NSPredicate(format: "hasDeleted == false")
    )
    private var dbFeedItems: FetchedResults<DBFeedItem>

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            }
            List {
                ForEach(dbFeedItems) { item in
                    FeedItemView(
                        title: item.title,
                        date: item.pubDate,
                        hasRead: item.hasRead
                    )
                    .onTapGesture {
                        selectedFeedItem = item
                        item.hasRead = true
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .refreshable {
                loadData(showLoadingIndicator: false)
            }
            .listStyle(.inset)
            .fullScreenCover(item: $selectedFeedItem) { selectedFeedItem in
                if let url = URL(string: selectedFeedItem.link) {
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
            let fetchRequest = DBFeedItem.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pubDate", ascending: false)]
            let fetchResult = try? viewContext.fetch(fetchRequest)

            let lastSavedItem = fetchResult?.first as? DBFeedItem
            if let lastSavedItem = lastSavedItem, let lastFeedItemPubDate = feedItems.sorted(by: { item1, item2 in
                guard let pubDate1 = item1.feedData.pubDate, let pubDate2 = item2.feedData.pubDate else {
                    return false
                }
                return pubDate1 > pubDate2
            }).first?.feedData.pubDate, lastSavedItem.pubDate >= lastFeedItemPubDate {
                isLoading = false
                return
            }

            for feedItem in feedItems {
                guard let link = feedItem.feedData.link,
                      let title = feedItem.feedData.title,
                      let pubDate = feedItem.feedData.pubDate else {
                    assertionFailure()
                    continue
                }

                if let lastSavedItem = lastSavedItem,
                   let lastFeedItemPubDate = feedItem.feedData.pubDate,
                   lastSavedItem.pubDate >= lastFeedItemPubDate {
                    continue
                }

                let dbFeedItem = DBFeedItem(context: viewContext)
                dbFeedItem.title = title
                dbFeedItem.link = link
                dbFeedItem.guid = feedItem.feedData.guid?.value ?? link
                dbFeedItem.pubDate = pubDate
            }

            isLoading = false
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            dbFeedItems[index].hasDeleted = true
        }
    }
}

struct FeedItemsList_Previews: PreviewProvider {
    static var previews: some View {
        FeedItemsListView(feed: DBFeed())
    }
}
