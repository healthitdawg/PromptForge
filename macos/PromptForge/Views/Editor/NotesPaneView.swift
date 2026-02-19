import SwiftUI

struct NotesPaneView: View {
    @Binding var notes: String
    @EnvironmentObject var promptVM: PromptViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Label("Notes", systemImage: "note.text")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.top, 8)
            .padding(.bottom, 4)

            Divider()

            TextEditor(text: $notes)
                .font(.system(.body))
                .scrollContentBackground(.hidden)
                .background(Color(NSColor.textBackgroundColor))
                .onChange(of: notes) {
                    promptVM.isDirty = true
                }
        }
        .frame(minWidth: 180, maxWidth: 260)
        .background(Color(NSColor.windowBackgroundColor))
    }
}
