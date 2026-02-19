import SwiftUI

struct PromptListToolbar: ToolbarContent {
    @EnvironmentObject var promptVM: PromptViewModel
    @EnvironmentObject var sidebarVM: SidebarViewModel

    var body: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button {
                let folder: FolderEntity?
                if case .folder(let objID) = sidebarVM.selection {
                    folder = try? DataController.shared.viewContext.existingObject(with: objID) as? FolderEntity
                } else {
                    folder = nil
                }
                promptVM.createNewPrompt(in: folder)
            } label: {
                Label("New Prompt", systemImage: "square.and.pencil")
            }
            .help("Create a new prompt (⌘N)")
        }

        ToolbarItem(placement: .automatic) {
            Menu {
                ForEach(PromptViewModel.SortOption.allCases) { option in
                    Button(option.rawValue) {
                        promptVM.sortOrder = option
                    }
                }
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
            .help("Sort prompts")
        }
    }
}
