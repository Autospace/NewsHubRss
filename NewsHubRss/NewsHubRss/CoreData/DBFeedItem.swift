//
//  DBFeedItem.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 24.09.23.
//

import CoreData

class DBFeedItem: NSManagedObject, Identifiable {
    @NSManaged var guid: String
    @NSManaged var title: String
    @NSManaged var link: String
    @NSManaged var pubDate: Date
    @NSManaged var hasRead: Bool
    @NSManaged var hasDeleted: Bool
    @NSManaged var isFavorite: Bool

    @NSManaged var dbFeed: DBFeed
}
