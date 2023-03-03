//
//  AddFeedView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 26.02.23.
//

import SwiftUI

struct AddFeedView: View {
    @State private var feedUrl = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text(L10n.AddNewFeed.instruction)
                    TextField("", text: $feedUrl)
                }
            }
            .navigationTitle(L10n.AddNewFeed.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
