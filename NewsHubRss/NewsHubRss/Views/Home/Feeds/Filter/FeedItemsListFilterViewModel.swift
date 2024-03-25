import Foundation
import SwiftUI

class FeedItemsListFilter {
    var authors: Set<String> = []

    func isEmpty() -> Bool {
        return authors.isEmpty
    }
}

class FeedItemsListFilterViewModel: ObservableObject {
    @Published var authors: [String] = []
    @Published var selectedAuthors: Set<String> = []

    var filter: FeedItemsListFilter
    let feed: DBFeed
    let applyFilterHandler: (_ filter: FeedItemsListFilter) -> Void

    init(feed: DBFeed, filter: FeedItemsListFilter, applyHandler: @escaping (_ filter: FeedItemsListFilter) -> Void) {
        self.filter = filter
        self.feed = feed
        self.applyFilterHandler = applyHandler
    }

    func loadAuthors() {
        authors = Array(Set(feed.feedItems.map { $0.author ?? L10n.FeedItemsFilter.AuthorsSection.unknownAuthor }))
        selectedAuthors = filter.authors
    }

    func toggleAuthorSelection(_ author: String) {
        if selectedAuthors.contains(author) {
            selectedAuthors.remove(author)
        } else {
            selectedAuthors.insert(author)
        }
    }

    func applyFilter() {
        filter.authors = selectedAuthors
        applyFilterHandler(filter)
    }

    func clearFilter() {
        selectedAuthors = []
        filter.authors = []
    }
}
