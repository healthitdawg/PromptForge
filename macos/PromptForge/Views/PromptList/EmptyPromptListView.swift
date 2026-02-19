import SwiftUI

struct EmptyPromptListView: View {
    let sidebarItem: SidebarItem?
    @EnvironmentObject var promptVM: PromptViewModel

    var body: some View {
        switch sidebarItem {
        case .favorites:
            EmptyStateView(
                icon: "star",
                title: "No Favorites Yet",
                message: "Star a prompt to add it to your favorites.",
                actionTitle: nil,
                action: nil
            )
        case .archived:
            EmptyStateView(
                icon: "archivebox",
                title: "Nothing Archived",
                message: "Archived prompts appear here."
            )
        case .recent:
            EmptyStateView(
                icon: "clock",
                title: "No Recent Activity",
                message: "Prompts updated in the last 7 days appear here.",
                actionTitle: "New Prompt") {
                    promptVM.createNewPrompt()
                }
        default:
            EmptyStateView(
                icon: "doc.text",
                title: "No Prompts",
                message: "Create your first prompt to get started.",
                actionTitle: "New Prompt") {
                    promptVM.createNewPrompt()
                }
        }
    }
}
