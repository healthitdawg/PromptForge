import Foundation

struct Category: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var color: String
    
    init(id: UUID = UUID(), name: String, color: String = "blue") {
        self.id = id
        self.name = name
        self.color = color
    }
}

struct Prompt: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var title: String
    var content: String
    var categoryId: UUID?
    var tags: [String]
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(), title: String, content: String, categoryId: UUID? = nil, tags: [String] = []) {
        self.id = id
        self.title = title
        self.content = content
        self.categoryId = categoryId
        self.tags = tags
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
