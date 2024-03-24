import SwiftUI

struct FeedItemsListView: View {
    @State var selectedFeedItem: DBFeedItem?
    @StateObject var viewModel: FeedItemsListViewModel

    init(feed: DBFeed) {
        _viewModel = StateObject(wrappedValue: FeedItemsListViewModel(feed: feed))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            }
            List {
                ForEach(viewModel.listItems) { item in
                    FeedItemView(
                        title: item.title,
                        date: item.pubDate,
                        imageUrl: URL(string: item.enclosureLink ?? ""),
                        hasRead: item.hasRead
                    ) {
                        selectedFeedItem = item
                        item.hasRead = true
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button(role: .cancel) {
                            item.isFavorite = true
                        } label: {
                            Label("", systemImage: "heart")
                        }
                        .tint(.green)
                    }
                }
                .onDelete(perform: viewModel.deleteItems)
            }
            .refreshable {
                viewModel.loadData(showLoadingIndicator: false)
            }
            .listStyle(.inset)
            .fullScreenCover(item: $selectedFeedItem) { selectedFeedItem in
                if let url = URL(string: selectedFeedItem.link) {
                    SafariView(url: url)
                }
            }
            .toolbar {
                Button {
                    viewModel.filterIsOpened = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
                .sheet(isPresented: $viewModel.filterIsOpened,
                       content: {
                    FeedItemsListFilterView(
                        feed: viewModel.feed,
                        filter: viewModel.filter,
                        applyHandler: viewModel.applyFilterCompletion
                    )
                })
            }
        }
        .navigationTitle(viewModel.feed.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadData()
        }
    }
}

struct FeedItemsList_Previews: PreviewProvider {
    static var previews: some View {
        FeedItemsListView(feed: DBFeed.previewInstance())
    }
}
