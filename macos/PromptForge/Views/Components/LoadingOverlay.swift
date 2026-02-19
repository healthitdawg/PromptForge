import SwiftUI

struct LoadingOverlay: View {
    var message: String = "Loading…"

    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()
            VStack(spacing: 12) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.2)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
            }
            .padding(24)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 8)
        }
    }
}

extension View {
    func loadingOverlay(_ isLoading: Bool, message: String = "Loading…") -> some View {
        overlay {
            if isLoading {
                LoadingOverlay(message: message)
            }
        }
    }
}
