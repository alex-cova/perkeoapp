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
    @Published var seed : String = "IGSPUNF"
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
    }
    
    private func initListeners(){
        $seed.debounce(for: 0.5, scheduler: RunLoop.main)
            .dropFirst()
            .sink { [weak self] s in
                guard let self = self else { return }
                self.normalizeSeed(newValue: String(s))
                analyze()
            }
            .store(in: &cancellables)
    }
    
    public func random(){
        seed = Balatro.generateRandomString()
    }
    
    public func copy(){
        UIPasteboard.general.string = seed
        
        if configSheet {
            configSheet = false
        }
        
        toast = .init(style: .success, message: "Seed \(seed) copied to clipboard")
    }
    
    public func paste(){
        if let clipboardText = UIPasteboard.general.string {
            if clipboardText.isValidSeed(){
                seed = clipboardText.normalizeSeed()
            }else {
                print("invalid seed")
            }
        }
        configSheet.toggle()
    }
    
    private func normalizeSeed(newValue : String){
        var s = newValue.uppercased()
        // Apply character limit (max 8)
        if newValue.count > 8 {
            s = String(newValue.prefix(8))
        }
        
        // Filter to only allow alphanumeric characters
        let filtered = s.filter { char in
            return char.isLetter || char.isNumber
        }
        
        if filtered != seed {
            seed = filtered
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
        
        print("Loading: \(self.seed)")
        isLoading = true
        
        DispatchQueue.global(qos: .utility).async {
            let balatro = Balatro()
            
            for option in  self.disabledItems {
                balatro.options.append(option)
            }
            
            balatro.deck = self.deck
            balatro.stake =  self.stake
            balatro.maxDepth =  self.maxAnte
            balatro.showman =  self.showman
            balatro.startingAnte =  self.startingAnte
            
        
            let run = balatro
                .performAnalysis(seed:  self.seed)
                        
            DispatchQueue.main.async {
                self.run = run
                self.isLoading = false
                print("Rendered: \( self.seed)")
            }
            
        }
    }
}
