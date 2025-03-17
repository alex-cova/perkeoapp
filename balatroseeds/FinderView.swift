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
    @State private var version : Version = .v_101f
    @State private var found : [String] = []
    @State private var selections : [ItemEdition] = []
    @State private var showSheet = false
    @State private var cached = false
    @State private var searching = false
    @State private var isLoading = false
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var jokerFile : JokerFile
    static var running = false
    
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
    
    @ViewBuilder
    private func controlsView() -> some View {
 
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
                        Image(systemName: "rectangle.portrait.and.arrow.right")
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
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.yellow)
                        Text("max ante: **\(maxAnte)**")
                            .foregroundStyle(.white)
                            .font(.customBody)
                    }
                    Text("The deepest, the slow to analyze.")
                        .foregroundStyle(.white)
                        .font(.customCaption)
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
            
            
            Picker("Version", selection: $version) {
                Text("100n").tag(Version.v_100n)
                Text("101c").tag(Version.v_101c)
                Text("101f").tag(Version.v_101f)
            }.foregroundStyle(.white)
                .font(.customBody)
                .bold()
                .tint(.white)
        
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
                    
                    Toggle(isOn: $cached, label: {
                        HStack {
                            Image(systemName: cached ?  "speedometer": "gauge.with.dots.needle.0percent")
                                .foregroundStyle(.red)
                            Text("Use legendary seeds cached search")
                                .font(.customBody)
                                .foregroundStyle(.white)
                        }
                    }).onChange(of: cached){ old, new in
                        if new {
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
                        Text("Every seed has a legendary joker, but we are limited to 32, 546 posible seeds")
                            .foregroundStyle(.white)
                            .font(.customCaption)
                    }
                }.listRowBackground(Color(hex: "#2d2d2d"))
                
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
                }.listRowBackground(Color(hex: "#2d2d2d"))
                
                if !found.isEmpty {
                    DisclosureGroup("Found Seeds (\(found.count))") {
                        ForEach(found, id: \.self) { seed in
                            NavigationLink(destination: seedNavigation(seed)) {
                                Text(seed)
                                    .foregroundStyle(.white)
                            }.swipeActions {
                                Button("Save") {
                                    modelContext.insert(SeedModel(timestamp: Date(), seed: seed))
                                }.tint(.green)
                            }
                        }.listRowBackground(Color(hex: "#2d2d2d"))
                    }.foregroundStyle(.white)
                        .listRowBackground(Color(hex: "#2d2d2d"))
                }
                
            }.clipped()
                .background(Color(hex: "#1e1e1e"))
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showSheet){
                    JokerSelectorView(selections: $selections)
                }.sheet(isPresented: $searching){
                    searchView()
                        .presentationDetents([.medium])
                        .onAppear {
                            doSearch()
                        }.onDisappear {
                            FinderView.running = false
                        }
                }
        }.background(Color(hex: "#1e1e1e"))
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
        found.append(contentsOf: jokerFile.search(selections))
        print("seeds found: \(found.count)")
        searching = false
    }
    
    private func doSearch(){
        if FinderView.running {
            return
        }
        
        if !jokerFile.isEmpty {
            cacheBasedSearch()
            return
        }
        
        processed = 0
        seedsFound = 0
        found.removeAll()
        
        DispatchQueue.global(qos: .utility).async {
            FinderView.running = true
            
            var foundSeeds : Set<String> = []
            
            for i in 0..<value{
                let seed = Balatro.generateRandomString()
                
                if !FinderView.running {
                    DispatchQueue.main.async {
                        found.removeAll()
                        found.append(contentsOf: foundSeeds)
                    }
                    break
                }
                
                if foundSeeds.count > 100 {
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
                        processed = i
                        seedsFound = foundSeeds.count
                    }
                }
            }
            
            FinderView.running = false
            
            DispatchQueue.main.async {
                searching = false
                found.append(contentsOf: foundSeeds)
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
                    .font(.customTitle)
            } else {
                Text("\(seedsFound) seed found")
                    .font(.customTitle)
            }
            
            if !cached {
                ProgressView(value: Double(processed) / Double(value))
                    .padding(.horizontal)
                Text("\(processed) / \(value)")
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
