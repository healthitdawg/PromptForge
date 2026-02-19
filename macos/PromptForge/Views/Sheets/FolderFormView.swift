import SwiftUI
import CoreData

struct FolderFormView: View {
    enum Mode {
        case create(parent: FolderEntity?)
        case rename(FolderEntity)
    }

    let mode: Mode
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @State private var name: String = ""

    init(mode: Mode) {
        self.mode = mode
        if case .rename(let folder) = mode {
            _name = State(initialValue: folder.name ?? "")
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)

            TextField("Folder name", text: $name)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
                .onSubmit { submit() }

            HStack(spacing: 12) {
                Button("Cancel", role: .cancel) { dismiss() }
                    .keyboardShortcut(.escape, modifiers: [])
                Button(confirmLabel) { submit() }
                    .buttonStyle(.borderedProminent)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    .keyboardShortcut(.return, modifiers: [])
            }
        }
        .padding(24)
        .frame(width: 360)
    }

    private var title: String {
        switch mode {
        case .create(let parent):
            return parent == nil ? "New Folder" : "New Subfolder"
        case .rename:
            return "Rename Folder"
        }
    }

    private var confirmLabel: String {
        switch mode {
        case .create: return "Create"
        case .rename: return "Rename"
        }
    }

    private func submit() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        switch mode {
        case .create(let parent):
            let folder = FolderEntity(context: moc)
            folder.id = UUID()
            folder.name = trimmed
            folder.parent = parent
            folder.sortOrder = Int32((parent?.childrenArray.count ?? 0))
        case .rename(let folder):
            folder.name = trimmed
        }
        try? moc.save()
        dismiss()
    }
}
