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
            guard feedItems.isNotEmpty, let self = self else {
                self?.listItems = []
                self?.isLoading = false
                return
            }

            let lastSavedItem = self.feed.allFeedItems.first
            if let lastSavedItem = lastSavedItem, let lastFeedItemPubDate = feedItems.sorted(by: { item1, item2 in
                guard let pubDate1 = item1.publishedDate, let pubDate2 = item2.publishedDate else {
                    return false
                }
                return pubDate1 > pubDate2
            }).first?.publishedDate, lastSavedItem.pubDate >= lastFeedItemPubDate {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }

            for feedItem in feedItems {
                guard let link = feedItem.link,
                      let title = feedItem.title,
                      let pubDate = feedItem.publishedDate else {
                    assertionFailure()
                    continue
                }

                if let lastSavedItem = lastSavedItem,
                   let feedItemPubDate = feedItem.publishedDate,
                   lastSavedItem.pubDate >= feedItemPubDate {
                    continue
                }

                let dbFeedItem = DBFeedItem(context: self.viewContext)
                dbFeedItem.title = title
                dbFeedItem.link = link
                dbFeedItem.author = feedItem.author
                dbFeedItem.guid = feedItem.guid ?? link
                dbFeedItem.pubDate = pubDate
                dbFeedItem.dbFeed = feed
                dbFeedItem.enclosureLink = feedItem.enclosureLink
//                dbFeedItem.enclosureLength = NSNumber(value: feedItem.feedData.enclosure?.attributes?.length ?? 0)
//                dbFeedItem.enclosureType = feedItem.feedData.enclosure?.attributes?.type
            }

            DispatchQueue.main.async {
                self.isLoading = false
                self.applyFilterCompletion(self.filter)
                try? self.viewContext.save()
            }
        }
    }

    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            feed.feedItems[index].hasDeleted = true
        }
        try? viewContext.save()
        listItems = feed.feedItems
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

    func saveViewContext() {
        try? viewContext.save()
        listItems = feed.feedItems
    }
}
