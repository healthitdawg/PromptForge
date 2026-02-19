import SwiftUI

struct PromptTextEditor: View {
    @Binding var text: String
    @EnvironmentObject var promptVM: PromptViewModel

    var body: some View {
        TextEditor(text: $text)
            .font(.system(.body, design: .monospaced))
            .scrollContentBackground(.hidden)
            .background(Color(NSColor.textBackgroundColor))
            .onChange(of: text) {
                promptVM.isDirty = true
            }
    }
}
