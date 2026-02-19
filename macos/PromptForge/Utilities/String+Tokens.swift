import Foundation

extension String {
    /// Rough token count estimate: ~4 characters per token.
    var estimatedTokenCount: Int {
        max(1, count / 4)
    }

    /// Truncated preview for list rows.
    func preview(maxLength: Int = 120) -> String {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count <= maxLength { return trimmed }
        return String(trimmed.prefix(maxLength)) + "…"
    }
}
