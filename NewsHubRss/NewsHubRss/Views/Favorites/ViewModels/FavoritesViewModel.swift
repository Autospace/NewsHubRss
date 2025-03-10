import Foundation
import CoreData

final class FavoritesViewModel: ObservableObject {
    @Published var selectedFeedItem: DBFeedItem? {
        didSet {
            selectedFeedItem?.markAsRead()
        }
    }
    @Published var dbFeedItems: [DBFeedItem] = []
    private let viewContext = DataController.shared.container.viewContext

    func fetchFavorites() {
        let request = NSFetchRequest<DBFeedItem>(entityName: String.init(describing: DBFeedItem.self))
        request.predicate = NSPredicate(format: "isFavorite == true && hasDeleted == false")
        do {
            dbFeedItems = try viewContext.fetch(request).sorted(by: { item1, item2 in
                item1.pubDate > item2.pubDate
            })
        } catch let error {
            print("Fetch error: \(error)")
        }
    }

    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            dbFeedItems[index].hasDeleted = true
        }
        dbFeedItems.remove(atOffsets: offsets)
    }
}
