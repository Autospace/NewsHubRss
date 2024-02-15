import SwiftUI

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedFeedItem: DBFeedItem?

    @FetchRequest(
        entity: DBFeedItem.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "isFavorite == true")
    )
    private var dbFeedsItems: FetchedResults<DBFeedItem>

    var body: some View {
        List {
            if dbFeedsItems.count == 0 {
                ContentUnavailableView.search
            } else {
                ForEach(dbFeedsItems) { feedItem in
                    FeedItemView(
                        title: feedItem.title,
                        date: feedItem.pubDate,
                        imageUrl: URL(string: feedItem.enclosureLink ?? ""),
                        hasRead: feedItem.hasRead
                    ) {
                        selectedFeedItem = feedItem
                    }
                }
            }
        }
        .fullScreenCover(item: $selectedFeedItem) { selectedFeedItem in
            if let url = URL(string: selectedFeedItem.link) {
                SafariView(url: url)
            }
        }
    }
}

#Preview {
    FavoritesView()
}
