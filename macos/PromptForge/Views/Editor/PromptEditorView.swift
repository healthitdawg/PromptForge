import SwiftUI

struct PromptEditorView: View {
    @EnvironmentObject var promptVM: PromptViewModel
    @EnvironmentObject var dataController: DataController
    @AppStorage("appTheme") private var appTheme: String = "system"

    @State private var activePane: EditorPane = .editor

    var body: some View {
        Group {
            if promptVM.selectedPromptID == nil {
                EmptyStateView(
                    icon: "doc.text",
                    title: "No Prompt Selected",
                    message: "Choose a prompt from the list or create a new one.",
                    actionTitle: "New Prompt") {
                        promptVM.createNewPrompt()
                    }
            } else {
                editorContent
            }
        }
        .sheet(isPresented: $promptVM.showVersionHistory) {
            VersionHistoryPanel(promptObjectID: promptVM.selectedPromptID)
                .environmentObject(promptVM)
                .frame(minWidth: 700, minHeight: 480)
        }
        .onChange(of: promptVM.activeLLMPane) {
            if promptVM.activeLLMPane { activePane = .llmTest }
        }
    }

    private var editorContent: some View {
        VStack(spacing: 0) {
            // Pane content
            Group {
                switch activePane {
                case .editor:
                    HSplitView {
                        PromptTextEditor(text: $promptVM.draftContent)
                        if !promptVM.draftNotes.isEmpty || activePane == .editor {
                            NotesPaneView(notes: $promptVM.draftNotes)
                        }
                    }
                case .markdown:
                    MarkdownPreviewPane(content: promptVM.draftContent)
                case .llmTest:
                    LLMTestPane()
                case .versions:
                    VersionHistoryPanel(promptObjectID: promptVM.selectedPromptID)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Divider()

            // Bottom bar: folder picker + tags + char count
            HStack(spacing: 10) {
                FolderPickerView(selectedFolder: $promptVM.draftFolder)
                    .onChange(of: promptVM.draftFolder) { promptVM.isDirty = true }

                Divider()
                    .frame(height: 20)

                TagTokenField(tags: $promptVM.draftTags)

                Spacer()

                CharacterCountLabel(text: promptVM.draftContent)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(NSColor.windowBackgroundColor))
        }
        .toolbar { EditorToolbar(activePane: $activePane) }
        .navigationTitle(promptVM.draftTitle.isEmpty ? "Untitled" : promptVM.draftTitle)
        .navigationSubtitle(promptVM.selectedPrompt?.folder?.name ?? "")
    }
}
