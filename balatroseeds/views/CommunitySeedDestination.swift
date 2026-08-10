//
//  CommunitySeedDestination.swift
//  balatroseeds
//
//  Created by Alex on 09/08/26.
//

import SwiftUI

struct CommunitySeedDestination: View {
    @EnvironmentObject private var model: AnalyzerViewModel
    let seed: String

    var body: some View {
        seedNavigation(seed)
            .toolbar {
                Button("Summary", systemImage: "checklist", action: showSummary)
                    .labelStyle(.iconOnly)
                    .tint(.red)

                Button("Copy seed", systemImage: "document.on.clipboard", action: copySeed)
                    .labelStyle(.iconOnly)
                    .tint(.red)

                Button("Settings", systemImage: "gear", action: showConfig)
                    .labelStyle(.iconOnly)
                    .tint(.red)
            }
            .onAppear(perform: applySeed)
    }

    private func showSummary() {
        model.showSummary.toggle()
    }

    private func copySeed() {
        model.copy()
    }

    private func showConfig() {
        model.configSheet.toggle()
    }

    private func applySeed() {
        model.changeSeed(seed)
    }
}

#Preview {
    NavigationStack {
        CommunitySeedDestination(seed: "PERKEO01")
            .environmentObject(AnalyzerViewModel(memoryOnly: true))
    }
}
