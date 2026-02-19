import SwiftUI

struct PromptListRow: View {
    @ObservedObject var prompt: PromptEntity
    @EnvironmentObject var promptVM: PromptViewModel
    @Environment(\.managedObjectContext) var moc
    @State private var showDeleteConfirm = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(prompt.title ?? "Untitled")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Spacer()
                if prompt.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .font(.caption)
                }
            }

            if let content = prompt.content, !content.isEmpty {
                Text(content.preview(maxLength: 80))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            HStack(spacing: 4) {
                if let updatedAt = prompt.updatedAt {
                    Text(updatedAt.relativeDescription)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                Spacer()
                // Show first 2 tags
                let tagList = prompt.tagsArray.prefix(2)
                ForEach(Array(tagList), id: \.objectID) { tag in
                    TagChipSmall(name: tag.name ?? "", colorName: tag.color ?? "blue")
                }
            }
        }
        .padding(.vertical, 2)
        .promptCard(title: prompt.title ?? "Untitled",
                    preview: prompt.content ?? "")
        .contextMenu {
            Button("Copy Content") {
                NSPasteboard.copyText(prompt.content ?? "")
            }
            Button("Duplicate") {
                promptVM.duplicateSelected()
            }
            Button(prompt.isFavorite ? "Remove from Favorites" : "Add to Favorites") {
                promptVM.selectedPromptID = prompt.objectID
                promptVM.toggleFavorite()
            }
            Divider()
            Button("Archive", role: .destructive) {
                promptVM.selectedPromptID = prompt.objectID
                promptVM.archiveSelected()
            }
            Button("Delete", role: .destructive) {
                showDeleteConfirm = true
            }
        }
        .alert("Delete Prompt?", isPresented: $showDeleteConfirm) {
            Button("Delete", role: .destructive) {
                promptVM.deletePrompt(prompt)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete "\(prompt.title ?? "Untitled")" and all its versions.")
        }
    }
}
