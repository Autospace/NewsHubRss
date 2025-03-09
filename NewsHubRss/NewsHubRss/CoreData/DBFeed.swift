import CoreData

final class DBFeed: NSManagedObject, Identifiable {
    @NSManaged var title: String
    @NSManaged var url: String
    @NSManaged var sortOrderPosition: Int16
    @Published var unreadCount: Int = 0

    @NSManaged private var dbFeedItems: Set<DBFeedItem>?

    var feedItems: [DBFeedItem] {
        let set = dbFeedItems ?? []
        return set.sorted {
            $0.pubDate > $1.pubDate
        }.filter {
            $0.hasDeleted == false
        }
    }

    var allFeedItems: [DBFeedItem] {
        let set = dbFeedItems ?? []
        return set.sorted {
            $0.pubDate > $1.pubDate
        }
    }

    override func awakeFromInsert() {
        super.awakeFromInsert()
        calculateUnreadCount()
    }

    override func awakeFromFetch() {
        super.awakeFromFetch()
        calculateUnreadCount()
    }

    private func calculateUnreadCount() {
        let numberOfUnreadItems = feedItems.filter { $0.hasRead == false && $0.hasDeleted == false }.count
        if unreadCount != numberOfUnreadItems {
            unreadCount = numberOfUnreadItems
        }
    }
}

extension DBFeed {
    static func previewInstance() -> DBFeed {
        let instance = DBFeed(context: DataController.shared.container.viewContext)
        instance.title = "Habr"
        instance.url = "https://habr.com/rss"
        instance.dbFeedItems = [
            getFeedItem(feed: instance, title: "Feed item 1", author: "Nintendo"),
            getFeedItem(feed: instance, title: "Feed item 2", author: "TestAuthor"),
            getFeedItem(feed: instance, title: "Feed item 3", author: "TestAuthor"),
            getFeedItem(feed: instance, title: "Feed item 4", author: nil),
            getFeedItem(feed: instance, title: "Feed item 5", author: nil)
        ]

        return instance
    }

    static func getFeedItem(feed: DBFeed, title: String, author: String?) -> DBFeedItem {
        let dbFeedItem = DBFeedItem(context: DataController.shared.container.viewContext)
        dbFeedItem.title = title
        dbFeedItem.link = ""
        dbFeedItem.author = author
        dbFeedItem.guid = UUID().uuidString
        dbFeedItem.pubDate = Date.now
        dbFeedItem.dbFeed = feed
        dbFeedItem.enclosureLink = nil
        dbFeedItem.enclosureLength = nil
        dbFeedItem.enclosureType = nil

        return dbFeedItem
    }
}
