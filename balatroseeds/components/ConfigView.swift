//
//  ConfigView.swift
//  balatroseeds
//
//  Created by Alex on 18/04/25.
//
import SwiftUI

struct ConfigView : View {
    
    @EnvironmentObject var model : AnalyzerViewModel
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()),
                   GridItem(.flexible()),GridItem(.flexible())]
    
    var body: some View {
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
                    renderVoucher(Voucher.allCases, columns: columns, model: model)
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
                    renderItems(LegendaryJoker.allCases, columns: columns, model: model)
                }.foregroundStyle(.white)
                    .font(.customBody)
                
                DisclosureGroup("Rare Jokers") {
                    renderItems(RareJoker.allCases, columns: columns, model: model)
                }.foregroundStyle(.white)
                    .font(.customBody)
                
                DisclosureGroup("Uncommon Jokers") {
                    renderItems(UnCommonJoker.allCases, columns: columns, model: model)
                }.foregroundStyle(.white)
                    .font(.customBody)
                
                DisclosureGroup("Common Jokers") {
                    renderItems(CommonJoker.allCases, columns: columns, model: model)
                }.foregroundStyle(.white)
                    .font(.customBody)
            }.listRowBackground(Color(hex: "#2d2d2d"))
            
        }.background(Color(hex: "#1e1e1e"))
            .scrollContentBackground(.hidden)
    }
}

