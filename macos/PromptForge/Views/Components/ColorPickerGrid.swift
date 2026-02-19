import SwiftUI

struct ColorPickerGrid: View {
    @Binding var selectedColor: String

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(30)), count: 5), spacing: 8) {
            ForEach(Color.tagColors, id: \.name) { item in
                Circle()
                    .fill(item.color)
                    .frame(width: 26, height: 26)
                    .overlay {
                        if selectedColor == item.name {
                            Circle()
                                .strokeBorder(.white, lineWidth: 2)
                                .frame(width: 26, height: 26)
                        }
                    }
                    .overlay {
                        Circle()
                            .strokeBorder(selectedColor == item.name ? Color.primary : Color.clear, lineWidth: 1.5)
                            .frame(width: 30, height: 30)
                    }
                    .onTapGesture { selectedColor = item.name }
                    .accessibilityLabel("\(item.name) color")
            }
        }
    }
}
