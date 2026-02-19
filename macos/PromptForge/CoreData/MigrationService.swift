import CoreData
import Foundation

/// One-time migration from UserDefaults (v1) to Core Data (v2).
/// Reads legacy JSON from UserDefaults and inserts it into the provided context.
/// Sets a flag in UserDefaults so it only runs once.
enum MigrationService {

    private static let migrationKey = "v2_coredata_migration_complete"

    static func migrateIfNeeded(context: NSManagedObjectContext) {
        guard !UserDefaults.standard.bool(forKey: migrationKey) else { return }

        // Decode legacy prompts
        guard let promptsData = UserDefaults.standard.data(forKey: "savedPrompts"),
              let legacyPrompts = try? JSONDecoder().decode([LegacyPrompt].self, from: promptsData),
              !legacyPrompts.isEmpty
        else {
            // No legacy data — mark migration complete and return
            UserDefaults.standard.set(true, forKey: migrationKey)
            return
        }

        // Decode legacy categories
        let legacyCategories: [LegacyCategory]
        if let catData = UserDefaults.standard.data(forKey: "savedCategories"),
           let cats = try? JSONDecoder().decode([LegacyCategory].self, from: catData) {
            legacyCategories = cats
        } else {
            legacyCategories = []
        }

        // Create FolderEntity for each old Category
        var folderMap: [UUID: FolderEntity] = [:]
        for (index, cat) in legacyCategories.enumerated() {
            let folder = FolderEntity(context: context)
            folder.id = cat.id
            folder.name = cat.name
            folder.sortOrder = Int32(index)
            folderMap[cat.id] = folder
        }

        // Create PromptEntity for each old Prompt
        for legacy in legacyPrompts {
            let prompt = PromptEntity(context: context)
            prompt.id = legacy.id
            prompt.title = legacy.title
            prompt.content = legacy.content
            prompt.notes = nil
            prompt.isFavorite = false
            prompt.isArchived = false
            prompt.createdAt = legacy.createdAt
            prompt.updatedAt = legacy.updatedAt

            // Map old categoryId → folder
            if let catId = legacy.categoryId {
                prompt.folder = folderMap[catId]
            }

            // Map old tag strings → TagEntity
            for tagName in legacy.tags where !tagName.isEmpty {
                let tag = findOrCreateTag(name: tagName, context: context)
                prompt.addToTags(tag)
            }
        }

        // Save and mark complete
        try? context.save()
        UserDefaults.standard.set(true, forKey: migrationKey)
    }

    private static func findOrCreateTag(name: String, context: NSManagedObjectContext) -> TagEntity {
        let request: NSFetchRequest<TagEntity> = TagEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1
        if let existing = (try? context.fetch(request))?.first {
            return existing
        }
        let tag = TagEntity(context: context)
        tag.name = name
        tag.color = "blue"
        return tag
    }
}

// MARK: - Legacy Codable types (mirrors old Models.swift)
private struct LegacyPrompt: Decodable {
    let id: UUID
    let title: String
    let content: String
    let categoryId: UUID?
    let tags: [String]
    let createdAt: Date
    let updatedAt: Date
}

private struct LegacyCategory: Decodable {
    let id: UUID
    let name: String
    let color: String
}
