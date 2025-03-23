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
    
    let model = AnalyzerViewModel(memoryOnly: false)
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
        }.modelContainer(model.modelContext)
            .environmentObject(JokerFile())
            .environmentObject(model)
    }

}
