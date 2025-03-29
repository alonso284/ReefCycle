//
//  ReefCycleApp.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI
import SwiftData

@main
struct ReefCycleApp: App {
    @State private var reefVM = ReefCycleViewModel()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            OwnedHat.self,
            OwnedTool.self,
            OwnedSkin.self
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
                .environment(reefVM)
        }
        .modelContainer(sharedModelContainer)
    }
}
