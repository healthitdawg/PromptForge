import CoreData
import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var sidebarVM: SidebarViewModel
    @EnvironmentObject var promptVM: PromptViewModel
    @Environment(\.managedObjectContext) var moc

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.sortOrder), SortDescriptor(\.name)],
        animation: .default)
    private var folders: FetchedResults<FolderEntity>

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name)],
        animation: .default)
    private var tags: FetchedResults<TagEntity>

    var body: some View {
        List(selection: $sidebarVM.selection) {
            // Smart items
            Section("Library") {
                SmartFolderRow(item: .allPrompts)
                SmartFolderRow(item: .favorites)
                SmartFolderRow(item: .recent)
                SmartFolderRow(item: .archived)
            }

            // Folders (top-level only; FolderRow handles nesting)
            Section("Folders") {
                ForEach(folders.filter { $0.parent == nil }) { folder in
                    FolderRow(folder: folder)
                }
                Button {
                    sidebarVM.showAddFolder = true
                } label: {
                    Label("New Folder", systemImage: "folder.badge.plus")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }

            // Tags
            Section("Tags") {
                ForEach(tags) { tag in
                    TagRow(tag: tag)
                }
                Button {
                    sidebarVM.showAddTag = true
                } label: {
                    Label("New Tag", systemImage: "tag.badge.plus")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .listStyle(.sidebar)
        .sheet(isPresented: $sidebarVM.showAddFolder) {
            FolderFormView(mode: .create(parent: nil))
        }
        .sheet(item: $sidebarVM.folderToRename) { folder in
            FolderFormView(mode: .rename(folder))
        }
        .sheet(isPresented: $sidebarVM.showAddTag) {
            TagFormView(mode: .create)
        }
        .sheet(item: $sidebarVM.tagToEdit) { tag in
            TagFormView(mode: .edit(tag))
        }
    }
}
