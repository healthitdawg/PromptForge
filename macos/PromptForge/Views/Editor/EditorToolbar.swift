import SwiftUI

enum EditorPane: String, CaseIterable {
    case editor   = "Editor"
    case markdown = "Preview"
    case llmTest  = "Test LLM"
    case versions = "History"

    var systemImage: String {
        switch self {
        case .editor:   return "pencil"
        case .markdown: return "eye"
        case .llmTest:  return "bubble.left.and.bubble.right"
        case .versions: return "clock.arrow.circlepath"
        }
    }
}

struct EditorToolbar: ToolbarContent {
    @Binding var activePane: EditorPane
    @EnvironmentObject var promptVM: PromptViewModel

    var body: some ToolbarContent {
        // Title field
        ToolbarItem(placement: .principal) {
            TextField("Title", text: $promptVM.draftTitle)
                .textFieldStyle(.plain)
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(minWidth: 200, maxWidth: 400)
                .onChange(of: promptVM.draftTitle) {
                    promptVM.isDirty = true
                }
        }

        // Pane switcher
        ToolbarItem(placement: .primaryAction) {
            Picker("Pane", selection: $activePane) {
                ForEach(EditorPane.allCases, id: \.self) { pane in
                    Label(pane.rawValue, systemImage: pane.systemImage)
                        .tag(pane)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 300)
        }

        // Save button (shown when dirty)
        ToolbarItem(placement: .confirmationAction) {
            Button {
                promptVM.saveCurrentPrompt()
            } label: {
                Label("Save", systemImage: promptVM.isDirty ? "tray.and.arrow.down.fill" : "tray.and.arrow.down")
            }
            .disabled(!promptVM.isDirty || promptVM.selectedPromptID == nil)
            .help("Save prompt (⌘S)")
            .keyboardShortcut("s", modifiers: .command)
        }

        // Actions group
        ToolbarItemGroup(placement: .automatic) {
            Button {
                NSPasteboard.copyText(promptVM.draftContent)
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
            .disabled(promptVM.draftContent.isEmpty)
            .help("Copy prompt content to clipboard")

            Button {
                promptVM.toggleFavorite()
            } label: {
                Label("Favorite",
                      systemImage: promptVM.selectedPrompt?.isFavorite == true ? "star.fill" : "star")
                    .foregroundStyle(promptVM.selectedPrompt?.isFavorite == true ? .yellow : .primary)
            }
            .disabled(promptVM.selectedPromptID == nil)
            .help("Toggle favorite")
        }
    }
}
