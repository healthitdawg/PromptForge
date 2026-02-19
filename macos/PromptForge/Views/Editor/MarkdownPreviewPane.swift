import SwiftUI

struct MarkdownPreviewPane: View {
    let content: String

    private var attributedContent: AttributedString {
        (try? AttributedString(markdown: content,
                               options: AttributedString.MarkdownParsingOptions(
                                interpretedSyntax: .inlineOnlyPreservingWhitespace))) ??
        AttributedString(content)
    }

    var body: some View {
        ScrollView {
            Text(attributedContent)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .background(Color(NSColor.textBackgroundColor))
    }
}
