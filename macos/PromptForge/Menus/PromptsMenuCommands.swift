import SwiftUI

struct PromptsMenuCommands: Commands {
    @FocusedObject private var promptVM: PromptViewModel?

    var body: some Commands {
        CommandMenu("Prompts") {
            Button("Save Prompt") {
                promptVM?.saveCurrentPrompt()
            }
            .keyboardShortcut("s", modifiers: .command)
            .disabled(promptVM?.selectedPromptID == nil)

            Divider()

            Button("Add to Favorites") {
                promptVM?.toggleFavorite()
            }
            .keyboardShortcut("l", modifiers: [.command, .shift])
            .disabled(promptVM?.selectedPromptID == nil)

            Button("Archive Prompt") {
                promptVM?.archiveSelected()
            }
            .disabled(promptVM?.selectedPromptID == nil)

            Button("Duplicate Prompt") {
                promptVM?.duplicateSelected()
            }
            .keyboardShortcut("d", modifiers: .command)
            .disabled(promptVM?.selectedPromptID == nil)

            Divider()

            Button("Test with LLM…") {
                promptVM?.activeLLMPane = true
            }
            .keyboardShortcut("t", modifiers: [.command, .shift])
            .disabled(promptVM?.selectedPromptID == nil)

            Divider()

            Button("Version History…") {
                promptVM?.showVersionHistory = true
            }
            .disabled(promptVM?.selectedPromptID == nil)
        }
    }
}
