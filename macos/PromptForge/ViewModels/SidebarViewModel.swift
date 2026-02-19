import CoreData
import SwiftUI

// MARK: - Sidebar Selection Model

enum SidebarItem: Hashable {
    case allPrompts
    case favorites
    case recent
    case archived
    case folder(NSManagedObjectID)
    case tag(NSManagedObjectID)

    var title: String {
        switch self {
        case .allPrompts: return "All Prompts"
        case .favorites:  return "Favorites"
        case .recent:     return "Recent"
        case .archived:   return "Archived"
        case .folder:     return "Folder"
        case .tag:        return "Tag"
        }
    }

    var systemImage: String {
        switch self {
        case .allPrompts: return "doc.text"
        case .favorites:  return "star"
        case .recent:     return "clock"
        case .archived:   return "archivebox"
        case .folder:     return "folder"
        case .tag:        return "tag"
        }
    }
}

// MARK: - ViewModel

@MainActor
final class SidebarViewModel: ObservableObject {
    @Published var selection: SidebarItem? = .allPrompts
    @Published var globalSearch: String = ""
    @Published var showAddFolder = false
    @Published var showAddTag = false
    @Published var folderToRename: FolderEntity?
    @Published var tagToEdit: TagEntity?

    func folderTitle(for entity: FolderEntity) -> String {
        entity.name ?? "Untitled Folder"
    }

    func tagTitle(for entity: TagEntity) -> String {
        entity.name ?? "Untitled Tag"
    }

    func selectFolder(_ folder: FolderEntity) {
        selection = .folder(folder.objectID)
    }

    func selectTag(_ tag: TagEntity) {
        selection = .tag(tag.objectID)
    }
}
