import SwiftUI

final class TabSelectionManager: ObservableObject {
    @Published var selectedTab: MainView.Tab = .home
}

struct MainView: View {
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage(AppSettings.theme.rawValue) var theme: String = Theme.system.rawValue
    @StateObject private var tabSelectionManager = TabSelectionManager()

    enum Tab {
        case home, other, add, favorites, settings
    }

    var body: some View {
        TabView(selection: $tabSelectionManager.selectedTab) {
            HomeView(tabSelectionManager: tabSelectionManager)
                .tabItem {
                    Image(uiImage: tabSelectionManager.selectedTab == .home
                          ? Asset.homeIconSelected.image.withRenderingMode(.alwaysOriginal)
                          : Asset.homeIcon.image.withRenderingMode(.alwaysOriginal)
                                .withTintColor(colorScheme == .dark ? .white : .black))
                }
                .tag(Tab.home)

            AddFeedView()
                .tabItem {
                    Image(uiImage: tabSelectionManager.selectedTab == .add
                          ? Asset.addIconSelected.image.withRenderingMode(.alwaysOriginal)
                          : Asset.addIcon.image.withRenderingMode(.alwaysOriginal)
                                .withTintColor(colorScheme == .dark ? .white : .black))
                }
                .tag(Tab.add)

            FavoritesView()
                .tabItem {
                    Image(uiImage: tabSelectionManager.selectedTab == .favorites
                          ? Asset.bookmarkIconSelected.image.withRenderingMode(.alwaysOriginal)
                          : Asset.bookmarkIcon.image.withRenderingMode(.alwaysOriginal)
                                .withTintColor(colorScheme == .dark ? .white : .black))
                }
                .tag(Tab.favorites)

            SettingsView()
                .tabItem {
                    Image(uiImage: tabSelectionManager.selectedTab == .settings
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
                .environment(\.locale, .init(identifier: "en"))
        }
    }
}
