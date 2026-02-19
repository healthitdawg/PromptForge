import CoreData
import Foundation

@objc(TagEntity)
public class TagEntity: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var color: String?
    @NSManaged public var prompts: NSSet?
}

// MARK: - Fetch request
extension TagEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagEntity> {
        return NSFetchRequest<TagEntity>(entityName: "TagEntity")
    }
}

// MARK: - Convenience accessors
extension TagEntity {
    public var promptsArray: [PromptEntity] {
        let set = prompts as? Set<PromptEntity> ?? []
        return set.sorted { ($0.title ?? "") < ($1.title ?? "") }
    }

    @objc(addPromptsObject:)
    @NSManaged public func addToPrompts(_ value: PromptEntity)

    @objc(removePromptsObject:)
    @NSManaged public func removeFromPrompts(_ value: PromptEntity)

    @objc(addPrompts:)
    @NSManaged public func addToPrompts(_ values: NSSet)

    @objc(removePrompts:)
    @NSManaged public func removeFromPrompts(_ values: NSSet)
}
