//
//  NewsHubRssApp.swift
//  NewsHubRss
//
//  Created by Alex Mostovnikov on 7/9/22.
//

import SwiftUI

@main
struct NewsHubRssApp: App {
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(modelData)
        }
    }
}
