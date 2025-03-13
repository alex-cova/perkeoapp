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
    @State private var isLoading = false
    
    init(seed: String = "") {
        self.seed = seed
    }
    
    var body: some View {
        LoadingView(isShowing: $isLoading) {
            mainView()
        }
    }
    
    @ViewBuilder
    private func mainView() -> some View {
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
                getImage(x: 7, y: 8)
                    .padding()
                VStack(alignment: .leading, spacing: 10.0) {
                    Label("Analyze seed", systemImage: "sparkle.magnifyingglass")
                    Label("Generate a random seed", systemImage: "bolt")
                    Label("Copy/Paste and configurations", systemImage: "gear")
                }.foregroundStyle(.white)
                Spacer()
            }
        }.background(Color(hex: "#1e1e1e"))
            .sheet(isPresented: $configSheet) {
                configSheetView()
                    .presentationDetents([.medium, .large])
            }
    }
    
    @ViewBuilder
    private func getImage(x: Int, y : Int) -> some View {
        let frame = CGRect(x: x * 71, y: y * 95, width: 71, height: 95)
        let frame2 = CGRect(x: x * 71, y: (y + 1 ) * 95, width: 71, height: 95)
        if let cgImage = Images.jokers.cgImage?.cropping(to: frame) {
            ZStack {
                Image(decorative: cgImage, scale: Images.jokers.scale, orientation: .up)
                    .resizable()
                    .frame(width: frame.width, height: frame.height)
                
                if let cgImage2 = Images.jokers.cgImage?.cropping(to: frame2) {
                    Image(decorative: cgImage2, scale: Images.jokers.scale, orientation: .up)
                        .resizable()
                        .frame(width: frame.width, height: frame.height)
                }
            }
        }else{
            Text("fuck")
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
                                .foregroundStyle(.white)
                        }
                        Text("The deepest, the slow to analyze.")
                            .foregroundStyle(.white)
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
                }.foregroundStyle(.white)
                
                List {
                    Picker("Deck", selection: $deck) {
                        ForEach(Deck.allCases, id: \.rawValue){ deck in
                            Text(deck.rawValue).tag(deck)
                        }
                    }.foregroundStyle(.white)
                }
                
                List {
                    Picker("Stake", selection: $stake){
                        ForEach(Stake.allCases, id: \.rawValue){ stake in
                            Text(stake.rawValue).tag(stake)
                        }
                    }.foregroundStyle(.white)
                }
            }
            .listRowBackground(Color(hex: "#2d2d2d"))
            
            Section {
                HStack {
                    Image(systemName: "checkmark.rectangle.portrait.fill")
                        .foregroundStyle(.gray)
                    Text("Select the vouchers you have purchased")
                        .foregroundStyle(.gray)
                }
                DisclosureGroup("Vouchers") {
                    renderVoucher(Voucher.allCases)
                }.foregroundStyle(.white)
            }.listRowBackground(Color(hex: "#2d2d2d"))
            
            Section {
                HStack {
                    Image(systemName: "xmark.rectangle.portrait.fill")
                        .foregroundStyle(.gray)
                    Text("Select the jokers you have already purchased")
                        .foregroundStyle(.gray)
                }
                
                DisclosureGroup("Legendary Jokers") {
                    renderItems(LegendaryJoker.allCases)
                }.foregroundStyle(.white)
                
                DisclosureGroup("Rare Jokers") {
                    renderItems(RareJoker.allCases)
                }.foregroundStyle(.white)
                
                DisclosureGroup("Uncommon Jokers") {
                    renderItems(UnCommonJoker.allCases)
                }.foregroundStyle(.white)
                
                DisclosureGroup("Common Jokers") {
                    renderItems(CommonJoker.allCases)
                }.foregroundStyle(.white)
            }.listRowBackground(Color(hex: "#2d2d2d"))
            
        }.background(Color(hex: "#1e1e1e"))
        .scrollContentBackground(.hidden)
        
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
                joker.sprite(color: .white)
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
                joker.sprite(color: .white)
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
            analyze()
        }
    }
    
    private func analyze() {
        if(seed.isEmpty){ return }
        
        isLoading = true
        
        DispatchQueue.global(qos: .utility).async {
            let balatro = Balatro()
            
            for option in disabledItems {
                balatro.options.append(option)
            }
            
            balatro.deck = deck
            balatro.stake = stake
            balatro.maxDepth = maxAnte
            balatro.showman = showman
            
            let run = balatro
                .performAnalysis(seed: seed)
            
            DispatchQueue.main.async {
                if run.seed == self.seed {
                    self.run = run
                    self.isLoading = false
                }
            }
        }
        
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .modelContainer(for: SeedModel.self, inMemory: true)
    }
}

