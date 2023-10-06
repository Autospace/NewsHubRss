//
//  FavoritesView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 27.09.23.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: DBFeedItem.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "isFavorite == true")
    )
    private var dbFeedsItems: FetchedResults<DBFeedItem>

    var body: some View {
        List {
            ForEach(dbFeedsItems) { feedItem in
                FeedItemView(
                    title: feedItem.title,
                    date: feedItem.pubDate,
                    hasRead: feedItem.hasRead
                )
            }
        }
    }
}

#Preview {
    FavoritesView()
}
