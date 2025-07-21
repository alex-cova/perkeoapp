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
    @EnvironmentObject var model : AnalyzerViewModel
    
    let dateFormatter = DateFormatter()
    
    init(){
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }
    
    @ViewBuilder
    private func renderSeeds() -> some View {
        VStack {
            AnimatedTitle(text: "Saved Seeds")
            List {
                Button(action: pasteSeed) {
                    Text("Add seed from clipboard")
                        .foregroundStyle(.red)
                        .font(.customBody)
                }
                ForEach(seeds) { item in
                    NavigationLink(destination: seedNavigation(item.seed)
                        .environmentObject(model)
                        .onAppear {
                            model.changeSeed(item.seed)
                        }
                        .navigationTitle(item.seed)) {
                            seedRow(item)
                        }.toolbar {
                            Button(action: {
                                model.showSummary.toggle()
                            }) {
                                Image(systemName:"checklist")
                            }.tint(.red)
                        }
                        .listRowBackground(Color.customRowBackground)
                    
                }.onDelete(perform: deleteItems)
            }.background(Color.customBackground)
                .scrollContentBackground(.hidden)
                .navigationTitle("Saved Seeds")
                .navigationBarTitleDisplayMode(.inline)
            Spacer()
        }.clipped()
            .background(Color.customBackground)
    }
    
    @ViewBuilder
    private func emptySeeds() -> some View {
        VStack {
            AnimatedTitle(text: "Saved Seeds")
            Spacer()
            RareJoker.Blueprint.sprite()
            Text("There are no saved seeds yet.")
                .font(.customBody)
                .foregroundStyle(.white)
                .padding(.bottom)
            Button(action: pasteSeed) {
                Text("Add seed from clipboard")
                    .font(.customBody)
            }
            .tint(.red)
            Spacer()
        }.frame(maxWidth: .infinity)
            .background(Color.customBackground)
            .navigationTitle("Saved Seeds")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    var body: some View {
        if (seeds.isEmpty){
            emptySeeds()
        }else {
            renderSeeds()
        }
    }
    
    private func pasteSeed(){
        if let clipboardText = UIPasteboard.general.string {
            if clipboardText.isValidSeed() {
                
                let missing = seeds.filter { $0.seed == clipboardText }
                    .isEmpty
                
                if missing {
                    withAnimation {
                        modelContext.insert(SeedModel(timestamp: Date(), seed: clipboardText
                            .normalizeSeed()))
                    }
                }else {
                    model.toast = .init(style: .warning, message: "Seed already saved")
                }
            }else {
                model.toast = .init(style: .error, message: "Not a valid seed")
            }
        }
    }
    
    @ViewBuilder
    private func seedRow(_ item : SeedModel) -> some View {
        VStack(alignment: .leading) {
            Text(item.seed)
                .font(.customTitle)
                .foregroundStyle(.white)
            Text("\(dateFormatter.string(from: item.timestamp))")
                .font(.customCaption)
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
