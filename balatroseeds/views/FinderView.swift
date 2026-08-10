//
//  FinderView.swift
//  balatroseeds
//
//  Created by Alex on 26/01/25.
//
import SwiftUI

struct FinderView : View {
    
    @State private var value = 1000000
    @State private var maxAnte : Int = 1
    @State private var startingAnte : Int = 1
    
    @State private var found : [String:Int] = [:]
    @State private var selections : [ItemEdition] = []
    @State private var showSheet = false
    @State private var cached = false
    @State private var instant = false
    @State private var searching = false
    @State private var isLoading = false
    @State private var searchTask : Task<Void, Never>? = nil
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var jokerFile : JokerFile
    @EnvironmentObject var model : AnalyzerViewModel
    var cachedDescription : String  {
        get {
            "Every seed has a legendary joker, but we are limited to \(jokerFile.jokerData.count.formatted()) posible seeds"
        }
    }
    
    var compressedDescription : String  {
        get {
            "Every seed has a Joker/Card of your selection, but we don't know the order. \(jokerFile.compressed.count.formatted()) posible seeds in the palm of your hand"
        }
    }
    
    func incrementStep() {
        value += 10000
    }
    
    func decrementStep() {
        value -= 10000
        if value < 10000 {
            value = 10000
        }
    }
    
    var body: some View {
        LoadingView(isShowing: $isLoading) {
            mainView()
        }
    }
    
    var heavySearch : Bool {
        get {
            maxAnte - startingAnte > 8
        }
    }
    
    @ViewBuilder
    private func controlsView() -> some View {
        DisclosureGroup("Heavy Search") {
            Stepper {
                VStack {
                    Text("Seeds to analyze")
                        .font(.customCaption)
                        .foregroundStyle(.white)
                    Text("\(value)")
                        .foregroundStyle(.white)
                        .font(.customBody)
                        .bold()
                    
                }
            } onIncrement: {
                incrementStep()
            } onDecrement: {
                decrementStep()
            }
            .padding(5)
            
            Stepper {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "arrow.right.square")
                            .foregroundStyle(.red)
                        Text("starting ante: **\(startingAnte)**")
                            .font(.customBody)
                            .foregroundStyle(.white)
                    }
                }
            } onIncrement: {
                startingAnte = min(29, startingAnte + 1)
                if startingAnte > maxAnte { maxAnte += 1 }
            } onDecrement: {
                startingAnte -= 1
                if startingAnte < 1 { startingAnte = 1 }
            }
            
            
            Stepper {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: heavySearch ? "exclamationmark.triangle.fill" : "arrow.left.square")
                            .foregroundStyle(heavySearch ? .yellow : .red)
                        Text("last ante: **\(maxAnte)**")
                            .foregroundStyle(.white)
                            .font(.customBody)
                    }
                    
                    if(heavySearch){
                        Text("This might take a while")
                            .foregroundStyle(.white)
                            .font(.customCaption)
                    }
                }
            } onIncrement: {
                maxAnte += 1
                if maxAnte > 30 { maxAnte = 30 }
            } onDecrement: {
                maxAnte -= 1
                if maxAnte < startingAnte {
                    startingAnte = max(maxAnte, 1)
                }
                if maxAnte < 1 { maxAnte = 1 }
            }
        }.font(.customBody)
            .foregroundStyle(Color(UIColor.systemRed))
    }
    
    
    @ViewBuilder
    private func instantSection() -> some View {
        Toggle(isOn: $instant, label: {
            HStack {
                Image(systemName: cached ?  "bolt.fill": "bolt")
                    .foregroundStyle(.red)
                    .font(.title)
                VStack(alignment: .leading) {
                    Text("Use instant search")
                        .font(.customBody)
                        .foregroundStyle(.white)
                    Text("Selections will appear at any ante")
                        .font(.customCaption)
                        .foregroundStyle(.white)
                }
            }
        }).onChange(of: instant){ old, new in
            if new {
                _cached.wrappedValue = false
                Task {
                    self.isLoading = true
                    _ = await self.jokerFile.readInstant()
                    print("Read data: \(self.jokerFile.compressed.count)")
                    self.isLoading = false
                }
            }
        }
        if instant {
            Text(compressedDescription)
                .foregroundStyle(.white)
                .font(.customCaption)
        }
    }
    
    @ViewBuilder
    private func legendarySection() -> some View {
        Toggle(isOn: $cached, label: {
            HStack {
                Image(systemName: cached ?  "speedometer": "gauge.with.dots.needle.0percent")
                    .foregroundStyle(.red)
                    .font(.title)
                VStack {
                    Text("Use legendary search")
                        .font(.customBody)
                        .foregroundStyle(.white)
                    Text("Every seed has a legendary joker")
                        .font(.customCaption)
                        .foregroundStyle(.white)
                }
            }
        }).onChange(of: cached){ old, new in
            if new {
                _instant.wrappedValue = false
                Task {
                    self.isLoading = true
                    _ = await self.jokerFile.read()
                    print("Read data: \(self.jokerFile.jokerData.count)")
                    self.isLoading = false
                }
            }
        }
        if cached {
            Text(cachedDescription)
                .foregroundStyle(.white)
                .font(.customCaption)
        }
    }
    
    @ViewBuilder
    private func mainView() -> some View {
        VStack {
            AnimatedTitle(text: "Seed Finder")
            Form {
                Section {
                    if !cached {
                        controlsView()
                    }
                    legendarySection()
                    instantSection()
                }.listRowBackground(Color.customRowBackground)
                
                Section {
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        if selections.isEmpty {
                            label("Select Jokers",
                                  systemImage: "circle")
                        }else {
                            label("Selections: (\(selections.count))",
                                  systemImage: "checkmark.circle")
                        }
                    })
                    
                    if !found.isEmpty || !selections.isEmpty {
                        Button(action: {
                            selections.removeAll()
                            found.removeAll()
                        }, label: {
                            label("Clear selections", systemImage: "xmark")
                        }).tint(.red)
                    }
                    
                    if !selections.isEmpty {
                        Button(action: {
                            searching.toggle()
                        }, label: {
                            label("Search", systemImage: "magnifyingglass")
                        }).tint(.green)
                    }
                }.listRowBackground(Color.customRowBackground)
                
                if !found.isEmpty {
                    renderSeeds()
                }
                 
            }.clipped()
                .background(Color.customBackground)
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showSheet){
                    JokerSelectorView(selections: $selections)
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                }.sheet(isPresented: $searching){
                    searchView()
                        .presentationDetents([.medium])
                        .presentationBackground(Color.customBackground)
                        .onAppear {
                            doSearch()
                        }.onDisappear {
                            searchTask?.cancel()
                        }
                }
                .navigationDestination(for: String.self) { seed in
                    seedNavigation(seed)
                        .onAppear {
                            model.changeSeed(seed)
                        }
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
                }
        }.background(Color.customBackground)
    }
    
    private func keys() -> [String] {
        if cached {
            return found.keys.sorted { found[$0]! > found[$1]! }
        }
        
        return found.keys.shuffled()
    }
    
    @ViewBuilder
    private func renderSeeds() -> some View{
        DisclosureGroup("Found Seeds (\(found.count))") {
            ForEach(keys(), id: \.self) { seed in
                NavigationLink(value: seed) {
                    if cached || instant {
                        VStack(alignment: .leading) {
                            Text(seed)
                                .font(.customBody)
                                .foregroundStyle(.white)
                            Text("score: \(found[seed]!)")
                                .font(.customCaption)
                                .foregroundStyle(.white)
                        }
                    }else {
                        Text(seed)
                            .foregroundStyle(.white)
                    }

                }.swipeActions {
                    Button("Save") {
                        modelContext.insert(SeedModel(timestamp: Date(), seed: seed))
                    }.tint(.green)
                    Button("Copy") {
                        model.copy(seed: seed)
                    }.tint(.blue)
                }
            }.listRowBackground(Color.customRowBackground)
        }.foregroundStyle(.white)
            .listRowBackground(Color.customRowBackground)
    }
    
    private func cacheBasedSearch() {
        print("Using cached search!")

        let f = jokerFile.search(selections)

        print("seeds found: \(f.count)")

        found.removeAll()

        for i in f {
            found[i.key] = i.value
        }

        searching = false
    }

    @MainActor
    private func report(processedDelta: Int, foundDelta: Int) {
        processed += processedDelta
        seedsFound += foundDelta
    }

    private func doSearch(){
        if searchTask != nil {
            return
        }

        if !jokerFile.isEmpty && (cached || instant) {
            cacheBasedSearch()
            return
        }

        processed = 0
        seedsFound = 0
        found.removeAll()

        let jobs = 3
        let split = value / jobs
        let selections = self.selections
        let maxAnte = self.maxAnte
        let startingAnte = self.startingAnte

        print("Split: \(split) max ante: \(maxAnte)")

        searchTask = Task {
            let allFound = await withTaskGroup(of: Set<String>.self) { group in
                for _ in 0..<jobs {
                    group.addTask {
                        var foundSeeds : Set<String> = []
                        var lastIndex = 0
                        var lastFoundCount = 0
                        var lastReportedAt = Date()

                        for i in 0..<split {
                            if Task.isCancelled {
                                break
                            }

                            if foundSeeds.count > 25 {
                                break
                            }

                            let seed = Balatro.generateRandomString()

                            let balatro = Balatro()
                            balatro.maxDepth = maxAnte
                            balatro.startingAnte = startingAnte

                            let play = balatro
                                .configureForSpeed(selections: selections)
                                .performAnalysis(seed: seed)

                            if selections.allSatisfy({ play.contains($0) }) {
                                foundSeeds.insert(seed)
                            }

                            let now = Date()
                            if now.timeIntervalSince(lastReportedAt) >= 1 {
                                let processedDelta = i - lastIndex
                                let foundDelta = foundSeeds.count - lastFoundCount
                                lastIndex = i
                                lastFoundCount = foundSeeds.count
                                lastReportedAt = now
                                await report(processedDelta: processedDelta, foundDelta: foundDelta)
                            }
                        }

                        return foundSeeds
                    }
                }

                var merged : Set<String> = []
                for await seeds in group {
                    merged.formUnion(seeds)
                }
                return merged
            }

            for seed in allFound {
                found[seed] = 0
            }
            seedsFound = allFound.count
            searching = false
            searchTask = nil
        }
    }
    
    @State private var processed = 0
    @State private var seedsFound = 0
    
    @ViewBuilder
    private func searchView() -> some View{
        VStack {
            TribouleteView()
            
            if seedsFound == 0 {
                Text("Searching...")
                    .foregroundStyle(.white)
                    .font(.customTitle)
            } else {
                Text("\(seedsFound) seed found")
                    .foregroundStyle(.white)
                    .font(.customTitle)
            }
            
            if !cached && !instant {
                ProgressView(value: Double(processed) / Double(value))
                    .padding(.horizontal)
                Text("\(processed) / \(value)")
                    .foregroundStyle(.white)
                    .font(.customBody)
            }
            Spacer()
                .frame(height: 70)
            Divider()
                .padding()
                
            Button(action: {
                searchTask?.cancel()
                searching.toggle()
            }, label: {
                Label("Stop", systemImage: "xmark")
            }).tint(.red)
        }
    }
}



#Preview {
    NavigationStack {
        FinderView()
    }
    .modelContainer(for: SeedModel.self, inMemory: true)
    .environmentObject(AnalyzerViewModel(memoryOnly: true))
    .environmentObject(JokerFile())
}
