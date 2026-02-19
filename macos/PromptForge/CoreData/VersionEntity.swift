import CoreData
import Foundation

@objc(VersionEntity)
public class VersionEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var content: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var changeDescription: String?
    @NSManaged public var prompt: PromptEntity?
}

// MARK: - Fetch request
extension VersionEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VersionEntity> {
        return NSFetchRequest<VersionEntity>(entityName: "VersionEntity")
    }
}
