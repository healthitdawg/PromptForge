import SwiftUI

extension Color {
    /// Map a string color name to a SwiftUI Color.
    static func from(name: String?) -> Color {
        switch name?.lowercased() {
        case "blue":    return .blue
        case "green":   return .green
        case "purple":  return .purple
        case "orange":  return .orange
        case "red":     return .red
        case "pink":    return .pink
        case "yellow":  return .yellow
        case "teal":    return .teal
        case "mint":    return .mint
        case "indigo":  return .indigo
        default:        return .blue
        }
    }

    var stringName: String {
        switch self {
        case .blue:   return "blue"
        case .green:  return "green"
        case .purple: return "purple"
        case .orange: return "orange"
        case .red:    return "red"
        case .pink:   return "pink"
        case .yellow: return "yellow"
        case .teal:   return "teal"
        case .mint:   return "mint"
        case .indigo: return "indigo"
        default:      return "blue"
        }
    }

    static let tagColors: [(name: String, color: Color)] = [
        ("blue",   .blue),
        ("green",  .green),
        ("purple", .purple),
        ("orange", .orange),
        ("red",    .red),
        ("pink",   .pink),
        ("yellow", .yellow),
        ("teal",   .teal),
        ("mint",   .mint),
        ("indigo", .indigo)
    ]
}
