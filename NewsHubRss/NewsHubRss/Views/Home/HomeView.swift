import SwiftUI

struct HomeView: View {
    @ObservedObject var tabSelectionManager: TabSelectionManager
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.dbFeeds.isEmpty {
                    if #available(iOS 17.0, *) {
                        ContentUnavailableView(label: {
                            Label(L10n.MainPage.EmptyState.title, systemImage: "globe")
                        }, description: {
                            Text(L10n.MainPage.EmptyState.description)
                        }, actions: {
                            Button(action: {
                                tabSelectionManager.selectedTab = .add
                            }, label: {
                                Text(L10n.MainPage.EmptyState.buttonTitle)
                            })
                        })
                    } else {
                        VStack(alignment: .center) {
                            Image(systemName: "globe")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                            Text(L10n.MainPage.EmptyState.title)
                                .font(.title)
                                .fontWeight(.bold)
                            Text(L10n.MainPage.EmptyState.description)
                                .foregroundColor(.secondary)
                                .font(.body)
                                .padding([.top, .bottom], 2)

                            Button(action: {
                                tabSelectionManager.selectedTab = .add
                            }, label: {
                                Text(L10n.MainPage.EmptyState.buttonTitle)
                            })
                        }
                    }
                } else {
                    List {
                        ForEach(viewModel.dbFeeds) { dbFeed in
                            NavigationLink {
                                FeedItemsListView(feed: dbFeed)
                            } label: {
                                Text(dbFeed.title)
                            }
                        }
                        .onMove { indexSet, intValue in
                            print("Index set: \(indexSet), IntValue: \(intValue)")
                        }
                        .onDelete(perform: viewModel.deleteItems)
                    }
                }
            }
            .navigationTitle(L10n.MainPage.title)
        }
        .onAppear {
            viewModel.fetchFeeds()
        }
    }
}

#Preview {
    HomeView(tabSelectionManager: TabSelectionManager())
}
