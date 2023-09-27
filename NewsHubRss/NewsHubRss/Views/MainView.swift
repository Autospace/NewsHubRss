//
//  MainView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 26.02.23.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: Tab = .home

    enum Tab {
        case home, other, add, favorites, settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(uiImage: selectedTab == .home
                          ? Asset.homeIconSelected.image.withRenderingMode(.alwaysOriginal)
                          : Asset.homeIcon.image.withRenderingMode(.alwaysOriginal))
                }
                .tag(Tab.home)
            
            OtherView()
                .tabItem {
                    Image(uiImage: selectedTab == .other
                          ? Asset.otherIconSelected.image.withRenderingMode(.alwaysOriginal)
                          : Asset.otherIcon.image.withRenderingMode(.alwaysOriginal))
                }
                .tag(Tab.other)

            AddFeedView()
                .tabItem {
                    Image(uiImage: selectedTab == .add
                          ? Asset.addIconSelected.image.withRenderingMode(.alwaysOriginal)
                          : Asset.addIcon.image.withRenderingMode(.alwaysOriginal))
                }
                .tag(Tab.add)

            FavoritesView()
                .tabItem {
                    Image(uiImage: selectedTab == .favorites
                          ? Asset.bookmarkIconSelected.image.withRenderingMode(.alwaysOriginal)
                          : Asset.bookmarkIcon.image.withRenderingMode(.alwaysOriginal))
                }
                .tag(Tab.favorites)

            SettingsView()
                .tabItem {
                    Image(uiImage: selectedTab == .settings
                          ? Asset.settingsIconSelected.image.withRenderingMode(.alwaysOriginal)
                          : Asset.settingsIcon.image.withRenderingMode(.alwaysOriginal))
                }
                .tag(Tab.settings)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .environment(\.locale, .init(identifier: "ru"))
        }
    }
}
