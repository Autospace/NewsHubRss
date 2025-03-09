import CoreData

class DBFeedItem: NSManagedObject, Identifiable {
    @NSManaged var guid: String
    @NSManaged var title: String
    @NSManaged var link: String
    @NSManaged var author: String?
    @NSManaged var pubDate: Date
    @NSManaged var enclosureLink: String?
    @NSManaged var enclosureLength: NSNumber?
    @NSManaged var enclosureType: String?
    @NSManaged private(set) var hasRead: Bool
    @NSManaged var hasDeleted: Bool
    @NSManaged var isFavorite: Bool

    @NSManaged var dbFeed: DBFeed

    func markAsRead() {
        hasRead = true
        try? managedObjectContext?.save()
    }
}
