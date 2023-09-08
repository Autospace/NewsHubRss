//
//  ContentView.swift
//  NewsHubRss
//
//  Created by Alex Mostovnikov on 7/9/22.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DBFeed.entity(), sortDescriptors: [NSSortDescriptor(key: "sortOrderPosition", ascending: true)])
    private var dbFeeds: FetchedResults<DBFeed>

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(dbFeeds) { dbFeed in
                        NavigationLink {
                            FeedItemsListView(feed: dbFeed)
                        } label: {
                            Text(dbFeed.title)
                        }
                    }
                }
                .toolbar {
                    NavigationLink {
                        AddFeedView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle(L10n.MainPage.title)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
