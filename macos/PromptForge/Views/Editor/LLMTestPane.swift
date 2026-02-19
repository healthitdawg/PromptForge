import SwiftUI

struct LLMTestPane: View {
    @EnvironmentObject var promptVM: PromptViewModel
    @StateObject private var llmVM = LLMViewModel()
    @State private var systemPromptExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            // Top controls
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("LLM Test")
                        .font(.headline)
                    Spacer()
                    Picker("Model", selection: $llmVM.selectedModel) {
                        ForEach(llmVM.availableModels, id: \.self) { Text($0) }
                    }
                    .frame(maxWidth: 160)
                    .help("Select the model to test with")
                }

                DisclosureGroup("System Prompt", isExpanded: $systemPromptExpanded) {
                    TextEditor(text: $llmVM.systemPrompt)
                        .font(.system(.footnote, design: .monospaced))
                        .frame(height: 60)
                        .scrollContentBackground(.hidden)
                        .background(Color(NSColor.controlBackgroundColor))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .font(.subheadline)

                HStack {
                    Button("Run Test") {
                        llmVM.runTest(prompt: promptVM.draftContent)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(llmVM.isLoading || promptVM.draftContent.isEmpty)
                    .keyboardShortcut(.return, modifiers: [.command, .shift])

                    if llmVM.isLoading {
                        Button("Cancel", action: llmVM.cancel)
                            .buttonStyle(.bordered)
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(0.7)
                    } else if !llmVM.responseText.isEmpty || llmVM.error != nil {
                        Button("Clear", action: llmVM.clearResponse)
                            .buttonStyle(.bordered)
                    }

                    Spacer()

                    if !KeychainService.shared.hasAPIKey() {
                        Text("No API key set")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                }
            }
            .padding()

            Divider()

            // Response area
            ScrollView {
                if let error = llmVM.error {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundStyle(.red)
                        Text(error)
                            .foregroundStyle(.red)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else if llmVM.responseText.isEmpty && !llmVM.isLoading {
                    EmptyStateView(
                        icon: "bubble.left.and.bubble.right",
                        title: "No Response Yet",
                        message: "Click \"Run Test\" to send the current prompt content to the LLM."
                    )
                } else {
                    Text(llmVM.responseText)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
}
