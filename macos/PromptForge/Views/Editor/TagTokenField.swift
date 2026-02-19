import SwiftUI
import CoreData

/// A SwiftUI tag editor showing chips for each tag with an add button.
struct TagTokenField: View {
    @Binding var tags: [TagEntity]
    @EnvironmentObject var promptVM: PromptViewModel
    @EnvironmentObject var dataController: DataController

    @State private var showTagPicker = false
    @State private var newTagName = ""

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name)],
        animation: .default)
    private var allTags: FetchedResults<TagEntity>

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(tags, id: \.objectID) { tag in
                    TagChip(tag: tag) {
                        tags.removeAll { $0.objectID == tag.objectID }
                        promptVM.isDirty = true
                    }
                }

                Button {
                    showTagPicker.toggle()
                } label: {
                    Label("Add Tag", systemImage: "plus")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.quaternary, in: Capsule())
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showTagPicker, arrowEdge: .bottom) {
                    tagPickerPopover
                }
            }
            .padding(.vertical, 2)
        }
    }

    private var tagPickerPopover: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tags")
                .font(.headline)
                .padding(.top, 4)

            // Search / create new
            HStack {
                TextField("New tag name…", text: $newTagName)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 160)
                    .onSubmit { addNewTag() }

                Button("Add", action: addNewTag)
                    .buttonStyle(.borderedProminent)
                    .disabled(newTagName.trimmingCharacters(in: .whitespaces).isEmpty)
            }

            Divider()

            // Existing tags list
            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(allTags) { tag in
                        let isSelected = tags.contains(where: { $0.objectID == tag.objectID })
                        HStack {
                            Circle()
                                .fill(Color.from(name: tag.color))
                                .frame(width: 8, height: 8)
                            Text(tag.name ?? "")
                            Spacer()
                            if isSelected {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                                    .font(.caption)
                            }
                        }
                        .contentShape(Rectangle())
                        .padding(.vertical, 3)
                        .padding(.horizontal, 4)
                        .background(isSelected ? Color.blue.opacity(0.1) : Color.clear,
                                    in: RoundedRectangle(cornerRadius: 4))
                        .onTapGesture { toggleTag(tag) }
                    }
                }
                .frame(width: 200)
            }
            .frame(maxHeight: 200)
        }
        .padding()
        .frame(width: 240)
    }

    private func toggleTag(_ tag: TagEntity) {
        if let idx = tags.firstIndex(where: { $0.objectID == tag.objectID }) {
            tags.remove(at: idx)
        } else {
            tags.append(tag)
        }
        promptVM.isDirty = true
    }

    private func addNewTag() {
        let name = newTagName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }
        let tag = promptVM.findOrCreateTag(named: name)
        if !tags.contains(where: { $0.objectID == tag.objectID }) {
            tags.append(tag)
        }
        newTagName = ""
        promptVM.isDirty = true
    }
}
