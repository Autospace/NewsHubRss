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
                    Label(L10n.MainPage.title, systemImage: "house")
                }

            SettingsView()
                .tabItem {
                    Label(L10n.SettingsPage.title, systemImage: "gear")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .environment(\.locale, .init(identifier: "ru"))
                .environmentObject(ModelData())
        }
    }
}
