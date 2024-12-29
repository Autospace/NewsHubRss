import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel = FavoritesViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.dbFeedItems.count == 0 {
                    VStack {
                        if #available(iOS 17.0, *) {
                            ContentUnavailableView {
                                Label(
                                    title: { Text(L10n.Favorites.EmptyView.title) },
                                    icon: {
                                        Image(systemName: "rainbow")
                                            .symbolRenderingMode(.multicolor)
                                            .font(.system(size: 144))
                                            .symbolEffect(
                                                .variableColor
                                                    .iterative
                                                    .reversing
                                            )
                                    }
                                )
                            } description: {
                                Text(L10n.Favorites.EmptyView.description)
                            }
                        } else {
                            VStack(alignment: .center) {
                                Image(systemName: "tree")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.system(size: 100))
                                    .foregroundColor(.green)
                                Text(L10n.Favorites.EmptyView.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text(L10n.Favorites.EmptyView.description)
                                    .foregroundColor(.secondary)
                                    .font(.body)
                                    .padding([.top, .bottom], 2)
                            }
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
                        .onDelete(perform: viewModel.deleteItems)
                    }
                    .fullScreenCover(item: $viewModel.selectedFeedItem) { selectedFeedItem in
                        if let url = URL(string: selectedFeedItem.link) {
                            SafariView(url: url)
                        }
                    }
                }
            }
            .navigationTitle(L10n.Favorites.Screen.title)
        }
        .onAppear {
            viewModel.fetchFavorites()
        }
    }
}

#Preview {
    FavoritesView()
}
