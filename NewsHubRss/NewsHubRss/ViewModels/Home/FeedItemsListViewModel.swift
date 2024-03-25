import Foundation

final class FeedItemsListViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var filterIsOpened: Bool = false
    @Published var listItems: [DBFeedItem] = []
    let feed: DBFeed
    var filter: FeedItemsListFilter = FeedItemsListFilter()
    private let viewContext = DataController.shared.container.viewContext

    init(feed: DBFeed) {
        self.feed = feed
        self.listItems = feed.feedItems
    }

    func loadData(showLoadingIndicator: Bool = true) {
        if showLoadingIndicator {
            isLoading = true
        }
        Networking.loadFeedItems(feedUrl: feed.url) {[weak self] feedItems in
            guard let self = self else {
                return
            }
            let lastSavedItem = self.feed.allFeedItems.first
            if let lastSavedItem = lastSavedItem, let lastFeedItemPubDate = feedItems.sorted(by: { item1, item2 in
                guard let pubDate1 = item1.feedData.pubDate, let pubDate2 = item2.feedData.pubDate else {
                    return false
                }
                return pubDate1 > pubDate2
            }).first?.feedData.pubDate, lastSavedItem.pubDate >= lastFeedItemPubDate {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
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
                   let feedItemPubDate = feedItem.feedData.pubDate,
                   lastSavedItem.pubDate >= feedItemPubDate {
                    continue
                }

                let dbFeedItem = DBFeedItem(context: self.viewContext)
                dbFeedItem.title = title
                dbFeedItem.link = link
                dbFeedItem.author = feedItem.feedData.author ?? feedItem.feedData.dublinCore?.dcCreator
                dbFeedItem.guid = feedItem.feedData.guid?.value ?? link
                dbFeedItem.pubDate = pubDate
                dbFeedItem.dbFeed = feed
                dbFeedItem.enclosureLink = feedItem.feedData.enclosure?.attributes?.url
                dbFeedItem.enclosureLength = NSNumber(value: feedItem.feedData.enclosure?.attributes?.length ?? 0)
                dbFeedItem.enclosureType = feedItem.feedData.enclosure?.attributes?.type
            }

            DispatchQueue.main.async {
                self.isLoading = false
                self.applyFilterCompletion(self.filter)
            }
        }
    }

    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            feed.feedItems[index].hasDeleted = true
        }
    }

    func applyFilterCompletion(_ filter: FeedItemsListFilter) {
        filterIsOpened = false
        self.filter = filter

        if filter.isEmpty() {
            listItems = feed.feedItems
        } else {
            listItems = feed.feedItems.filter({ feedItem in
                filter.authors.contains(feedItem.author ?? "")
            })
        }
    }
}
