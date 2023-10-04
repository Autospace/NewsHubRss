//
//  FoundFeedView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 3.05.23.
//

import SwiftUI

struct FoundFeedView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme

    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "sortOrderPosition", ascending: true)])
    private var dbFeeds: FetchedResults<DBFeed>
    @State private var showingDeleteFeedAlert: Bool = false

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
                Button(action: {
                    deleteFeed(with: feedURLString)
                }, label: {
                    Image(uiImage: Asset.checkmarkIcon.image.withRenderingMode(.alwaysOriginal))
                        .resizable()
                        .frame(width: 26, height: 26)
                })
                .alert(isPresented: $showingDeleteFeedAlert) {
                    Alert(
                        title: Text(L10n.Common.attention),
                        message: Text(L10n.DeleteFoundFeed.Alert.message),
                        primaryButton: .default(Text(L10n.Common.cancel)),
                        secondaryButton: .destructive(
                            Text(L10n.Common.proceed),
                            action: {
                                deleteFeed(with: feedURLString, force: true)
                            }
                        ))
                }
            } else {
                Button(action: {
                    let dbFeed = DBFeed(context: viewContext)
                    dbFeed.id = UUID()
                    dbFeed.title = feedTitle
                    dbFeed.url = feedURLString
                    dbFeed.sortOrderPosition = (dbFeeds.last?.sortOrderPosition ?? 0) + 1

                    saveContext()
                }, label: {
                    Image(uiImage: Asset.plusIcon.image.withRenderingMode(.alwaysTemplate)
                        .withTintColor(colorScheme == .dark ? .white : .black)
                    )
                    .resizable()
                    .frame(width: 26, height: 26)
                })
            }
        }
    }

    private func deleteFeed(with url: String, force: Bool = false) {
        if let foundFeed = dbFeeds.first(where: {$0.url == feedURLString}) {
            if foundFeed.feedItems.count > 0, !force {
                showingDeleteFeedAlert = true
            } else {
                viewContext.delete(foundFeed)
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
