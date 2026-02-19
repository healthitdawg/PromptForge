import SwiftUI

struct FolderRow: View {
    @ObservedObject var folder: FolderEntity
    @EnvironmentObject var sidebarVM: SidebarViewModel
    @Environment(\.managedObjectContext) var moc
    @State private var showDeleteConfirm = false

    var body: some View {
        Group {
            if folder.childrenArray.isEmpty {
                Label(folder.name ?? "Folder", systemImage: "folder")
                    .tag(SidebarItem.folder(folder.objectID))
                    .contextMenu { folderContextMenu }
            } else {
                DisclosureGroup {
                    ForEach(folder.childrenArray) { child in
                        FolderRow(folder: child)
                    }
                } label: {
                    Label(folder.name ?? "Folder", systemImage: "folder.fill")
                        .tag(SidebarItem.folder(folder.objectID))
                }
                .contextMenu { folderContextMenu }
            }
        }
        .alert("Delete Folder?", isPresented: $showDeleteConfirm) {
            Button("Delete", role: .destructive) { deleteFolder() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Prompts in this folder will be moved to no folder. This cannot be undone.")
        }
    }

    @ViewBuilder
    private var folderContextMenu: some View {
        Button("Rename Folder") {
            sidebarVM.folderToRename = folder
        }
        Button("New Subfolder") {
            sidebarVM.showAddFolder = true
        }
        Divider()
        Button("Delete Folder", role: .destructive) {
            showDeleteConfirm = true
        }
    }

    private func deleteFolder() {
        moc.delete(folder)
        try? moc.save()
    }
}
