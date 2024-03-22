import SwiftUI

enum AppSettings: String {
    case theme
    case useReaderInSafari
    case showImagesForFeedItemsInTheList
}

struct SettingsView: View {
    @AppStorage(AppSettings.theme.rawValue) var theme: String = Theme.system.rawValue
    @AppStorage(AppSettings.useReaderInSafari.rawValue) var useReaderInSafari = true
    @AppStorage(AppSettings.showImagesForFeedItemsInTheList.rawValue) var showImagesForFeedItemsInTheList = true

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(L10n.Settings.Displaying.title)) {
                    Picker(L10n.Settings.Displaying.Theme.title, selection: $theme) {
                        Text(L10n.Settings.Displaying.Theme.System.title).tag(Theme.system.rawValue)
                        Text(L10n.Settings.Displaying.Theme.Dark.title).tag(Theme.dark.rawValue)
                        Text(L10n.Settings.Displaying.Theme.Light.title).tag(Theme.light.rawValue)
                    }
                    Toggle(L10n.Settings.SafariReader.title, isOn: $useReaderInSafari)
                    Toggle(L10n.Settings.ImagesForFeedItemsInTheList.title, isOn: $showImagesForFeedItemsInTheList)
                }
            }
            .navigationTitle(L10n.SettingsPage.title)
        }
    }
}

#Preview {
    SettingsView()
}
