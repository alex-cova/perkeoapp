//
//  Untitled.swift
//  balatroseeds
//
//  Created by Alex on 23/02/25.
//
import SwiftUI
import Combine
import SwiftData



struct AnalyzerView : View {
    @EnvironmentObject var model : AnalyzerViewModel
    
    var body: some View {
        mainView()
    }
    
    @ViewBuilder
    private func mainView() -> some View {
        VStack{
            HStack {
                TextField("Seed", text: $model.seed, onCommit: {
                    model.analyze()
                })
                .font(.customTitle)
                .multilineTextAlignment(.center)
                .padding(5)
                .background(.gray)
                .cornerRadius(8)
                .keyboardType(.alphabet)
                
                Button(action: {
                    model.analyze()
                }) {
                    Image(systemName: "sparkle.magnifyingglass")
                }.buttonStyle(.borderedProminent)
                    .tint(.blue)
                Button(action:model.random){
                    Image(systemName: "bolt")
                }.buttonStyle(.borderedProminent)
                    .tint(.yellow)
                Button(action:{
                    model.configSheet.toggle()
                }){
                    Image(systemName: "gear")
                }.buttonStyle(.borderedProminent)
                    .tint(.gray)
            }.padding(.horizontal)
            
            if(model.run != nil){
                PlayView()
                    .clipped()
            } else {
                Spacer()
                PerkeoView()
                VStack(alignment: .leading, spacing: 10.0) {
                    Label("Analyze seed", systemImage: "sparkle.magnifyingglass")
                        .font(.customBody)
                    Label("Generate a random seed", systemImage: "bolt")
                        .font(.customBody)
                    Label("Copy/Paste and configurations", systemImage: "gear")
                        .font(.customBody)
                }.foregroundStyle(.white)
                Spacer()
            }
        }.background(Color(hex: "#1e1e1e"))
            .sheet(isPresented: $model.configSheet) {
                configSheetView()
                    .presentationDetents([.medium, .large])
            }
    }
    
    @ViewBuilder
    private func label(_ text : String, systemImage image : String) -> some View {
        HStack {
            Image(systemName: image)
            Text(text)
                .foregroundStyle(.white)
        }
    }
    
    @ViewBuilder
    private func configSheetView() -> some View{
        Form {
            Section {
                Button(action:model.paste){
                    label("Paste Seed", systemImage: "document.on.clipboard")
                }.font(.customBody)
                
                Button(action:model.copy){
                    label("Copy Seed", systemImage: "document.on.document")
                }.font(.customBody)
                
                Button(action: {
                    model.modelContext.mainContext.insert(SeedModel(timestamp: Date(), seed: model.seed))
                    model.configSheet.toggle()
                }){
                    label("Save Seed", systemImage: "square.and.arrow.down")
                }.font(.customBody)
                
                Stepper {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundStyle(.red)
                            Text("starting ante: **\(model.startingAnte)**")
                                .foregroundStyle(.white)
                                .font(.customBody)
                        }
                    }
                } onIncrement: {
                    model.startingAnte = min(29, model.startingAnte + 1)
                    if model.startingAnte > model.maxAnte { model.maxAnte += 1 }
                } onDecrement: {
                    model.startingAnte -= 1
                    if model.startingAnte < 1 { model.startingAnte = 1 }
                }
                
                Stepper {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.yellow)
                            Text("max ante: **\(model.maxAnte)**")
                                .foregroundStyle(.white)
                                .font(.customBody)
                        }
                        Text("The deepest, the slow to analyze")
                            .foregroundStyle(.white)
                            .font(.customCaption)
                    }
                } onIncrement: {
                    model.maxAnte += 1
                    if model.maxAnte > 30 { model.maxAnte = 30 }
                } onDecrement: {
                    model.maxAnte -= 1
                    if model.maxAnte < model.startingAnte {
                        model.startingAnte = max(model.maxAnte, 1)
                    }
                    if model.maxAnte < 1 { model.maxAnte = 1 }
                }
                
                Toggle(isOn: $model.showman){
                    Text("Showman")
                        .font(.customBody)
                }.foregroundStyle(.white)
                
                List {
                    Picker("Deck", selection: $model.deck) {
                        ForEach(Deck.allCases, id: \.rawValue){ deck in
                            Text(deck.rawValue).tag(deck)
                                .font(.customBody)
                        }
                    }.foregroundStyle(.white)
                        .font(.customBody)
                }
                
                List {
                    Picker("Stake", selection: $model.stake){
                        ForEach(Stake.allCases, id: \.rawValue){ stake in
                            Text(stake.rawValue)
                                .font(.customBody)
                                .tag(stake)
                            
                        }
                    }.foregroundStyle(.white)
                        .font(.customBody)
                }
            }
            .listRowBackground(Color(hex: "#2d2d2d"))
            
            Section {
                HStack {
                    Image(systemName: "checkmark.rectangle.portrait.fill")
                        .foregroundStyle(.gray)
                    Text("Select the vouchers you have purchased")
                        .foregroundStyle(.gray)
                        .font(.customBody)
                }
                DisclosureGroup("Vouchers") {
                    renderVoucher(Voucher.allCases)
                }.foregroundStyle(.white)
                    .font(.customBody)
            }.listRowBackground(Color(hex: "#2d2d2d"))
            
            
            Section {
                HStack {
                    Image(systemName: "xmark.rectangle.portrait.fill")
                        .foregroundStyle(.gray)
                    Text("Select the jokers you have already purchased")
                        .foregroundStyle(.gray)
                        .font(.customBody)
                }
                
                DisclosureGroup("Legendary Jokers") {
                    renderItems(LegendaryJoker.allCases)
                }.foregroundStyle(.white)
                    .font(.customBody)
                
                DisclosureGroup("Rare Jokers") {
                    renderItems(RareJoker.allCases)
                }.foregroundStyle(.white)
                    .font(.customBody)
                
                DisclosureGroup("Uncommon Jokers") {
                    renderItems(UnCommonJoker.allCases)
                }.foregroundStyle(.white)
                    .font(.customBody)
                
                DisclosureGroup("Common Jokers") {
                    renderItems(CommonJoker.allCases)
                }.foregroundStyle(.white)
                    .font(.customBody)
            }.listRowBackground(Color(hex: "#2d2d2d"))
            
        }.background(Color(hex: "#1e1e1e"))
            .scrollContentBackground(.hidden)
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()),
                   GridItem(.flexible()),GridItem(.flexible())]
    
    @ViewBuilder
    private func renderItems(_ jokers: [Item]) -> some View{
        LazyVGrid(columns: columns){
            ForEach(jokers, id: \.rawValue) { joker in
                joker.sprite(color: .white)
                    .opacity(model.disabledItems.contains(where: {$0.rawValue == joker.rawValue}) ? 0.3 : 1.0)
                    .onTapGesture {
                        if model.disabledItems.contains(where: {$0.rawValue == joker.rawValue}){
                            model.disabledItems.removeAll(where: {$0.rawValue == joker.rawValue})
                        } else {
                            model.disabledItems.append(joker)
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    private func renderVoucher(_ jokers: [Item]) -> some View{
        LazyVGrid(columns: columns){
            ForEach(jokers, id: \.rawValue) { joker in
                joker.sprite(color: .white)
                    .opacity(model.disabledItems.contains(where: {$0.rawValue == joker.rawValue}) ? 1.0 : 0.3)
                    .onTapGesture {
                        
                        if model.disabledItems.contains(where: {$0.rawValue == joker.rawValue}){
                            model.disabledItems.removeAll(where: {$0.rawValue == joker.rawValue})
                        } else {
                            model.disabledItems.append(joker)
                        }
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .environment(AnalyzerViewModel())
    }
}

