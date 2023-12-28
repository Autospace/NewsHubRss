//
//  ContentView.swift
//  NewsHubRss
//
//  Created by Alex Mostovnikov on 7/9/22.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var tabSelectionManager: TabSelectionManager
    @FetchRequest(
        entity: DBFeed.entity(),
        sortDescriptors: [NSSortDescriptor(key: "sortOrderPosition", ascending: true)]
    )

    private var dbFeeds: FetchedResults<DBFeed>

    var body: some View {
        NavigationView {
            VStack {
                if dbFeeds.isEmpty {
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
                    }
                } else {
                    List {
                        ForEach(dbFeeds) { dbFeed in
                            NavigationLink {
                                FeedItemsListView(feed: dbFeed)
                            } label: {
                                Text(dbFeed.title)
                            }
                        }
                        .onMove { indexSet, intValue in
                            print("Index set: \(indexSet), IntValue: \(intValue)")
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
            .navigationTitle(L10n.MainPage.title)
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        guard let firstIndex = offsets.first else {
            return
        }

        let itemToDelete = dbFeeds[firstIndex]
        viewContext.delete(itemToDelete)
        try? viewContext.save()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(tabSelectionManager: TabSelectionManager())
    }
}
