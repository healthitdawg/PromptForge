import SwiftUI

struct RootView: View {
    @EnvironmentObject var promptVM: PromptViewModel
    @EnvironmentObject var sidebarVM: SidebarViewModel
    @EnvironmentObject var importExportVM: ImportExportViewModel
    @EnvironmentObject var dataController: DataController

    @SceneStorage("columnVisibility") var columnVisibility: NavigationSplitViewVisibility = .all
    @AppStorage("appTheme") private var appTheme: String = "system"

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView()
                .navigationSplitViewColumnWidth(min: 180, ideal: 220, max: 280)
        } content: {
            PromptListView()
                .navigationSplitViewColumnWidth(min: 240, ideal: 300, max: 380)
                .searchable(text: $sidebarVM.globalSearch, placement: .sidebar)
        } detail: {
            PromptEditorView()
        }
        .navigationSplitViewStyle(.balanced)
        .preferredColorScheme(colorScheme)
        .focusedSceneObject(promptVM)
        .focusedSceneObject(importExportVM)
        .importExportModifiers()
        .loadingOverlay(importExportVM.isWorking, message: "Processing…")
    }

    private var colorScheme: ColorScheme? {
        switch appTheme {
        case "light": return .light
        case "dark":  return .dark
        default:      return nil
        }
    }
}
