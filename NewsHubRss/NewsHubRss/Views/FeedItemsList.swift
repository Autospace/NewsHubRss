//
//  FeedItemsList.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 17.04.23.
//

import SwiftUI

struct FeedItemsList: View {
    let feedUrl: String

    var body: some View {
        Text(feedUrl)
    }
}

struct FeedItemsList_Previews: PreviewProvider {
    static var previews: some View {
        FeedItemsList(feedUrl: "Feed URL")
    }
}
