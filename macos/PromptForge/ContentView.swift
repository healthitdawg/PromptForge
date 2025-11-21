//
//  ContentView.swift
//  PromptForge
//
//  Created by John Brosius on 11/21/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedCategory: UUID?
    @State private var selectedPrompt: Prompt?
    @State private var searchText = ""
    @State private var showingAddPrompt = false
    @State private var showingAddCategory = false
    @State private var showingEditPrompt = false
    
    var filteredPrompts: [Prompt] {
        var filtered = dataManager.prompts
        
        if let categoryId = selectedCategory {
            filtered = filtered.filter { $0.categoryId == categoryId }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
            }
        }
        
        return filtered.sorted { $0.updatedAt > $1.updatedAt }
    }
    
    var body: some View {
        NavigationView {
            // Sidebar - Categories
            List(selection: $selectedCategory) {
                Section("Categories") {
                    Button(action: { selectedCategory = nil }) {
                        Label("All Prompts", systemImage: "tray.fill")
                    }
                    .buttonStyle(.plain)
                    
                    ForEach(dataManager.categories) { category in
                        Button(action: { selectedCategory = category.id }) {
                            Label(category.name, systemImage: "folder.fill")
                                .foregroundColor(dataManager.getCategoryColor(for: category.id))
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button("Delete") {
                                dataManager.deleteCategory(category)
                            }
                        }
                    }
                    
                    Button(action: { showingAddCategory = true }) {
                        Label("Add Category", systemImage: "plus.circle")
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.sidebar)
            .frame(minWidth: 200)
            
            // Middle - Prompts List
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search prompts...", text: $searchText)
                        .textFieldStyle(.plain)
                }
                .padding(8)
                .background(Color(NSColor.controlBackgroundColor))
                
                Divider()
                
                if filteredPrompts.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text(searchText.isEmpty ? "No prompts yet" : "No prompts found")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(filteredPrompts, selection: $selectedPrompt) { prompt in
                        PromptRowView(prompt: prompt)
                            .tag(prompt)
                            .contextMenu {
                                Button("Edit") {
                                    selectedPrompt = prompt
                                    showingEditPrompt = true
                                }
                                Button("Copy to Clipboard") {
                                    copyToClipboard(prompt.content)
                                }
                                Divider()
                                Button("Delete", role: .destructive) {
                                    dataManager.deletePrompt(prompt)
                                    if selectedPrompt?.id == prompt.id {
                                        selectedPrompt = nil
                                    }
                                }
                            }
                    }
                    .listStyle(.plain)
                }
            }
            .frame(minWidth: 250)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddPrompt = true }) {
                        Label("Add Prompt", systemImage: "plus")
                    }
                }
            }
            
            // Detail View
            if let prompt = selectedPrompt {
                PromptDetailView(prompt: prompt)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "text.bubble")
                        .font(.system(size: 64))
                        .foregroundColor(.secondary)
                    Text("Select a prompt to view")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sheet(isPresented: $showingAddPrompt) {
            AddPromptView()
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategoryView()
        }
        .sheet(isPresented: $showingEditPrompt) {
            if let prompt = selectedPrompt {
                EditPromptView(prompt: prompt)
            }
        }
    }
    
    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}

struct PromptRowView: View {
    @EnvironmentObject var dataManager: DataManager
    let prompt: Prompt
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(prompt.title)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
            }
            
            Text(prompt.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                if let categoryId = prompt.categoryId {
                    Text(dataManager.getCategoryName(for: categoryId))
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(dataManager.getCategoryColor(for: categoryId).opacity(0.2))
                        .foregroundColor(dataManager.getCategoryColor(for: categoryId))
                        .cornerRadius(4)
                }
                
                ForEach(prompt.tags.prefix(3), id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
}
