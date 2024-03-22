import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel = FavoritesViewModel()

    var body: some View {
        Group {
            if viewModel.dbFeedItems.count == 0 {
                VStack {
                    ContentUnavailableView {
                        Label(
                            title: { Text(L10n.Favorites.EmptyView.title) },
                            icon: {
                                Image(systemName: "rainbow")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.system(size: 144))
                            }
                        )
                    } description: {
                        Text(L10n.Favorites.EmptyView.description)
                    }
                }
            } else {
                List {
                    ForEach(viewModel.dbFeedItems) { feedItem in
                        FeedItemView(
                            title: feedItem.title,
                            date: feedItem.pubDate,
                            imageUrl: URL(string: feedItem.enclosureLink ?? ""),
                            hasRead: feedItem.hasRead
                        ) {
                            viewModel.selectedFeedItem = feedItem
                        }
                    }
                }
                .fullScreenCover(item: $viewModel.selectedFeedItem) { selectedFeedItem in
                    if let url = URL(string: selectedFeedItem.link) {
                        SafariView(url: url)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchFavorites()
        }
    }
}

#Preview {
    FavoritesView()
}
