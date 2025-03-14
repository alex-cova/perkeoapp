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
                PerkeoView()
                Text("There are no saved seeds yet.")
                    .foregroundStyle(.white)
                    .padding(.bottom)
                Button("Paste Seed") {
                    pasteSeed()
                }.buttonStyle(.borderedProminent)
                Spacer()
            }.frame(maxWidth: .infinity)
            .background(Color(hex: "#1e1e1e"))
            .navigationTitle("Saved Seeds")
                .navigationBarTitleDisplayMode(.inline)
        }else {
            List {
                ForEach(seeds) { item in
                    NavigationLink(destination: seedNavigation(item.seed)
                        .navigationTitle(item.seed)) {
                            seedRow(item)
                        }.listRowBackground(Color(hex: "#4d4d4d"))
                    
                }.onDelete(perform: deleteItems)
            }.background(Color(hex: "#1e1e1e"))
                .scrollContentBackground(.hidden)
            .navigationTitle("Saved Seeds")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func pasteSeed(){
        if let clipboardText = UIPasteboard.general.string {
            withAnimation {
                modelContext.insert(SeedModel(timestamp: Date(), seed: clipboardText))
            }
        }
    }
    
    @ViewBuilder
    private func seedRow(_ item : SeedModel) -> some View {
        VStack {
            Text(item.seed)
                .font(.title2)
                .foregroundStyle(.white)
            Text("\(dateFormatter.string(from: item.timestamp))")
                .font(.caption)
                .foregroundStyle(.white)
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
    TabView {
        SavedSeedsView()
            .modelContainer(for: SeedModel.self, inMemory: true)
    }
}
