import CoreData
import Foundation

enum ImportError: Error, LocalizedError {
    case invalidEncoding
    case invalidJSON(Error)
    case emptyFile

    var errorDescription: String? {
        switch self {
        case .invalidEncoding:    return "Could not read the file as UTF-8 text."
        case .invalidJSON(let e): return "Invalid JSON: \(e.localizedDescription)"
        case .emptyFile:          return "The file is empty."
        }
    }
}

final class ImportService {
    private let ctx: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.ctx = context
    }

    // MARK: - JSON Import

    func importFromJSON(data: Data) throws -> Int {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let bundle: PromptForgeExportBundle
        do {
            bundle = try decoder.decode(PromptForgeExportBundle.self, from: data)
        } catch {
            throw ImportError.invalidJSON(error)
        }
        guard !bundle.prompts.isEmpty else { throw ImportError.emptyFile }

        for transfer in bundle.prompts {
            upsertPrompt(from: transfer)
        }
        try ctx.save()
        return bundle.prompts.count
    }

    // MARK: - CSV Import (basic; no version history)

    func importFromCSV(data: Data) throws -> Int {
        guard let text = String(data: data, encoding: .utf8) else {
            throw ImportError.invalidEncoding
        }
        var lines = text.components(separatedBy: "\n")
        guard lines.count > 1 else { throw ImportError.emptyFile }
        lines.removeFirst() // header row

        var count = 0
        let fmt = ISO8601DateFormatter()
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { continue }
            let cols = parseCSVLine(trimmed)
            guard cols.count >= 9 else { continue }

            let prompt = PromptEntity(context: ctx)
            prompt.id         = UUID(uuidString: cols[0]) ?? UUID()
            prompt.title      = cols[1]
            prompt.content    = cols[2]
            prompt.notes      = cols[3].isEmpty ? nil : cols[3]
            prompt.isFavorite = cols[6] == "true"
            prompt.isArchived = false
            prompt.createdAt  = fmt.date(from: cols[7]) ?? Date()
            prompt.updatedAt  = fmt.date(from: cols[8]) ?? Date()

            // Tags (semicolon-separated)
            let tagNames = cols[4].components(separatedBy: ";").filter { !$0.isEmpty }
            for tagName in tagNames {
                let tag = findOrCreateTag(name: tagName)
                prompt.addToTags(tag)
            }

            // Folder by name
            let folderName = cols[5]
            if !folderName.isEmpty {
                prompt.folder = findOrCreateFolder(name: folderName)
            }

            count += 1
        }
        try ctx.save()
        return count
    }

    // MARK: - Helpers

    private func upsertPrompt(from transfer: PromptTransfer) {
        // Check for existing by id
        let request: NSFetchRequest<PromptEntity> = PromptEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", transfer.id as CVarArg)
        request.fetchLimit = 1
        let existing = (try? ctx.fetch(request))?.first

        let prompt = existing ?? PromptEntity(context: ctx)
        prompt.id         = transfer.id
        prompt.title      = transfer.title
        prompt.content    = transfer.content
        prompt.notes      = transfer.notes
        prompt.isFavorite = transfer.isFavorite
        prompt.isArchived = false
        prompt.createdAt  = transfer.createdAt
        prompt.updatedAt  = transfer.updatedAt

        if let folderName = transfer.folderName {
            prompt.folder = findOrCreateFolder(name: folderName)
        }

        // Tags
        let currentTags = prompt.tagsArray
        currentTags.forEach { prompt.removeFromTags($0) }
        for tagTransfer in transfer.tags {
            let tag = findOrCreateTag(name: tagTransfer.name, color: tagTransfer.color)
            prompt.addToTags(tag)
        }

        // Version history
        for vt in transfer.versions {
            let version = VersionEntity(context: ctx)
            version.id                = vt.id
            version.content           = vt.content
            version.timestamp         = vt.timestamp
            version.changeDescription = vt.changeDescription
            version.prompt            = prompt
        }
    }

    private func findOrCreateTag(name: String, color: String = "blue") -> TagEntity {
        let req: NSFetchRequest<TagEntity> = TagEntity.fetchRequest()
        req.predicate = NSPredicate(format: "name ==[c] %@", name)
        req.fetchLimit = 1
        if let existing = (try? ctx.fetch(req))?.first { return existing }
        let tag = TagEntity(context: ctx)
        tag.name  = name
        tag.color = color
        return tag
    }

    private func findOrCreateFolder(name: String) -> FolderEntity {
        let req: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        req.predicate = NSPredicate(format: "name ==[c] %@ AND parent == nil", name)
        req.fetchLimit = 1
        if let existing = (try? ctx.fetch(req))?.first { return existing }
        let folder = FolderEntity(context: ctx)
        folder.id         = UUID()
        folder.name       = name
        folder.sortOrder  = 0
        return folder
    }

    // Basic CSV line parser respecting double-quoted fields
    private func parseCSVLine(_ line: String) -> [String] {
        var fields: [String] = []
        var current = ""
        var inQuotes = false
        var index = line.startIndex
        while index < line.endIndex {
            let ch = line[index]
            if ch == "\"" {
                let next = line.index(after: index)
                if inQuotes && next < line.endIndex && line[next] == "\"" {
                    current.append("\"")
                    index = line.index(after: next)
                    continue
                }
                inQuotes.toggle()
            } else if ch == "," && !inQuotes {
                fields.append(current)
                current = ""
            } else {
                current.append(ch)
            }
            index = line.index(after: index)
        }
        fields.append(current)
        return fields
    }
}
