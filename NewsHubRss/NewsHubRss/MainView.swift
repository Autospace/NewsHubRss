//
//  MainView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 26.02.23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("mainPage.title", systemImage: "house")
                }

            SettingsView()
                .tabItem {
                    Label("settingsPage.title", systemImage: "gear")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .environment(\.locale, .init(identifier: "en"))

            MainView()
                .environment(\.locale, .init(identifier: "ru"))
        }
    }
}
