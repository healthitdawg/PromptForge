import CoreData
import Foundation

@objc(FolderEntity)
public class FolderEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var sortOrder: Int32
    @NSManaged public var parent: FolderEntity?
    @NSManaged public var children: NSSet?
    @NSManaged public var prompts: NSSet?
}

// MARK: - Fetch request
extension FolderEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FolderEntity> {
        return NSFetchRequest<FolderEntity>(entityName: "FolderEntity")
    }
}

// MARK: - Convenience accessors
extension FolderEntity {
    public var childrenArray: [FolderEntity] {
        let set = children as? Set<FolderEntity> ?? []
        return set.sorted {
            if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
            return ($0.name ?? "") < ($1.name ?? "")
        }
    }

    public var promptsArray: [PromptEntity] {
        let set = prompts as? Set<PromptEntity> ?? []
        return set.sorted { ($0.updatedAt ?? Date()) > ($1.updatedAt ?? Date()) }
    }

    // MARK: Children helpers
    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: FolderEntity)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: FolderEntity)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

    // MARK: Prompts helpers
    @objc(addPromptsObject:)
    @NSManaged public func addToPrompts(_ value: PromptEntity)

    @objc(removePromptsObject:)
    @NSManaged public func removeFromPrompts(_ value: PromptEntity)

    @objc(addPrompts:)
    @NSManaged public func addToPrompts(_ values: NSSet)

    @objc(removePrompts:)
    @NSManaged public func removeFromPrompts(_ values: NSSet)
}
