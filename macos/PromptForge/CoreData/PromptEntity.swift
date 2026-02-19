import CoreData
import Foundation

@objc(PromptEntity)
public class PromptEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var notes: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isArchived: Bool
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var folder: FolderEntity?
    @NSManaged public var tags: NSSet?
    @NSManaged public var versions: NSOrderedSet?
}

// MARK: - Fetch request
extension PromptEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PromptEntity> {
        return NSFetchRequest<PromptEntity>(entityName: "PromptEntity")
    }
}

// MARK: - Convenience accessors
extension PromptEntity {
    public var tagsArray: [TagEntity] {
        let set = tags as? Set<TagEntity> ?? []
        return set.sorted { ($0.name ?? "") < ($1.name ?? "") }
    }

    public var versionsArray: [VersionEntity] {
        let ordered = versions?.array as? [VersionEntity] ?? []
        return ordered.sorted { ($0.timestamp ?? Date()) > ($1.timestamp ?? Date()) }
    }

    // MARK: Tag helpers
    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: TagEntity)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: TagEntity)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

    // MARK: Version helpers
    @objc(addVersionsObject:)
    @NSManaged public func addToVersions(_ value: VersionEntity)

    @objc(removeVersionsObject:)
    @NSManaged public func removeFromVersions(_ value: VersionEntity)

    @objc(addVersions:)
    @NSManaged public func addToVersions(_ values: NSOrderedSet)

    @objc(removeVersions:)
    @NSManaged public func removeFromVersions(_ values: NSOrderedSet)
}
