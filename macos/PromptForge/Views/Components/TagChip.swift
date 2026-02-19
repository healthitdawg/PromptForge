import SwiftUI

struct TagChip: View {
    let tag: TagEntity
    var onRemove: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 3) {
            Text(tag.name ?? "")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.white)

            if let onRemove {
                Button(action: onRemove) {
                    Image(systemName: "xmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(Color.from(name: tag.color).opacity(0.85), in: Capsule())
    }
}

struct TagChipSmall: View {
    let name: String
    let colorName: String

    var body: some View {
        Text(name)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.from(name: colorName).opacity(0.85), in: Capsule())
    }
}
