import Foundation
import SwiftUI

@MainActor
final class LLMViewModel: ObservableObject {
    @Published var responseText: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var systemPrompt: String = "You are a helpful assistant. Respond concisely."
    @Published var selectedModel: String = "gpt-4o-mini"

    let availableModels = ["gpt-4o-mini", "gpt-4o", "gpt-4-turbo", "gpt-3.5-turbo"]

    private var currentTask: Task<Void, Never>?

    func runTest(prompt: String) {
        guard !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        currentTask?.cancel()
        isLoading = true
        error = nil
        responseText = ""

        currentTask = Task {
            do {
                let result = try await LLMService.shared.testPrompt(
                    content: prompt,
                    systemPrompt: systemPrompt,
                    model: selectedModel
                )
                if !Task.isCancelled {
                    responseText = result
                }
            } catch {
                if !Task.isCancelled {
                    self.error = error.localizedDescription
                }
            }
            isLoading = false
        }
    }

    func cancel() {
        currentTask?.cancel()
        currentTask = nil
        isLoading = false
    }

    func clearResponse() {
        responseText = ""
        error = nil
    }
}
