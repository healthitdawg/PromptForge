import SwiftUI

struct AddPromptView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var selectedCategoryId: UUID?
    @State private var tagsText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("New Prompt")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                
                Button("Save") {
                    savePrompt()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(title.isEmpty || content.isEmpty)
            }
            .padding()
            
            Divider()
            
            // Form
            Form {
                Section {
                    TextField("Title", text: $title)
                        .textFieldStyle(.roundedBorder)
                    
                    Picker("Category", selection: $selectedCategoryId) {
                        Text("None").tag(nil as UUID?)
                        ForEach(dataManager.categories) { category in
                            Text(category.name).tag(category.id as UUID?)
                        }
                    }
                    
                    TextField("Tags (comma-separated)", text: $tagsText)
                        .textFieldStyle(.roundedBorder)
                }
                
                Section {
                    Text("Prompt Content")
                        .font(.headline)
                    
                    TextEditor(text: $content)
                        .font(.system(.body, design: .monospaced))
                        .frame(minHeight: 300)
                        .border(Color.gray.opacity(0.2), width: 1)
                }
            }
            .formStyle(.grouped)
            .padding()
        }
        .frame(width: 600, height: 550)
    }
    
    private func savePrompt() {
        let tags = tagsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        let prompt = Prompt(
            title: title,
            content: content,
            categoryId: selectedCategoryId,
            tags: tags
        )
        
        dataManager.addPrompt(prompt)
        dismiss()
    }
}
