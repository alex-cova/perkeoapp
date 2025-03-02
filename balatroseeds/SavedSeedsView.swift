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
        if (seeds.isEmpty){
            VStack {
                Spacer()
                LegendaryJoker.Perkeo.sprite()
                Text("There is no saved seeds yet.")
                    .foregroundStyle(.gray)
                Spacer()
                
            }.navigationTitle("Saved Seeds")
                .navigationBarTitleDisplayMode(.inline)
        }else {
            List {
                ForEach(seeds) { item in
                    NavigationLink(destination: PlayView(run: Balatro()
                        .performAnalysis(seed: item.seed))
                        .navigationTitle(item.seed)) {
                            seedRow(item)
                        }
                }.onDelete(perform: deleteItems)
            }
            .navigationTitle("Saved Seeds")
            .navigationBarTitleDisplayMode(.inline)
        }
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
