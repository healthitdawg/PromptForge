import CoreData
import Foundation

enum SearchService {

    /// Builds an NSFetchRequest<PromptEntity> driven by sidebar selection + search text + sort.
    static func fetchRequest(
        for sidebarItem: SidebarItem?,
        searchText: String,
        sortOption: PromptViewModel.SortOption,
        context: NSManagedObjectContext
    ) -> NSFetchRequest<PromptEntity> {

        let request: NSFetchRequest<PromptEntity> = PromptEntity.fetchRequest()
        var predicates: [NSPredicate] = []

        // 1. Sidebar filter
        switch sidebarItem {
        case .allPrompts, .none:
            predicates.append(NSPredicate(format: "isArchived == NO"))

        case .favorites:
            predicates.append(NSPredicate(format: "isFavorite == YES AND isArchived == NO"))

        case .recent:
            let cutoff = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            predicates.append(NSPredicate(
                format: "updatedAt >= %@ AND isArchived == NO",
                cutoff as NSDate))

        case .archived:
            predicates.append(NSPredicate(format: "isArchived == YES"))

        case .folder(let objID):
            if let folder = try? context.existingObject(with: objID) as? FolderEntity {
                predicates.append(NSPredicate(format: "folder == %@", folder))
                predicates.append(NSPredicate(format: "isArchived == NO"))
            }

        case .tag(let objID):
            if let tag = try? context.existingObject(with: objID) as? TagEntity {
                predicates.append(NSPredicate(format: "ANY tags == %@", tag))
                predicates.append(NSPredicate(format: "isArchived == NO"))
            }
        }

        // 2. Full-text search (title + content + tag names)
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            let title   = NSPredicate(format: "title CONTAINS[cd] %@", trimmed)
            let content = NSPredicate(format: "content CONTAINS[cd] %@", trimmed)
            let tag     = NSPredicate(format: "ANY tags.name CONTAINS[cd] %@", trimmed)
            predicates.append(NSCompoundPredicate(orPredicateWithSubpredicates: [title, content, tag]))
        }

        request.predicate       = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = sortOption.descriptors
        request.fetchBatchSize  = 50
        return request
    }
}
