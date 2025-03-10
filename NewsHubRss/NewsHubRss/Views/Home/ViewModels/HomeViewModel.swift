import SwiftUI
import CoreData

final class HomeViewModel: ObservableObject {
    @Published var dbFeeds: [DBFeed] = []
    private let dataController = DataController.shared

    func fetchFeeds() {
        let request = NSFetchRequest<DBFeed>(entityName: String.init(describing: DBFeed.self))
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DBFeed.sortOrderPosition, ascending: true)]
        do {
            dbFeeds = try dataController.container.viewContext.fetch(request)
        } catch let error {
            print("Fetch DBFeeds error: \(error)")
        }
    }

    func deleteItems(at offsets: IndexSet) {
        guard let firstIndex = offsets.first else {
            return
        }

        let itemToDelete = dbFeeds[firstIndex]
        dataController.delete(item: itemToDelete)
        fetchFeeds()
    }

    func moveItems(from source: IndexSet, to destination: Int) {
        dbFeeds.move(fromOffsets: source, toOffset: destination)
        saveOrder()
    }

    private func saveOrder() {
        for (index, feed) in dbFeeds.enumerated() {
            feed.sortOrderPosition = Int16(index)
        }
        try? DataController.shared.container.viewContext.save()
    }
}
