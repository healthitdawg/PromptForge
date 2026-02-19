import SwiftUI

struct SettingsView: View {
    @State private var apiKey: String = ""
    @State private var showKey: Bool = false
    @State private var keySaved: Bool = false
    @State private var keyError: String?
    @AppStorage("appTheme") private var appTheme: String = "system"
    @AppStorage("promptSortOption") private var sortRaw: String = PromptViewModel.SortOption.updatedDescending.rawValue

    var body: some View {
        TabView {
            apiKeyTab
                .tabItem { Label("API", systemImage: "key") }

            appearanceTab
                .tabItem { Label("Appearance", systemImage: "paintbrush") }
        }
        .frame(width: 480, height: 320)
        .onAppear { loadAPIKey() }
    }

    // MARK: - API Key Tab
    private var apiKeyTab: some View {
        Form {
            Section("OpenAI API Key") {
                HStack {
                    if showKey {
                        TextField("sk-...", text: $apiKey)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        SecureField("sk-...", text: $apiKey)
                            .textFieldStyle(.roundedBorder)
                    }
                    Button(showKey ? "Hide" : "Show") {
                        showKey.toggle()
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                }

                HStack {
                    Button("Save API Key") { saveAPIKey() }
                        .buttonStyle(.borderedProminent)
                        .disabled(apiKey.trimmingCharacters(in: .whitespaces).isEmpty)

                    Button("Delete Key", role: .destructive) { deleteAPIKey() }
                        .disabled(!KeychainService.shared.hasAPIKey())

                    if keySaved {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }

                if let error = keyError {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.caption)
                }

                Text("Your API key is stored securely in the system Keychain and never leaves your device.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .padding()
    }

    // MARK: - Appearance Tab
    private var appearanceTab: some View {
        Form {
            Section("Theme") {
                Picker("Color Scheme", selection: $appTheme) {
                    Text("System Default").tag("system")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }
                .pickerStyle(.radioGroup)
            }

            Section("Default Sort") {
                Picker("Sort Prompts By", selection: $sortRaw) {
                    ForEach(PromptViewModel.SortOption.allCases) { option in
                        Text(option.rawValue).tag(option.rawValue)
                    }
                }
            }
        }
        .formStyle(.grouped)
        .padding()
    }

    // MARK: - Helpers
    private func loadAPIKey() {
        apiKey = (try? KeychainService.shared.readAPIKey()) ?? ""
    }

    private func saveAPIKey() {
        let key = apiKey.trimmingCharacters(in: .whitespaces)
        do {
            try KeychainService.shared.saveAPIKey(key)
            keySaved = true
            keyError = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { keySaved = false }
        } catch {
            keyError = error.localizedDescription
        }
    }

    private func deleteAPIKey() {
        KeychainService.shared.deleteAPIKey()
        apiKey = ""
        keySaved = false
    }
}
