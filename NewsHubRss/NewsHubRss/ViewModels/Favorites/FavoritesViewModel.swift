import Foundation
import CoreData

final class FavoritesViewModel: ObservableObject {
    @Published var selectedFeedItem: DBFeedItem?
    @Published var dbFeedItems: [DBFeedItem] = []
    private let viewContext = DataController.shared.container.viewContext

    func fetchFavorites() {
        let request = NSFetchRequest<DBFeedItem>(entityName: String.init(describing: DBFeedItem.self))
        request.predicate = NSPredicate(format: "isFavorite == true")
        do {
            dbFeedItems = try viewContext.fetch(request).sorted(by: { item1, item2 in
                item1.pubDate > item2.pubDate
            })
        } catch let error {
            print("Fetch error: \(error)")
        }
    }
}
