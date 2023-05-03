//
//  FoundFeedView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 3.05.23.
//

import SwiftUI

struct FoundFeedView: View {
    @EnvironmentObject var modelData: ModelData
    let feedURLString: String

    var body: some View {
        HStack {
            Text(feedURLString)
            Spacer()
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

struct FoundFeedView_Previews: PreviewProvider {
    static var previews: some View {
        FoundFeedView(feedURLString: "https://foundfeedurl.xyz")
    }
}
