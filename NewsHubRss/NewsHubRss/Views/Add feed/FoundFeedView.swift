//
//  FoundFeedView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 3.05.23.
//

import SwiftUI

struct FoundFeedView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DBFeed.entity(), sortDescriptors: [NSSortDescriptor(key: "sortOrderPosition", ascending: true)])
    private var dbFeeds: FetchedResults<DBFeed>

    private var feedAlreadySaved: Bool {
        let feedsURLs = dbFeeds.map { $0.url }
        return feedsURLs.contains(feedURLString)
    }
    let feedTitle: String
    let feedURLString: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(feedTitle.trimmingCharacters(in: .whitespacesAndNewlines))
                Text(feedURLString)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }

            Spacer()

            if feedAlreadySaved {
                Label {

                } icon: {
                    Image(systemName: "checkmark.square")
                        .shadow(color: .green, radius: 4)
                }
                .foregroundColor(.green)
            } else {
                Button(L10n.Common.add) {
                    let dbFeed = DBFeed(context: viewContext)
                    dbFeed.id = UUID()
                    dbFeed.title = feedTitle
                    dbFeed.url = feedURLString
                    dbFeed.sortOrderPosition = (dbFeeds.last?.sortOrderPosition ?? 0) + 1

                    saveContext()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("An error occured: \(error)")
        }
    }
}

struct FoundFeedView_Previews: PreviewProvider {
    static var previews: some View {
        FoundFeedView(feedTitle: "Test title", feedURLString: "https://foundfeedurl.xyz")
    }
}
