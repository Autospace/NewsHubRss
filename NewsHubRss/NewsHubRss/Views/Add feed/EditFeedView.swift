//
//  EditFeedView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 5.10.23.
//

import SwiftUI

struct EditFeedView: View {
    @State private var feedTitle: String = ""
    let feed: FoundFeed
    let saveHandler: ((_ title: String) -> Void)

    var body: some View {
        VStack {
            TextField(feed.title, text: $feedTitle)
                .padding()
                .border(.gray)
            Text(feed.link)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)

            Spacer()

            Button {
                saveHandler(feedTitle)
            } label: {
                Text(L10n.Common.save)
            }
        }
        .padding()
        .onAppear {
            feedTitle = feed.title
        }
    }
}

#Preview {
    EditFeedView(feed: FoundFeed(id: 0, title: "Test title", link: "https://test.link"), saveHandler: { _ in })
}
