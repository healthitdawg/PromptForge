import SwiftUI

struct SmartFolderRow: View {
    let item: SidebarItem
    @EnvironmentObject var sidebarVM: SidebarViewModel

    var body: some View {
        Label(item.title, systemImage: item.systemImage)
            .tag(item)
            .help(helpText)
    }

    private var helpText: String {
        switch item {
        case .allPrompts: return "All non-archived prompts"
        case .favorites:  return "Prompts marked as favorites"
        case .recent:     return "Prompts updated in the last 7 days"
        case .archived:   return "Archived prompts"
        default:          return ""
        }
    }
}
