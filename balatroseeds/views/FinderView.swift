//
//  FinderView.swift
//  balatroseeds
//
//  Created by Alex on 26/01/25.
//
import SwiftUI

struct FinderView : View {
    
    @State private var value = 100000
    @State private var maxAnte : Int = 1
    @State private var startingAnte : Int = 1
    
    @State private var found : [String:Int] = [:]
    @State private var selections : [ItemEdition] = []
    @State private var showSheet = false
    @State private var cached = false
    @State private var instant = false
    @State private var searching = false
    @State private var isLoading = false
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var jokerFile : JokerFile
    static var running = false
    static var finished = 0
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
    
    func changeEdition(){
        var x : [ItemEdition] = []
        x.append(contentsOf: selections)
        //selections.clear()
        selections.removeAll()
        selections.append(contentsOf: x)
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
                    
                    DispatchQueue.global(qos: .utility).async {
                        _ = self.jokerFile.readInstant()
                        
                        DispatchQueue.main.async {
                            print("Read data: \(self.jokerFile.compressed.count)")
                            self.isLoading = false
                        }
                    }
                    
                    
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
                    
                    DispatchQueue.global(qos: .utility).async {
                        _ = self.jokerFile.read()
                        
                        DispatchQueue.main.async {
                            print("Read data: \(self.jokerFile.jokerData.count)")
                            self.isLoading = false
                          
                        }
                    }
                    
                    
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
                    
                    if !selections.isEmpty {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(selections, id: \.self.rawValue) { joker in
                                    joker.sprite()
                                        .onTapGesture {
                                            if cached {
                                                joker.nextEdition()
                                                changeEdition()
                                            }
                                        }
                                }
                            }
                        }
                    }
                    
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
                }.sheet(isPresented: $searching){
                    searchView()
                        .presentationDetents([.medium])
                        .presentationBackground(Color.customBackground)
                        .onAppear {
                            doSearch()
                        }.onDisappear {
                            FinderView.running = false
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
                NavigationLink(destination: seedNavigation(seed)
                    .onAppear {
                        model.changeSeed(seed)
                    }
                    .navigationTitle(seed)
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
                    .environmentObject(model)) {
                    if cached {
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
    
    @ViewBuilder
    private func label(_ text : String, systemImage image : String) -> some View {
        HStack {
            Image(systemName: image)
                .foregroundStyle(.red)
            Text(text)
                .font(.customBody)
                .foregroundStyle(.white)
        }
    }
    
    
    private func cacheBasedSearch() {
        print("Using cached search!")
        found.removeAll()
        //found.append(contentsOf: jokerFile.search(selections))
        
        let f = jokerFile.search(selections)
        
        for i in f {
            found[i.key] = i.value
        }
        
        print("seeds found: \(found.count)")
        searching = false
    }
    
    private func doSearch(){
        if FinderView.running {
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
        
        let concurrentQueue = DispatchQueue(label: "com.perkeo.concurrentqueue", attributes: .concurrent)
        
        print("Split: \(split) max ante: \(maxAnte)")
        
        func job() {
            FinderView.running = true
            
            var foundSeeds : Set<String> = []
            var last = 0
            
            for i in 0..<split{
                let seed = Balatro.generateRandomString()
                
                if !FinderView.running {
                    DispatchQueue.main.async {
                        for i in foundSeeds {
                            found[i] = 0
                        }
                    }
                    break
                }
                
                if foundSeeds.count > 25 {
                    FinderView.finished += 1
                    break
                }
                
                let balatro = Balatro()
                balatro.maxDepth = maxAnte
                balatro.startingAnte = startingAnte
                
                let play = balatro
                    .configureForSpeed(selections: selections)
                    .performAnalysis(seed: seed)
                
                if selections.allSatisfy({ play.contains($0) }) {
                    foundSeeds.insert(seed)
                }
                
                let currentMillis = Int(Date().timeIntervalSince1970 * 1000)
                
                if currentMillis % 1000 == 0 {
                    DispatchQueue.main.async {
                        processed += (i - last)
                        last = i
                        seedsFound += foundSeeds.count
                    }
                }
            }
            
            FinderView.finished += 1
            
            if FinderView.finished >= jobs {
                FinderView.running = false
                DispatchQueue.main.async {
                    searching = false
                    
                    for i in foundSeeds {
                        found[i] = 0
                    }
                }
            }
        }
        
        for _ in 0..<jobs {
            concurrentQueue.async {
                job()
            }
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
            
            if !cached {
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
                FinderView.running = false
                searching.toggle()
            }, label: {
                Label("Stop", systemImage: "xmark")
            }).tint(.red)
        }
    }
}



#Preview {
    TabView {
        FinderView()
            .modelContainer(for: SeedModel.self, inMemory: true)
    }
}
