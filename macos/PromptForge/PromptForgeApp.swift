import SwiftUI

@main
struct PromptForgeApp: App {
    @StateObject private var dataController  = DataController.shared
    @StateObject private var promptVM        = PromptViewModel()
    @StateObject private var sidebarVM       = SidebarViewModel()
    @StateObject private var importExportVM  = ImportExportViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, dataController.viewContext)
                .environmentObject(dataController)
                .environmentObject(promptVM)
                .environmentObject(sidebarVM)
                .environmentObject(importExportVM)
                .frame(minWidth: 1000, minHeight: 650)
        }
        .commands {
            AppCommands()
        }

        Settings {
            SettingsView()
        }
    }
}
