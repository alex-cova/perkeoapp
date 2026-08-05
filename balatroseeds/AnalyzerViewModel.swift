//
//  AnalyzerViewModel.swift
//  balatroseeds
//
//  Created by Alex on 23/03/25.
//

import SwiftUI
import Combine
import SwiftData

public class AnalyzerViewModel : ObservableObject, Observable {
    @Published var seed : String = ""
    @Published var maxAnte : Int = 8
    @Published var startingAnte : Int = 1
    @Published var showman : Bool = false
    private var cancellables : Set<AnyCancellable> = []
    @Published var configSheet = false
    @Published var copyEvent = false
    var modelContext : ModelContainer
    @Published var disabledItems : [Item] = []
    @Published var deck : Deck = .RED_DECK
    @Published var stake : Stake = .White_Stake
    @Published var isLoading = false
    @Published var run : Run?
    @Published private var version : Version = .v_101f
    @Published var toast: Toast? = nil
    @Published var activeTab: TabItem = .analyzer
    @Published var autoBuyVoucher = true
    @Published var showInput = false
    @Published var showSummary = false
    @Published var showSaveView = false

    
    var title : String {
        get {
            if seed.isEmpty {
                return "WELCOME"
            }
            
            return seed
        }
    }
    
    init(memoryOnly: Bool = false) {
        self.modelContext  = {
            let schema = Schema([
                SeedModel.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
        
        initListeners()
    }
    
    func store(){
        if configSheet {
            configSheet = false
        }
        showSaveView.toggle()
    }
    
    @MainActor
    func store(level : JokerType, title : String){
        modelContext.mainContext.insert(
            SeedModel(timestamp: Date(), seed: seed, title: title, level: level, score: run?.score ?? 0))
        toast = .init(style: .info, message: "Seed \(seed) saved")
        showSaveView = false
    }
    
    func isSelected(_ joker : Item) -> Bool {
        if showman && joker.rawValue == UnCommonJoker.Showman.rawValue {
            return true
        }

        return disabledItems.contains(where: {$0.rawValue == joker.rawValue})
    }

    var firstAnte : Int {
        get {
            run?.antes.first?.ante ?? startingAnte
        }
    }
    
    init(modelContainer: ModelContainer){
        self.modelContext = modelContainer
        self.maxAnte = 1
    }
    
    func changeSeed(_ seed : String){
        self.startingAnte = 1
        self.maxAnte = 8
        if self.seed == seed {
            if run == nil {
                analyze()
            }
            return
        }
        self.run = nil
        self.seed = seed
        analyze()
    }
    
    private func initListeners(){
        $seed.debounce(for: 0.5, scheduler: RunLoop.main)
            .dropFirst()
            .sink { [weak self] s in
                guard let self = self else { return }
                self.normalizeSeed(newValue: String(s))
            }
            .store(in: &cancellables)
    }
    
    public func random(){
        seed = Balatro.generateRandomString()
        analyze()
    }
    
    public func copy(){
        copy(seed: self.seed)
    }
    
    public func copy(seed: String){
        if(seed.isEmpty){
            return
        }
        
        UIPasteboard.general.string = seed.uppercased()
        
        if configSheet {
            configSheet = false
        }
        
        toast = .init(style: .success, message: "Seed \(seed) copied to clipboard")
    }
    
    public func enterSeed() {
        showInput.toggle()
    }
    
    
    public func seedOfTheDay(){
        seed = Date.now.generateDailyCode()
        analyze()
    }
    
    public func paste(){
        if let clipboardText = UIPasteboard.general.string {
            if clipboardText.isValidSeed(){
                seed = clipboardText.normalizeSeed()
            }else {
                toast = .init(style: .error, message: "Not a valid seed in the clipboard")
            }
        }
        
        if configSheet {
            configSheet.toggle()
        }
        analyze()
    }
    
    private func normalizeSeed(newValue : String){
        let s = newValue.uppercased()
        
        // Filter to only allow alphanumeric characters
        var filtered = s.filter { char in
            return char.isLetter || char.isNumber
        }
        
        // Apply character limit (max 8)
        if filtered.count > 8 {
            filtered = String(newValue.prefix(8))
        }
        
        if filtered != seed {
            seed = filtered
        }
    }
    
    public var showOptions : Bool {
        get {
            return activeTab == .analyzer
        }
    }
    
    public func test() -> AnalyzerViewModel {
        analyze()
        return self
    }
        
    public func analyze() {
        if(isLoading){
            return
        }
        
        if(self.seed.isEmpty) {
            return
        }
        
        print("Loading: \(self.seed)")
        isLoading = true
        showInput = false
        
        DispatchQueue.global(qos: .utility).async {
            let balatro = Balatro()
            
            for option in self.disabledItems {
                balatro.options.append(option)
            }
            
            balatro.deck = self.deck
            balatro.stake =  self.stake
            balatro.maxDepth =  self.maxAnte
            balatro.showman =  self.showman
            balatro.startingAnte =  self.startingAnte

            let run = balatro
                .performAnalysis(seed:  self.seed.uppercased())
                        
            DispatchQueue.main.async {
                self.run = run
                self.isLoading = false
                print("Rendered: \( self.seed)")
            }
            
        }
    }
}
