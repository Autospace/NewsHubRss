//
//  DataController.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 21.05.23.
//

import CoreData
import Foundation

struct DataController {
    static let shared = DataController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Database")

        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription) ")
            }
        }
    }
}
