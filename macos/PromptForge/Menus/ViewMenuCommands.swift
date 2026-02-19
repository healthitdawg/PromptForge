import SwiftUI

struct ViewMenuCommands: Commands {
    @AppStorage("promptSortOption") private var sortRaw: String = PromptViewModel.SortOption.updatedDescending.rawValue
    @AppStorage("appTheme") private var appTheme: String = "system"

    var body: some Commands {
        CommandGroup(after: .toolbar) {
            Divider()

            Menu("Sort By") {
                ForEach(PromptViewModel.SortOption.allCases) { option in
                    Button(option.rawValue) {
                        sortRaw = option.rawValue
                    }
                }
            }

            Divider()

            Menu("Theme") {
                Button("System Default") { appTheme = "system" }
                Button("Light")          { appTheme = "light" }
                Button("Dark")           { appTheme = "dark" }
            }
        }
    }
}
