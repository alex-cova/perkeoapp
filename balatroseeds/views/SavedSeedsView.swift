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
                        .toolbar {
                            Button(action: {
                                model.showSummary.toggle()
                            }) {
                                Image(systemName:"checklist")
                            }.tint(.red)
                            Button(action: {
                                model.copy()
                            }) {
                                Image(systemName:"document.on.clipboard")
                            }.tint(.red)
                            Button(action: {
                                model.configSheet.toggle()
                            }) {
                                Image(systemName:"gear")
                            }.tint(.red)
                        }
                        .environmentObject(model)
                        .onAppear {
                            model.changeSeed(item.seed)
                        }.navigationTitle(item.seed)) {
                            seedRow(item)
                        }.listRowBackground(Color.customRowBackground)
                        
                    
                }
                .onDelete(perform: deleteItems)
            }.background(Color.customBackground)
                .scrollContentBackground(.hidden)
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
            UnCommonJoker.Joker_Stencil.sprite()
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
                        model.seed = clipboardText
                        model.showSaveView.toggle()
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
            if let title = item.title {
                Text(title)
                    .font(.customCaption)
                    .foregroundStyle(.white)
            }
            
            HStack {
                Text("\(dateFormatter.string(from: item.timestamp))")
                    .font(.customCaption)
                    .foregroundStyle(.white)
                
                if let level = item.level {
                    Text(level.rawValue)
                        .font(.customCaption)
                        .foregroundStyle(.white)
                }
                
                if let score = item.score {
                    Text("Score: \(score)")
                        .font(.customCaption)
                        .foregroundStyle(.white)
                }
            }
            
            
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                model.modelContext.mainContext.delete(seeds[index])
            }
        }
    }
}


#Preview {
    TabView {
        SavedSeedsView()
            .environmentObject(AnalyzerViewModel())
    }
}
