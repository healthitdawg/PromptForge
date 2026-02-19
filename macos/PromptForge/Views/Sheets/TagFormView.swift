import SwiftUI
import CoreData

struct TagFormView: View {
    enum Mode {
        case create
        case edit(TagEntity)
    }

    let mode: Mode
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @State private var name: String = ""
    @State private var selectedColor: String = "blue"

    init(mode: Mode) {
        self.mode = mode
        if case .edit(let tag) = mode {
            _name = State(initialValue: tag.name ?? "")
            _selectedColor = State(initialValue: tag.color ?? "blue")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading, spacing: 6) {
                Text("Name")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                TextField("Tag name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { submit() }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Color")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ColorPickerGrid(selectedColor: $selectedColor)
            }

            // Preview chip
            HStack {
                Spacer()
                TagChipSmall(name: name.isEmpty ? "Preview" : name,
                             colorName: selectedColor)
                Spacer()
            }

            HStack(spacing: 12) {
                Button("Cancel", role: .cancel) { dismiss() }
                    .keyboardShortcut(.escape, modifiers: [])
                Spacer()
                Button(confirmLabel) { submit() }
                    .buttonStyle(.borderedProminent)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    .keyboardShortcut(.return, modifiers: [])
            }
        }
        .padding(24)
        .frame(width: 340)
    }

    private var title: String {
        switch mode { case .create: return "New Tag"; case .edit: return "Edit Tag" }
    }
    private var confirmLabel: String {
        switch mode { case .create: return "Create"; case .edit: return "Save" }
    }

    private func submit() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        switch mode {
        case .create:
            let tag = TagEntity(context: moc)
            tag.name  = trimmed
            tag.color = selectedColor
        case .edit(let tag):
            tag.name  = trimmed
            tag.color = selectedColor
        }
        try? moc.save()
        dismiss()
    }
}
