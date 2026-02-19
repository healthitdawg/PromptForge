import SwiftUI

struct AppCommands: Commands {
    var body: some Commands {
        FileMenuCommands()
        EditMenuCommands()
        ViewMenuCommands()
        PromptsMenuCommands()
    }
}
