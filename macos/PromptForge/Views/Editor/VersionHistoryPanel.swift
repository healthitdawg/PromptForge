import CoreData
import SwiftUI

struct VersionHistoryPanel: View {
    let promptObjectID: NSManagedObjectID?
    @EnvironmentObject var promptVM: PromptViewModel
    @Environment(\.managedObjectContext) var moc
    @State private var selectedVersion: VersionEntity?
    @State private var showRestoreConfirm = false

    private var versions: [VersionEntity] {
        guard let id = promptObjectID,
              let prompt = try? moc.existingObject(with: id) as? PromptEntity
        else { return [] }
        return prompt.versionsArray
    }

    var body: some View {
        HSplitView {
            // Left: version list
            List(versions, selection: $selectedVersion) { version in
                VersionHistoryRow(version: version)
                    .tag(version)
            }
            .listStyle(.plain)
            .frame(minWidth: 200, maxWidth: 260)
            .overlay(alignment: .top) {
                if versions.isEmpty {
                    EmptyStateView(
                        icon: "clock.arrow.circlepath",
                        title: "No Versions",
                        message: "Save the prompt to start recording version history."
                    )
                }
            }

            // Right: version content preview
            VStack(alignment: .leading, spacing: 0) {
                if let v = selectedVersion {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(v.changeDescription ?? "Saved")
                                .font(.headline)
                            if let ts = v.timestamp {
                                Text(ts.formattedDateTime)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        Button("Restore This Version") {
                            showRestoreConfirm = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    Divider()
                    ScrollView {
                        Text(v.content ?? "")
                            .font(.system(.body, design: .monospaced))
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    EmptyStateView(
                        icon: "clock.arrow.circlepath",
                        title: "Select a Version",
                        message: "Choose a saved version on the left to preview its content."
                    )
                }
            }
        }
        .alert("Restore Version?", isPresented: $showRestoreConfirm) {
            Button("Restore", role: .destructive) {
                if let v = selectedVersion { promptVM.restoreVersion(v) }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("The current content will be saved as a new version before restoring. This cannot be undone.")
        }
    }
}
