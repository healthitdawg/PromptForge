import CoreData
import Foundation

// MARK: - Identifiable conformances for sheet(item:) and ForEach support
// PromptEntity, FolderEntity, VersionEntity each have @NSManaged var id: UUID?
// which Swift uses to satisfy Identifiable (ID = UUID?).
// TagEntity uses name as its unique key.

extension PromptEntity: Identifiable {}
extension FolderEntity: Identifiable {}
extension VersionEntity: Identifiable {}

extension TagEntity: Identifiable {
    /// Tags are unique by name, so use name as the Identifiable key.
    public var id: String { name ?? objectID.uriRepresentation().absoluteString }
}
