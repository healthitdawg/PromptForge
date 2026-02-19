import SwiftUI

struct FileMenuCommands: Commands {
    @FocusedObject private var promptVM: PromptViewModel?
    @FocusedObject private var importExportVM: ImportExportViewModel?

    var body: some Commands {
        CommandGroup(replacing: .newItem) {
            Button("New Prompt") {
                promptVM?.createNewPrompt()
            }
            .keyboardShortcut("n", modifiers: .command)

            Divider()

            Button("Import from JSON…") {
                importExportVM?.showImportJSON = true
            }
            Button("Import from CSV…") {
                importExportVM?.showImportCSV = true
            }

            Divider()

            Button("Export Selected as JSON…") {
                if let prompt = promptVM?.selectedPrompt {
                    importExportVM?.exportSelectedAsJSON(prompt: prompt)
                }
            }
            .disabled(promptVM?.selectedPromptID == nil)

            Button("Export All as JSON…") {
                importExportVM?.exportAllAsJSON()
            }
        }
    }
}
