import CoreData
import Foundation

// MARK: - Transfer Models

struct PromptTransfer: Codable {
    var id: UUID
    var title: String
    var content: String
    var notes: String?
    var isFavorite: Bool
    var createdAt: Date
    var updatedAt: Date
    var tags: [TagTransfer]
    var folderName: String?
    var versions: [VersionTransfer]

    init(from entity: PromptEntity) {
        id         = entity.id ?? UUID()
        title      = entity.title ?? ""
        content    = entity.content ?? ""
        notes      = entity.notes
        isFavorite = entity.isFavorite
        createdAt  = entity.createdAt ?? Date()
        updatedAt  = entity.updatedAt ?? Date()
        tags       = entity.tagsArray.map { TagTransfer(from: $0) }
        folderName = entity.folder?.name
        versions   = entity.versionsArray.map { VersionTransfer(from: $0) }
    }
}

struct TagTransfer: Codable {
    var name: String
    var color: String

    init(from entity: TagEntity) {
        name  = entity.name  ?? ""
        color = entity.color ?? "blue"
    }
}

struct VersionTransfer: Codable {
    var id: UUID
    var content: String
    var timestamp: Date
    var changeDescription: String

    init(from entity: VersionEntity) {
        id                = entity.id ?? UUID()
        content           = entity.content ?? ""
        timestamp         = entity.timestamp ?? Date()
        changeDescription = entity.changeDescription ?? "Saved"
    }
}

struct PromptForgeExportBundle: Codable {
    var exportedAt: Date
    var appVersion: String
    var prompts: [PromptTransfer]
}

// MARK: - Export Service

final class ExportService {

    // MARK: JSON
    func exportToJSON(prompts: [PromptEntity]) throws -> Data {
        let transfers = prompts.map { PromptTransfer(from: $0) }
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let bundle = PromptForgeExportBundle(
            exportedAt: Date(),
            appVersion: version,
            prompts: transfers
        )
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(bundle)
    }

    // MARK: CSV (flat, no version history)
    func exportToCSV(prompts: [PromptEntity]) -> String {
        var lines = ["id,title,content,notes,tags,folder,isFavorite,createdAt,updatedAt"]
        let fmt = ISO8601DateFormatter()
        for p in prompts {
            let tags   = p.tagsArray.compactMap(\.name).joined(separator: ";")
            let row = [
                p.id?.uuidString ?? "",
                csvEscape(p.title ?? ""),
                csvEscape(p.content ?? ""),
                csvEscape(p.notes ?? ""),
                csvEscape(tags),
                csvEscape(p.folder?.name ?? ""),
                p.isFavorite ? "true" : "false",
                fmt.string(from: p.createdAt ?? Date()),
                fmt.string(from: p.updatedAt ?? Date())
            ].joined(separator: ",")
            lines.append(row)
        }
        return lines.joined(separator: "\n")
    }

    private func csvEscape(_ s: String) -> String {
        let escaped = s.replacingOccurrences(of: "\"", with: "\"\"")
            .replacingOccurrences(of: "\n", with: " ")
        return "\"\(escaped)\""
    }
}
