import SwiftUI

@main
struct NewsHubRssApp: App {
    @Environment(\.scenePhase) private var scenePhase
    let dataController = DataController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .onChange(of: scenePhase, { _, newValue in
            if newValue == .inactive || newValue == .background {
                do {
                    try dataController.container.viewContext.save()
                } catch let error {
                    print(error)
                }
            }
        })
    }
}
