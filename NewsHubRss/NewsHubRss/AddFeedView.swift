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
                    Text("Insert feed link into the field below")
                    TextField("", text: $feedUrl)
                }
            }
            .navigationTitle("Add feed")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddFeedView_Previews: PreviewProvider {
    static var previews: some View {
        AddFeedView()
    }
}
