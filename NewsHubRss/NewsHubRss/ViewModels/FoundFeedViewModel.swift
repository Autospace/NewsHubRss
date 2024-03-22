import Foundation
import CoreData

final class FoundFeedViewModel: ObservableObject {
    @Published var showingDeleteFeedAlert: Bool = false
    @Published var feedAlreadySaved = false

    let feedTitle: String
    let feedURLString: String
    let tapHandler: (() -> Void)

    private let viewContext = DataController.shared.container.viewContext

    private var dbFeeds: [DBFeed] = []

    init(feedTitle: String, feedURLString: String, tapHandler: @escaping () -> Void) {
        self.feedTitle = feedTitle
        self.feedURLString = feedURLString
        self.tapHandler = tapHandler

        updateSavingStatusOfTheFeed()
    }

    func saveFeed() {
        let dbFeed = DBFeed(context: viewContext)
        dbFeed.id = UUID()
        dbFeed.title = feedTitle
        dbFeed.url = feedURLString
        dbFeed.sortOrderPosition = (dbFeeds.last?.sortOrderPosition ?? 0) + 1

        saveContext()
        updateSavingStatusOfTheFeed()
    }

    func deleteFeed(force: Bool = false) {
        if let foundFeed = dbFeeds.first(where: {$0.url == feedURLString}) {
            if foundFeed.feedItems.count > 0, !force {
                showingDeleteFeedAlert = true
            } else {
                viewContext.delete(foundFeed)
                updateSavingStatusOfTheFeed()
            }
        }
    }

    func updateSavingStatusOfTheFeed() {
        loadListOfFeeds()
        let feedsURLs = dbFeeds.map { $0.url }
        feedAlreadySaved = feedsURLs.contains(feedURLString)
    }

    private func loadListOfFeeds() {
        let request = NSFetchRequest<DBFeed>(entityName: String.init(describing: DBFeed.self))
        do {
            dbFeeds = try viewContext.fetch(request)
        } catch let error {
            assertionFailure()
            print("Fetch DBFeeds error: \(error)")
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("An error occured: \(error)")
        }
    }
}
