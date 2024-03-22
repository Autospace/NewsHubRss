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

    func delete(item: NSManagedObject) {
        let context = container.viewContext
        context.delete(item)
        saveContext()
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error saving Core Data context: \(error)")
            }
        }
    }
}
