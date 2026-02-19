import SwiftUI
import CoreData

struct FolderPickerView: View {
    @Binding var selectedFolder: FolderEntity?

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.sortOrder), SortDescriptor(\.name)],
        predicate: NSPredicate(format: "parent == nil"),
        animation: .default)
    private var topFolders: FetchedResults<FolderEntity>

    var body: some View {
        Menu {
            Button("None") { selectedFolder = nil }
            Divider()
            folderMenuItems(folders: Array(topFolders), depth: 0)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "folder")
                Text(selectedFolder?.name ?? "No Folder")
                    .lineLimit(1)
                Image(systemName: "chevron.down")
                    .font(.caption2)
            }
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func folderMenuItems(folders: [FolderEntity], depth: Int) -> some View {
        ForEach(folders) { folder in
            let indent = String(repeating: "  ", count: depth)
            let isSelected = selectedFolder?.objectID == folder.objectID
            Button("\(indent)\(isSelected ? "✓ " : "")\(folder.name ?? "Folder")") {
                selectedFolder = folder
            }
            if !folder.childrenArray.isEmpty {
                folderMenuItems(folders: folder.childrenArray, depth: depth + 1)
            }
        }
    }
}
