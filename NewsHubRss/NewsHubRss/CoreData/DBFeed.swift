//
//  DBFeed.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 18.08.23.
//

import CoreData

class DBFeed: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var url: String
    @NSManaged var sortOrderPosition: Int16
}
