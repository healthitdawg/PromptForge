//
//  PromptForgeApp.swift
//  PromptForge
//
//  Created by John Brosius on 11/21/25.
//

import SwiftUI

@main
struct PromptForgeApp: App {
    @StateObject private var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .frame(minWidth: 900, minHeight: 600)
        }
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}
