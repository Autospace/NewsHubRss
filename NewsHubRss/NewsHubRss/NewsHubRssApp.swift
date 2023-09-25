//
//  NewsHubRssApp.swift
//  NewsHubRss
//
//  Created by Alex Mostovnikov on 7/9/22.
//

import SwiftUI

@main
struct NewsHubRssApp: App {
    @Environment(\.scenePhase) private var scenePhase
    let dataController = DataController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .inactive || newValue == .background {
                try? dataController.container.viewContext.save()
            }
        }
    }
}
