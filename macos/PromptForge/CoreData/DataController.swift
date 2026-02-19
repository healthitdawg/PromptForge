import CoreData
import SwiftUI

final class DataController: ObservableObject {

    // MARK: - Singleton
    static let shared = DataController()

    // MARK: - Container
    let container: NSPersistentContainer

    // MARK: - Published state
    @Published var isLoaded = false
    @Published var loadError: Error?

    // MARK: - View context (main thread)
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    // MARK: - Init
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PromptForge")

        if inMemory {
            container.persistentStoreDescriptions.first?.url =
                URL(filePath: "/dev/null")
        }

        // Enable automatic lightweight migration
        if let description = container.persistentStoreDescriptions.first {
            description.setOption(true as NSNumber,
                forKey: NSMigratePersistentStoresAutomaticallyOption)
            description.setOption(true as NSNumber,
                forKey: NSInferMappingModelAutomaticallyOption)
        }

        container.loadPersistentStores { [weak self] _, error in
            DispatchQueue.main.async {
                if let error {
                    self?.loadError = error
                    return
                }
                self?.container.viewContext.automaticallyMergesChangesFromParent = true
                self?.container.viewContext.mergePolicy =
                    NSMergeByPropertyObjectTrumpMergePolicy
                self?.isLoaded = true

                // Run one-time migration from UserDefaults
                if let self {
                    MigrationService.migrateIfNeeded(context: self.container.viewContext)
                }
            }
        }
    }

    // MARK: - Save
    func save() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
        }
    }

    // MARK: - Background task
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            block(context)
            if context.hasChanges {
                try? context.save()
            }
        }
    }

    // MARK: - Version pruning (keep latest N versions per prompt)
    func pruneVersions(for prompt: PromptEntity, limit: Int = 50) {
        let versions = prompt.versionsArray
        guard versions.count > limit else { return }
        let toDelete = versions.suffix(from: limit)
        toDelete.forEach { viewContext.delete($0) }
        save()
    }

    // MARK: - Preview / test support
    static let preview: DataController = {
        let ctrl = DataController(inMemory: true)
        ctrl.seedPreviewData()
        return ctrl
    }()

    private func seedPreviewData() {
        let ctx = viewContext

        let folder = FolderEntity(context: ctx)
        folder.id = UUID()
        folder.name = "Code"
        folder.sortOrder = 0

        let folder2 = FolderEntity(context: ctx)
        folder2.id = UUID()
        folder2.name = "Writing"
        folder2.sortOrder = 1

        let tag1 = TagEntity(context: ctx)
        tag1.name = "gpt-4"
        tag1.color = "blue"

        let tag2 = TagEntity(context: ctx)
        tag2.name = "creative"
        tag2.color = "purple"

        let prompt1 = PromptEntity(context: ctx)
        prompt1.id = UUID()
        prompt1.title = "Explain async/await"
        prompt1.content = "Explain Swift async/await with practical examples. Show how to use async functions, await expressions, and Task groups."
        prompt1.notes = "Good for onboarding"
        prompt1.createdAt = Date()
        prompt1.updatedAt = Date()
        prompt1.folder = folder
        prompt1.addToTags(tag1)

        let prompt2 = PromptEntity(context: ctx)
        prompt2.id = UUID()
        prompt2.title = "Write a short story"
        prompt2.content = "Write a 500-word short story about an astronaut who discovers a message in a bottle floating in space."
        prompt2.isFavorite = true
        prompt2.createdAt = Date().addingTimeInterval(-86400)
        prompt2.updatedAt = Date().addingTimeInterval(-3600)
        prompt2.folder = folder2
        prompt2.addToTags(tag2)

        try? ctx.save()
    }
}
