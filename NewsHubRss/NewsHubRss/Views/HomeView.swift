//
//  ContentView.swift
//  NewsHubRss
//
//  Created by Alex Mostovnikov on 7/9/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(modelData.feeds) { feed in
                        NavigationLink {
                            FeedItemsListView(feed: feed)
                        } label: {
                            Text(feed.title)
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
            .environmentObject(ModelData())
    }
}
