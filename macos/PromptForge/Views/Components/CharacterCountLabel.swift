import SwiftUI

struct CharacterCountLabel: View {
    let text: String

    private var charCount: Int { text.count }
    private var tokenEstimate: Int { text.estimatedTokenCount }
    private var wordCount: Int {
        text.split(separator: " ", omittingEmptySubsequences: true).count
    }

    var body: some View {
        Text("\(charCount) chars · ~\(tokenEstimate) tokens · \(wordCount) words")
            .font(.caption)
            .foregroundStyle(.secondary)
            .monospacedDigit()
    }
}
