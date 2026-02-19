import SwiftUI

struct VersionHistoryRow: View {
    @ObservedObject var version: VersionEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(version.changeDescription ?? "Saved")
                .font(.subheadline)
                .fontWeight(.medium)

            if let ts = version.timestamp {
                Text(ts.relativeDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(ts.formattedDateTime)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            if let content = version.content {
                Text("\(content.count) chars")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}
