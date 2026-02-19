import CoreData
import SwiftUI
import UniformTypeIdentifiers

@MainActor
final class ImportExportViewModel: ObservableObject {
    @Published var showImportJSON = false
    @Published var showImportCSV = false
    @Published var showExportJSON = false
    @Published var showExportAll = false
    @Published var isWorking = false
    @Published var resultMessage: String?
    @Published var showResultAlert = false
    @Published var exportData: Data?
    @Published var exportCSV: String?

    private let dataController: DataController

    init(dataController: DataController = .shared) {
        self.dataController = dataController
    }

    // MARK: - Export

    func exportSelectedAsJSON(prompt: PromptEntity?) {
        guard let prompt else { return }
        do {
            exportData = try ExportService().exportToJSON(prompts: [prompt])
            showExportJSON = true
        } catch {
            resultMessage = "Export failed: \(error.localizedDescription)"
            showResultAlert = true
        }
    }

    func exportAllAsJSON() {
        let request: NSFetchRequest<PromptEntity> = PromptEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isArchived == NO")
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        guard let prompts = try? dataController.viewContext.fetch(request) else { return }
        do {
            exportData = try ExportService().exportToJSON(prompts: prompts)
            showExportAll = true
        } catch {
            resultMessage = "Export failed: \(error.localizedDescription)"
            showResultAlert = true
        }
    }

    // MARK: - Import

    func importJSON(from url: URL) async {
        isWorking = true
        defer { isWorking = false }
        do {
            let data = try Data(contentsOf: url)
            let service = ImportService(context: dataController.viewContext)
            let count = try service.importFromJSON(data: data)
            resultMessage = "Imported \(count) prompt\(count == 1 ? "" : "s") successfully."
        } catch {
            resultMessage = "Import failed: \(error.localizedDescription)"
        }
        showResultAlert = true
    }

    func importCSV(from url: URL) async {
        isWorking = true
        defer { isWorking = false }
        do {
            let data = try Data(contentsOf: url)
            let service = ImportService(context: dataController.viewContext)
            let count = try service.importFromCSV(data: data)
            resultMessage = "Imported \(count) prompt\(count == 1 ? "" : "s") successfully."
        } catch {
            resultMessage = "Import failed: \(error.localizedDescription)"
        }
        showResultAlert = true
    }
}
