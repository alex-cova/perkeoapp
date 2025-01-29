//
//  SavedSeedsView.swift
//  balatroseeds
//
//  Created by Alex on 27/01/25.
//

import SwiftUI
import SwiftData

struct SavedSeedsView : View {
    @Query private var seeds: [SeedModel]
    @Environment(\.modelContext) private var modelContext
    
    let dateFormatter = DateFormatter()
    
    init(){
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }
    
    func copy(_ seed : String){
        UIPasteboard.general.string = seed
    }
    
    var body: some View {
        List {
            ForEach(seeds) { item in
                NavigationLink(destination: PlayView(run: Balatro()
                    .performAnalysis(seed: item.seed))) {
                    seedRow(item)
                    }
            }.onDelete(perform: deleteItems)
        }.toolbar {
            Button(action: {
                if let clipboardText = UIPasteboard.general.string {
                    if(!clipboardText.isEmpty){
                        modelContext.insert(SeedModel(timestamp: Date(), seed: clipboardText))
                    }
                }
            }, label: {
                Image(systemName: "plus")
            })
        }
        .navigationTitle("Seeds")
    }
    
    @ViewBuilder
    private func seedRow(_ item : SeedModel) -> some View {
        VStack {
            Text(item.seed)
                .font(.title2)
            Text("\(dateFormatter.string(from: item.timestamp))")
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(seeds[index])
            }
        }
    }
}



#Preview {
    NavigationStack {
        SavedSeedsView()
            .modelContainer(for: SeedModel.self, inMemory: true)
    }
}
