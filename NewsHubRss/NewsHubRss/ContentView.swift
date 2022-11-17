//
//  ContentView.swift
//  NewsHubRss
//
//  Created by Alex Mostovnikov on 7/9/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LazyVGrid(columns: []) {
                }
                .navigationTitle("NewsHubRss")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button {
                        print("Action to open the form")
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
