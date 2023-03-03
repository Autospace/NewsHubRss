//
//  ContentView.swift
//  NewsHubRss
//
//  Created by Alex Mostovnikov on 7/9/22.
//

import SwiftUI

struct HomeView: View {
    @State var navigateToAddFeedScreen = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {}
                .navigationTitle(L10n.MainPage.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button {
                        navigateToAddFeedScreen = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }

                NavigationLink(destination: AddFeedView(), isActive: $navigateToAddFeedScreen) {}
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
