//
//  SettingsView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 26.02.23.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedTheme: Theme = .system

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(L10n.Settings.Displaying.title)) {
                    Picker(L10n.Settings.Displaying.Theme.title, selection: $selectedTheme) {
                        Text(L10n.Settings.Displaying.Theme.System.title).tag(Theme.system)
                        Text(L10n.Settings.Displaying.Theme.Dark.title).tag(Theme.dark)
                        Text(L10n.Settings.Displaying.Theme.Light.title).tag(Theme.light)
                    }
                }
            }
            .navigationTitle(L10n.SettingsPage.title)
        }
    }
}

enum Theme {
    case system
    case dark
    case light
}
