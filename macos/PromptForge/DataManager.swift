import Foundation
import SwiftUI
import Combine

class DataManager: ObservableObject {
    @Published var prompts: [Prompt] = []
    @Published var categories: [Category] = []
    
    private let promptsKey = "savedPrompts"
    private let categoriesKey = "savedCategories"
    
    init() {
        loadData()
        if categories.isEmpty {
            addDefaultCategories()
        }
    }
    
    private func addDefaultCategories() {
        categories = [
            Category(name: "General", color: "blue"),
            Category(name: "Code", color: "green"),
            Category(name: "Writing", color: "purple"),
            Category(name: "Analysis", color: "orange")
        ]
        saveCategories()
    }
    
    func addPrompt(_ prompt: Prompt) {
        prompts.append(prompt)
        savePrompts()
    }
    
    func updatePrompt(_ prompt: Prompt) {
        if let index = prompts.firstIndex(where: { $0.id == prompt.id }) {
            var updatedPrompt = prompt
            updatedPrompt.updatedAt = Date()
            prompts[index] = updatedPrompt
            savePrompts()
        }
    }
    
    func deletePrompt(_ prompt: Prompt) {
        prompts.removeAll { $0.id == prompt.id }
        savePrompts()
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        saveCategories()
    }
    
    func updateCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            saveCategories()
        }
    }
    
    func deleteCategory(_ category: Category) {
        categories.removeAll { $0.id == category.id }
        prompts.indices.forEach { index in
            if prompts[index].categoryId == category.id {
                prompts[index].categoryId = nil
            }
        }
        saveCategories()
        savePrompts()
    }
    
    func getCategoryName(for id: UUID?) -> String {
        guard let id = id else { return "Uncategorized" }
        return categories.first(where: { $0.id == id })?.name ?? "Uncategorized"
    }
    
    func getCategoryColor(for id: UUID?) -> Color {
        guard let id = id else { return .gray }
        let colorString = categories.first(where: { $0.id == id })?.color ?? "gray"
        return colorFromString(colorString)
    }
    
    private func colorFromString(_ string: String) -> Color {
        switch string {
        case "blue": return .blue
        case "green": return .green
        case "purple": return .purple
        case "orange": return .orange
        case "red": return .red
        case "pink": return .pink
        case "yellow": return .yellow
        default: return .gray
        }
    }
    
    private func savePrompts() {
        if let encoded = try? JSONEncoder().encode(prompts) {
            UserDefaults.standard.set(encoded, forKey: promptsKey)
        }
    }
    
    private func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: categoriesKey)
        }
    }
    
    private func loadData() {
        if let promptsData = UserDefaults.standard.data(forKey: promptsKey),
           let decodedPrompts = try? JSONDecoder().decode([Prompt].self, from: promptsData) {
            prompts = decodedPrompts
        }
        
        if let categoriesData = UserDefaults.standard.data(forKey: categoriesKey),
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: categoriesData) {
            categories = decodedCategories
        }
    }
}
