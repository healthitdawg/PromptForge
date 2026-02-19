import SwiftUI

struct EditMenuCommands: Commands {
    @FocusedObject private var promptVM: PromptViewModel?

    var body: some Commands {
        // Undo / Redo / Cut / Copy / Paste provided automatically.
        // Add app-specific items after the pasteboard group.
        CommandGroup(after: .pasteboard) {
            Divider()

            Button("Duplicate Prompt") {
                promptVM?.duplicateSelected()
            }
            .keyboardShortcut("d", modifiers: .command)
            .disabled(promptVM?.selectedPromptID == nil)

            Button("Find / Replace…") {
                promptVM?.showFindReplace = true
            }
            .keyboardShortcut("f", modifiers: [.command, .option])
        }
    }
}
