import CoreData
import SwiftUI

@MainActor
final class PromptViewModel: ObservableObject {

    // MARK: - Selection
    @Published var selectedPromptID: NSManagedObjectID?

    var selectedPrompt: PromptEntity? {
        guard let id = selectedPromptID else { return nil }
        return try? DataController.shared.viewContext.existingObject(with: id) as? PromptEntity
    }

    // MARK: - Draft state (in-flight edits, isolated from Core Data)
    @Published var draftTitle: String = ""
    @Published var draftContent: String = ""
    @Published var draftNotes: String = ""
    @Published var draftTags: [TagEntity] = []
    @Published var draftFolder: FolderEntity?
    @Published var isDirty: Bool = false

    // MARK: - Sort & filter
    @Published var sortOrder: SortOption = .updatedDescending

    // MARK: - UI state flags
    @Published var showImportJSON = false
    @Published var showImportCSV = false
    @Published var showExportJSON = false
    @Published var showExportAll = false
    @Published var showVersionHistory = false
    @Published var showGenerateVariation = false
    @Published var showFindReplace = false
    @Published var activeLLMPane = false
    @Published var showDeleteConfirm = false

    // MARK: - Dependencies
    private let dataController: DataController

    init(dataController: DataController = .shared) {
        self.dataController = dataController
    }

    // MARK: - Sort Options
    enum SortOption: String, CaseIterable, Identifiable {
        case updatedDescending = "Recently Updated"
        case updatedAscending  = "Oldest Updated"
        case createdDescending = "Recently Created"
        case titleAscending    = "Title A–Z"

        var id: String { rawValue }

        var descriptors: [NSSortDescriptor] {
            switch self {
            case .updatedDescending:
                return [NSSortDescriptor(key: "updatedAt", ascending: false)]
            case .updatedAscending:
                return [NSSortDescriptor(key: "updatedAt", ascending: true)]
            case .createdDescending:
                return [NSSortDescriptor(key: "createdAt", ascending: false)]
            case .titleAscending:
                return [NSSortDescriptor(key: "title", ascending: true,
                                         selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
            }
        }
    }

    // MARK: - Draft Lifecycle

    func loadDraft() {
        guard let prompt = selectedPrompt else {
            clearDraft()
            return
        }
        draftTitle   = prompt.title   ?? ""
        draftContent = prompt.content ?? ""
        draftNotes   = prompt.notes   ?? ""
        draftTags    = prompt.tagsArray
        draftFolder  = prompt.folder
        isDirty      = false
    }

    func clearDraft() {
        draftTitle   = ""
        draftContent = ""
        draftNotes   = ""
        draftTags    = []
        draftFolder  = nil
        isDirty      = false
    }

    // MARK: - CRUD

    func createNewPrompt(in folder: FolderEntity? = nil) {
        let ctx = dataController.viewContext
        let prompt = PromptEntity(context: ctx)
        prompt.id        = UUID()
        prompt.title     = "New Prompt"
        prompt.content   = ""
        prompt.createdAt = Date()
        prompt.updatedAt = Date()
        prompt.folder    = folder
        dataController.save()
        selectedPromptID = prompt.objectID
        loadDraft()
    }

    func saveCurrentPrompt() {
        guard let prompt = selectedPrompt else { return }

        // Snapshot current content as a new version (captures state before this save)
        let previousContent = prompt.content ?? ""
        if !previousContent.isEmpty {
            let version = VersionEntity(context: dataController.viewContext)
            version.id                = UUID()
            version.content           = previousContent
            version.timestamp         = Date()
            version.changeDescription = "Saved"
            version.prompt            = prompt
        }

        prompt.title     = draftTitle
        prompt.content   = draftContent
        prompt.notes     = draftNotes.isEmpty ? nil : draftNotes
        prompt.updatedAt = Date()
        prompt.folder    = draftFolder

        // Sync tags
        let currentTags = Set(prompt.tagsArray)
        let newTags     = Set(draftTags)
        currentTags.subtracting(newTags).forEach { prompt.removeFromTags($0) }
        newTags.subtracting(currentTags).forEach { prompt.addToTags($0) }

        dataController.save()
        isDirty = false

        // Prune old versions
        dataController.pruneVersions(for: prompt, limit: 50)
    }

    func deletePrompt(_ prompt: PromptEntity) {
        if selectedPromptID == prompt.objectID {
            selectedPromptID = nil
            clearDraft()
        }
        dataController.viewContext.delete(prompt)
        dataController.save()
    }

    func duplicateSelected() {
        guard let original = selectedPrompt else { return }
        let ctx = dataController.viewContext
        let copy = PromptEntity(context: ctx)
        copy.id        = UUID()
        copy.title     = (original.title ?? "") + " (Copy)"
        copy.content   = original.content ?? ""
        copy.notes     = original.notes
        copy.createdAt = Date()
        copy.updatedAt = Date()
        copy.folder    = original.folder
        original.tagsArray.forEach { copy.addToTags($0) }
        dataController.save()
        selectedPromptID = copy.objectID
        loadDraft()
    }

    func toggleFavorite() {
        guard let prompt = selectedPrompt else { return }
        prompt.isFavorite.toggle()
        prompt.updatedAt = Date()
        dataController.save()
    }

    func archiveSelected() {
        guard let prompt = selectedPrompt else { return }
        prompt.isArchived = true
        prompt.updatedAt  = Date()
        dataController.save()
        if selectedPromptID == prompt.objectID {
            selectedPromptID = nil
            clearDraft()
        }
    }

    func unarchivePrompt(_ prompt: PromptEntity) {
        prompt.isArchived = false
        prompt.updatedAt  = Date()
        dataController.save()
    }

    // MARK: - Version Restore

    func restoreVersion(_ version: VersionEntity) {
        guard let prompt = selectedPrompt else { return }

        // Snapshot current state first
        let snapshot = VersionEntity(context: dataController.viewContext)
        snapshot.id                = UUID()
        snapshot.content           = prompt.content ?? ""
        snapshot.timestamp         = Date()
        snapshot.changeDescription = "Before restore"
        snapshot.prompt            = prompt

        prompt.content   = version.content
        prompt.updatedAt = Date()
        dataController.save()
        loadDraft()
    }

    // MARK: - Tag helpers

    func findOrCreateTag(named name: String) -> TagEntity {
        let ctx = dataController.viewContext
        let req: NSFetchRequest<TagEntity> = TagEntity.fetchRequest()
        req.predicate = NSPredicate(format: "name ==[c] %@", name)
        req.fetchLimit = 1
        if let existing = (try? ctx.fetch(req))?.first { return existing }
        let tag = TagEntity(context: ctx)
        tag.name  = name
        tag.color = "blue"
        return tag
    }
}
