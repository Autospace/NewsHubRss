import CoreData

class DBFeed: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var url: String
    @NSManaged var sortOrderPosition: Int16

    @NSManaged private var dbFeedItems: Set<DBFeedItem>?

    public var feedItems: [DBFeedItem] {
        let set = dbFeedItems ?? []
        return set.sorted {
            $0.pubDate > $1.pubDate
        }.filter {
            $0.hasDeleted == false
        }
    }

    public var allFeedItems: [DBFeedItem] {
        let set = dbFeedItems ?? []
        return set.sorted {
            $0.pubDate > $1.pubDate
        }
    }
}
