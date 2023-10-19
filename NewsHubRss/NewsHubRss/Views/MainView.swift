//
//  MainView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 26.02.23.
//

import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedTab: Tab = .home
    @AppStorage(AppSettings.theme.rawValue) var theme: String = Theme.system.rawValue

    enum Tab {
        case home, other, add, favorites, settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(uiImage: selectedTab == .home
                          ? Asset.homeIconSelected.image.withRenderingMode(.alwaysOriginal)
                          : Asset.homeIcon.image.withRenderingMode(.alwaysTemplate)
                                .withTintColor(colorScheme == .dark ? .white : .black))
                }
                .tag(Tab.home)

            OtherView()
                .tabItem {
                    Image(uiImage: selectedTab == .other
                          ? Asset.otherIconSelected.image.withRenderingMode(.alwaysOriginal)
                          : Asset.otherIcon.image.withRenderingMode(.alwaysTemplate)
                                .withTintColor(colorScheme == .dark ? .white : .black))
                }
                .tag(Tab.other)

            AddFeedView()
                .tabItem {
                    Image(uiImage: selectedTab == .add
                          ? Asset.addIconSelected.image.withRenderingMode(.alwaysOriginal)
                          : Asset.addIcon.image.withRenderingMode(.alwaysTemplate)
                                .withTintColor(colorScheme == .dark ? .white : .black))
                }
                .tag(Tab.add)

            FavoritesView()
                .tabItem {
                    Image(uiImage: selectedTab == .favorites
                          ? Asset.bookmarkIconSelected.image.withRenderingMode(.alwaysOriginal)
                          : Asset.bookmarkIcon.image.withRenderingMode(.alwaysTemplate)
                                .withTintColor(colorScheme == .dark ? .white : .black))
                }
                .tag(Tab.favorites)

            SettingsView()
                .tabItem {
                    Image(uiImage: selectedTab == .settings
                          ? Asset.settingsIconSelected.image.withRenderingMode(.alwaysOriginal)
                          : Asset.settingsIcon.image.withRenderingMode(.alwaysOriginal)
                                .withTintColor(colorScheme == .dark ? .white : .black))
                }
                .tag(Tab.settings)
        }
        .if(theme != Theme.system.rawValue, transform: { view in
            view.preferredColorScheme(theme == Theme.dark.rawValue ? .dark : .light)
        })
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
