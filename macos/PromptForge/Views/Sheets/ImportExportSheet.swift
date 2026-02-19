import SwiftUI
import UniformTypeIdentifiers

struct ImportExportModifiers: ViewModifier {
    @EnvironmentObject var importExportVM: ImportExportViewModel
    @EnvironmentObject var promptVM: PromptViewModel

    func body(content: Content) -> some View {
        content
            // Import JSON
            .fileImporter(
                isPresented: $importExportVM.showImportJSON,
                allowedContentTypes: [.json],
                allowsMultipleSelection: false
            ) { result in
                if case .success(let urls) = result, let url = urls.first {
                    Task { await importExportVM.importJSON(from: url) }
                }
            }

            // Import CSV
            .fileImporter(
                isPresented: $importExportVM.showImportCSV,
                allowedContentTypes: [.commaSeparatedText],
                allowsMultipleSelection: false
            ) { result in
                if case .success(let urls) = result, let url = urls.first {
                    Task { await importExportVM.importCSV(from: url) }
                }
            }

            // Export selected JSON
            .fileExporter(
                isPresented: $importExportVM.showExportJSON,
                document: PromptForgeJSONDocument(data: importExportVM.exportData ?? Data()),
                contentType: .json,
                defaultFilename: "PromptForge-Export"
            ) { _ in }

            // Export all JSON
            .fileExporter(
                isPresented: $importExportVM.showExportAll,
                document: PromptForgeJSONDocument(data: importExportVM.exportData ?? Data()),
                contentType: .json,
                defaultFilename: "PromptForge-All-Export"
            ) { _ in }

            // Result alert
            .alert("Import / Export", isPresented: $importExportVM.showResultAlert) {
                Button("OK") {}
            } message: {
                Text(importExportVM.resultMessage ?? "")
            }

            // Sync showImportJSON from promptVM
            .onChange(of: promptVM.showImportJSON) {
                if promptVM.showImportJSON {
                    importExportVM.showImportJSON = true
                    promptVM.showImportJSON = false
                }
            }
            .onChange(of: promptVM.showImportCSV) {
                if promptVM.showImportCSV {
                    importExportVM.showImportCSV = true
                    promptVM.showImportCSV = false
                }
            }
            .onChange(of: promptVM.showExportJSON) {
                if promptVM.showExportJSON {
                    importExportVM.exportSelectedAsJSON(prompt: promptVM.selectedPrompt)
                    promptVM.showExportJSON = false
                }
            }
            .onChange(of: promptVM.showExportAll) {
                if promptVM.showExportAll {
                    importExportVM.exportAllAsJSON()
                    promptVM.showExportAll = false
                }
            }
    }
}

// MARK: - FileDocument wrapper
struct PromptForgeJSONDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    var data: Data

    init(data: Data) { self.data = data }
    init(configuration: ReadConfiguration) throws {
        data = configuration.file.regularFileContents ?? Data()
    }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

extension View {
    func importExportModifiers() -> some View {
        modifier(ImportExportModifiers())
    }
}
