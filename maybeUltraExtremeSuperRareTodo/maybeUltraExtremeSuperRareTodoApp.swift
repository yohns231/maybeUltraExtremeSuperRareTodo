//
//  maybeUltraExtremeSuperRareTodoApp.swift
//  maybeUltraExtremeSuperRareTodo
//
//  Created by 고요한 on 1/17/25.
//

import SwiftUI
import SwiftData

@main
struct maybeUltraExtremeSuperRareTodoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Contents.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
