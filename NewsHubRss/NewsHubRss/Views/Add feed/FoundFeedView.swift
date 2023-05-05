//
//  FoundFeedView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 3.05.23.
//

import SwiftUI

struct FoundFeedView: View {
    @EnvironmentObject var modelData: ModelData
    private var feedAlreadySaved: Bool {
        let feedsURLs = modelData.feeds.map { $0.link }
        return feedsURLs.contains(feedURLString)
    }
    let feedURLString: String

    var body: some View {
        HStack {
            Text(feedURLString)
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
                    modelData.feeds.append(
                        Feed(
                            id: (modelData.feeds.last?.id ?? 999_999) + 1,
                            title: feedURLString, link: feedURLString
                        )
                    )
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct FoundFeedView_Previews: PreviewProvider {
    static var previews: some View {
        FoundFeedView(feedURLString: "https://foundfeedurl.xyz")
    }
}
