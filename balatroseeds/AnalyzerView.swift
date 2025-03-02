//
//  Untitled.swift
//  balatroseeds
//
//  Created by Alex on 23/02/25.
//
import SwiftUI

struct AnalyzerView : View {
    
    @State var seed = "IGSPUNF"
    @State var run : Run?
    @State var maxAnte = 8
    @Environment(\.modelContext) private var modelContext
    @State var configSheet = false
    @State var showman = false
    
    init(seed: String = "") {
        self.seed = seed
    }
    
    var body: some View {
        VStack{
            HStack {
                TextField("Seed", text: $seed)
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .background(.gray)
                    .cornerRadius(8)
                    .onSubmit {
                        analyze()
                    }
                Button(action: analyze) {
                    Image(systemName: "sparkle.magnifyingglass")
                }.buttonStyle(.borderedProminent)
                    .tint(.blue)
                Button(action:random){
                    Image(systemName: "bolt")
                }.buttonStyle(.borderedProminent)
                    .tint(.yellow)
                Button(action:{
                    configSheet.toggle()
                }){
                    Image(systemName: "gear")
                }.buttonStyle(.borderedProminent)
                    .tint(.gray)
            }.padding(.horizontal)
            
            if(run != nil){
                PlayView(run: run!)
                    .clipped()
            } else {
                Spacer()
            }
        }.background(Color(hex: "#1e1e1e"))
            .sheet(isPresented: $configSheet) {
                configSheetView()
                    .presentationDetents([.medium, .large])
            }
    }
    
    @ViewBuilder
    private func label(_ text : String, systemImage image : String) -> some View {
        HStack {
            Image(systemName: image)
            Text(text)
                .foregroundStyle(Color.primary)
        }
    }
    
    @ViewBuilder
    private func configSheetView() -> some View{
        Form {
            Button(action:paste){
                label("Paste Seed", systemImage: "document.on.clipboard")
            }
            
            Button(action:copy){
                label("Copy Seed", systemImage: "document.on.document")
            }
            
            Button(action: {
                modelContext.insert(SeedModel(timestamp: Date(), seed: seed))
                configSheet.toggle()
            }){
                label("Save Seed", systemImage: "square.and.arrow.down")
            }
            Stepper {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.yellow)
                        Text("max ante: **\(maxAnte)**")
                    }
                    Text("The deepest, the slow to analyze.")
                        .foregroundStyle(.gray)
                        .font(.caption)
                }
            } onIncrement: {
                maxAnte += 1
                if maxAnte > 30 { maxAnte = 30 }
            } onDecrement: {
                maxAnte -= 1
                if maxAnte < 1 { maxAnte = 1 }
            }.padding(5)
            
            Toggle(isOn: $showman){
                Text("Showman")
            }
            
            List {
                Picker("Deck", selection: $deck) {
                    ForEach(Deck.allCases, id: \.rawValue){ deck in
                        Text(deck.rawValue).tag(deck)
                    }
                }
            }
            
            List {
                Picker("Stake", selection: $stake){
                    ForEach(Stake.allCases, id: \.rawValue){ stake in
                        Text(stake.rawValue).tag(stake)
                    }
                }
            }
            
            Section {
                HStack {
                    Image(systemName: "checkmark.rectangle.portrait.fill")
                        .foregroundStyle(.gray)
                    Text("Select the vouchers you want to enable")
                        .foregroundStyle(.gray)
                }
                DisclosureGroup("Vouchers") {
                    renderVoucher(Voucher.allCases)
                }
            }
            
            Section {
                HStack {
                    Image(systemName: "xmark.rectangle.portrait.fill")
                        .foregroundStyle(.gray)
                    Text("Select the jokers you want to disable")
                        .foregroundStyle(.gray)
                }
                
                DisclosureGroup("Legendary Jokers") {
                    renderItems(LegendaryJoker.allCases)
                }
                
                DisclosureGroup("Rare Jokers") {
                    renderItems(RareJoker.allCases)
                }
                
                DisclosureGroup("Uncommon Jokers") {
                    renderItems(UnCommonJoker.allCases)
                }
                
                DisclosureGroup("Common Jokers") {
                    renderItems(CommonJoker.allCases)
                }
            }
            
        }
        
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()),
                   GridItem(.flexible()),GridItem(.flexible())]
    
    @State var disabledItems : [Item] = []
    @State var deck : Deck = .RED_DECK
    @State var stake : Stake = .White_Stake
    
    @ViewBuilder
    private func renderItems(_ jokers: [Item]) -> some View{
        LazyVGrid(columns: columns){
            ForEach(jokers, id: \.rawValue) { joker in
                joker.sprite(color: .black)
                    .opacity(disabledItems.contains(where: {$0.rawValue == joker.rawValue}) ? 0.3 : 1.0)
                    .onTapGesture {
                        
                        if disabledItems.contains(where: {$0.rawValue == joker.rawValue}){
                            disabledItems.removeAll(where: {$0.rawValue == joker.rawValue})
                        } else {
                            disabledItems.append(joker)
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    private func renderVoucher(_ jokers: [Item]) -> some View{
        LazyVGrid(columns: columns){
            ForEach(jokers, id: \.rawValue) { joker in
                joker.sprite(color: .black)
                    .opacity(disabledItems.contains(where: {$0.rawValue == joker.rawValue}) ? 1.0 : 0.3)
                    .onTapGesture {
                        
                        if disabledItems.contains(where: {$0.rawValue == joker.rawValue}){
                            disabledItems.removeAll(where: {$0.rawValue == joker.rawValue})
                        } else {
                            disabledItems.append(joker)
                        }
                    }
            }
        }
    }
    
    private func random(){
        seed = Balatro.generateRandomString()
        analyze()
    }
    
    private func copy(){
        UIPasteboard.general.string = seed
        configSheet.toggle()
    }
    
    private func paste(){
        if let clipboardText = UIPasteboard.general.string {
            seed = clipboardText
            configSheet.toggle()
        }
    }
    
    private func analyze(){
        if(seed.isEmpty){ return }
        
        let balatro = Balatro()
        
        for option in disabledItems {
            balatro.options.append(option)
        }
        
        balatro.deck = deck
        balatro.stake = stake
        balatro.maxDepth = maxAnte
        balatro.showman = showman
        
        run = balatro
            .performAnalysis(seed: seed)
        
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .modelContainer(for: SeedModel.self, inMemory: true)
    }
}

