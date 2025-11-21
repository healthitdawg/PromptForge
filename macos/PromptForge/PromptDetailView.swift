import SwiftUI

struct PromptDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    let prompt: Prompt
    @State private var showingCopied = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text(prompt.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack {
                    if let categoryId = prompt.categoryId {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(dataManager.getCategoryColor(for: categoryId))
                                .frame(width: 8, height: 8)
                            Text(dataManager.getCategoryName(for: categoryId))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Text("Updated: \(prompt.updatedAt, formatter: dateFormatter)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if !prompt.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(prompt.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(6)
                            }
                        }
                    }
                }
            }
            .padding()
            
            Divider()
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(prompt.content)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Divider()
            
            // Actions
            HStack(spacing: 12) {
                Button(action: {
                    copyToClipboard(prompt.content)
                    showingCopied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showingCopied = false
                    }
                }) {
                    HStack {
                        Image(systemName: showingCopied ? "checkmark.circle.fill" : "doc.on.clipboard")
                        Text(showingCopied ? "Copied!" : "Copy to Clipboard")
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: {
                    copyToClipboard(prompt.content)
                    showingCopied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showingCopied = false
                    }
                }) {
                    Image(systemName: "arrow.up.doc.on.clipboard")
                }
                .buttonStyle(.bordered)
                .help("Quick copy")
                
                Spacer()
                
                Text("\(prompt.content.count) characters")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
    
    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}
