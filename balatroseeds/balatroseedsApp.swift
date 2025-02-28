//
//  balatroseedsApp.swift
//  balatroseeds
//
//  Created by Alex on 03/01/25.
//

import SwiftUI
import SwiftData

@main
struct balatroseedsApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SeedModel.self,
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
            NavigationStack {
                ContentView()
            }
        }.modelContainer(sharedModelContainer)
    }

}
