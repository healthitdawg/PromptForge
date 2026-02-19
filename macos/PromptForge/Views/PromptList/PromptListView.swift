import CoreData
import SwiftUI

struct PromptListView: View {
    @EnvironmentObject var sidebarVM: SidebarViewModel
    @EnvironmentObject var promptVM: PromptViewModel
    @Environment(\.managedObjectContext) var moc

    var body: some View {
        FetchedPromptList(
            predicate: buildPredicate(),
            sortDescriptors: promptVM.sortOrder.descriptors,
            sidebarItem: sidebarVM.selection
        )
        // When sort order changes, recreate FetchedPromptList with new sort descriptors
        .id(promptVM.sortOrder)
        .toolbar { PromptListToolbar() }
        .navigationTitle(sidebarVM.selection?.title ?? "Prompts")
    }

    private func buildPredicate() -> NSPredicate {
        return SearchService.fetchRequest(
            for: sidebarVM.selection,
            searchText: sidebarVM.globalSearch,
            sortOption: promptVM.sortOrder,
            context: moc
        ).predicate ?? NSPredicate(value: true)
    }
}

/// Inner view that owns @FetchRequest and updates its predicate dynamically.
private struct FetchedPromptList: View {
    @EnvironmentObject var sidebarVM: SidebarViewModel
    @EnvironmentObject var promptVM: PromptViewModel
    @Environment(\.managedObjectContext) var moc

    let sidebarItem: SidebarItem?

    @FetchRequest var prompts: FetchedResults<PromptEntity>

    init(predicate: NSPredicate,
         sortDescriptors: [NSSortDescriptor],
         sidebarItem: SidebarItem?) {
        self.sidebarItem = sidebarItem
        let request: NSFetchRequest<PromptEntity> = PromptEntity.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        request.fetchBatchSize = 50
        _prompts = FetchRequest(fetchRequest: request, animation: .default)
    }

    var body: some View {
        Group {
            if prompts.isEmpty {
                EmptyPromptListView(sidebarItem: sidebarItem)
            } else {
                List(prompts, id: \.objectID, selection: $promptVM.selectedPromptID) { prompt in
                    PromptListRow(prompt: prompt)
                        .tag(prompt.objectID)
                }
                .listStyle(.plain)
            }
        }
        .onChange(of: sidebarVM.selection)       { updatePredicate() }
        .onChange(of: sidebarVM.globalSearch)    { updatePredicate() }
        .onChange(of: promptVM.selectedPromptID) { promptVM.loadDraft() }
    }

    private func updatePredicate() {
        let req = SearchService.fetchRequest(
            for: sidebarVM.selection,
            searchText: sidebarVM.globalSearch,
            sortOption: promptVM.sortOrder,
            context: moc
        )
        $prompts.nsPredicate = req.predicate
    }
}
