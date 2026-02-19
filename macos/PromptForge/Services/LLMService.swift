import Foundation

// MARK: - Request / Response types

struct LLMRequest: Encodable {
    let model: String
    let messages: [LLMMessage]
    let maxTokens: Int
    let stream: Bool

    enum CodingKeys: String, CodingKey {
        case model, messages, stream
        case maxTokens = "max_tokens"
    }
}

struct LLMMessage: Codable {
    let role: String
    let content: String
}

struct LLMResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable { let content: String }
        let message: Message
    }
    let choices: [Choice]
}

// MARK: - Error

enum LLMError: Error, LocalizedError {
    case missingAPIKey
    case httpError(Int, String)
    case decodingFailure(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "No API key set. Go to PromptForge → Preferences to add your OpenAI API key."
        case .httpError(let code, let body):
            return "API error \(code): \(body)"
        case .decodingFailure:
            return "Failed to decode LLM response."
        case .networkError(let err):
            return "Network error: \(err.localizedDescription)"
        }
    }
}

// MARK: - Service

final class LLMService {
    static let shared = LLMService()
    private init() {}

    private let baseURL = URL(string: "https://api.openai.com/v1/chat/completions")!

    nonisolated func testPrompt(
        content: String,
        systemPrompt: String = "You are a helpful assistant.",
        model: String = "gpt-4o-mini",
        maxTokens: Int = 2048
    ) async throws -> String {
        let apiKey: String
        do {
            apiKey = try KeychainService.shared.readAPIKey()
        } catch {
            throw LLMError.missingAPIKey
        }

        let body = LLMRequest(
            model: model,
            messages: [
                LLMMessage(role: "system", content: systemPrompt),
                LLMMessage(role: "user",   content: content)
            ],
            maxTokens: maxTokens,
            stream: false
        )

        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 60

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw LLMError.decodingFailure(error)
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw LLMError.networkError(error)
        }

        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw LLMError.httpError(http.statusCode, body)
        }

        do {
            let decoded = try JSONDecoder().decode(LLMResponse.self, from: data)
            return decoded.choices.first?.message.content ?? ""
        } catch {
            throw LLMError.decodingFailure(error)
        }
    }
}
