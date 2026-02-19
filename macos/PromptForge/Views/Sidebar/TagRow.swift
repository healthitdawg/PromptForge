import SwiftUI

struct TagRow: View {
    @ObservedObject var tag: TagEntity
    @EnvironmentObject var sidebarVM: SidebarViewModel
    @Environment(\.managedObjectContext) var moc
    @State private var showDeleteConfirm = false

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.from(name: tag.color))
                .frame(width: 8, height: 8)
            Text(tag.name ?? "Tag")
                .lineLimit(1)
        }
        .tag(SidebarItem.tag(tag.objectID))
        .contextMenu {
            Button("Edit Tag") {
                sidebarVM.tagToEdit = tag
            }
            Divider()
            Button("Delete Tag", role: .destructive) {
                showDeleteConfirm = true
            }
        }
        .alert("Delete Tag?", isPresented: $showDeleteConfirm) {
            Button("Delete", role: .destructive) {
                moc.delete(tag)
                try? moc.save()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("The tag will be removed from all prompts.")
        }
    }
}
