import SwiftUI

struct FeedItemsListFilterView: View {
    @StateObject private var viewModel: FeedItemsListFilterViewModel

    init(feed: DBFeed, filter: FeedItemsListFilter, applyHandler: @escaping (_ filter: FeedItemsListFilter) -> Void) {
        _viewModel = StateObject(
            wrappedValue: FeedItemsListFilterViewModel(
                feed: feed,
                filter: filter,
                applyHandler: applyHandler
            )
        )
    }

    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(header: Text(L10n.FeedItemsFilter.AuthorsSection.title)) {
                    ForEach(viewModel.authors, id: \.self) { author in
                        HStack {
                            Text(author)
                            Spacer()
                            if viewModel.selectedAuthors.contains(author) {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.toggleAuthorSelection(author)
                        }
                    }
                }
            }

            Spacer()

            HStack {
                Button {
                    viewModel.clearFilter()
                } label: {
                    Text(L10n.FeedItemsFilter.clearFilterButtonTitle)
                        .foregroundColor(.white)
                }
                .background(Color.red)
                .cornerRadius(8)
                .padding([.leading], 16)
                .buttonStyle(.bordered)

                Spacer()
                Button(action: {
                    viewModel.applyFilter()
                }, label: {
                    Text(L10n.FeedItemsFilter.applyFilterButtonTitle)
                })
                .padding([.trailing], 16)
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear {
            viewModel.loadAuthors()
        }
    }
}

#Preview {
    FeedItemsListFilterView(feed: DBFeed.previewInstance(), filter: FeedItemsListFilter(), applyHandler: { _ in })
}
