import SwiftUI

extension View {
    /// Combines children into a single accessibility element with a label and hint.
    func promptCard(title: String, preview: String) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(title). \(String(preview.prefix(80)))")
            .accessibilityHint("Press Return to open prompt")
    }

    /// Marks a button with a descriptive accessibility label.
    func accessibleButton(_ label: String, hint: String? = nil) -> some View {
        var view = self.accessibilityLabel(label)
        if let hint { view = view.accessibilityHint(hint) }
        return view
    }
}
