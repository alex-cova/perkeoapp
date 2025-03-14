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
    @State private var selections : [Item] = []
    @State private var showSheet = false
    @State private var searching = false
    
    @Environment(\.modelContext) private var modelContext
    
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
        Form {
            
            Text("Seed Finder")
                .font(.title.weight(.semibold))
                .foregroundStyle(.white)
                .listRowBackground(EmptyView())
            Section {
                Stepper {
                    VStack {
                        Text("Seeds to analyze")
                            .font(.caption)
                            .foregroundStyle(.white)
                        Text("\(value)")
                            .foregroundStyle(.white)
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
                    .bold()
                    .tint(.white)
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
                selectorView()
            }.sheet(isPresented: $searching){
                searchView()
                    .presentationDetents([.medium])
                    .onAppear {
                        doSearch()
                    }.onDisappear {
                        FinderView.running = false
                    }
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
    
    
    
    
    static var running = false
    
    private func doSearch(){
        if FinderView.running {
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
                    .font(.title2)
            } else {
                Text("\(seedsFound) seed found")
                    .font(.title2)
            }
            
            ProgressView(value: Double(processed) / Double(value))
                .padding(.horizontal)
            Text("\(processed) / \(value)")
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
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @ViewBuilder
    private func selectableJoker(_ joker : Item) -> some View {
        let selected = selections.first(where: { $0.rawValue == joker.rawValue }) != nil
        
        SelectableJokerView(selected: selected, joker: joker, onSelect: { j in
            if(j){
                if !selections.contains(where: { $0.rawValue == joker.rawValue}){
                    selections.append(joker)
                }
            } else {
                selections.removeAll(where: {
                    $0.rawValue == joker.rawValue
                })
            }
        })
    }
    
    @ViewBuilder
    private func legendarySelectableJoker(_ joker : LegendaryJoker) -> some View {
        let selected = selections.first(where: { $0.rawValue == joker.rawValue }) != nil
        
        LegendarySelectableJokerView(selected: selected, joker: joker, onSelect: { j in
            if(j){
                if !selections.contains(where: { $0.rawValue == joker.rawValue}){
                    selections.append(joker)
                }
            } else {
                selections.removeAll(where: {
                    $0.rawValue == joker.rawValue
                })
            }
        })
    }
    
    @ViewBuilder
    private func selectorView() -> some View {
        VStack {
            Text(selections.isEmpty ? "Joker Selection" : "Jokers Selected: \(selections.count)")
                .font(.title2)
                .padding()
                .foregroundStyle(.white)
            Text("Be aware that complex combinations may not work")
                .font(.caption)
                .foregroundStyle(.white)
            Divider()
                .padding(.horizontal)
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(LegendaryJoker.allCases, id: \.rawValue) { joker in
                        legendarySelectableJoker(joker)
                    }
                    ForEach(RareJoker.allCases, id: \.rawValue) { joker in
                        selectableJoker(joker)
                    }
                    ForEach(UnCommonJoker.allCases, id: \.rawValue) { joker in
                        selectableJoker(joker)
                    }
                    ForEach(CommonJoker.allCases, id: \.rawValue) { joker in
                        selectableJoker(joker)
                    }
                }.padding()
            }
        }.background(Color(hex: "#4d4d4d"))
    }
}

struct LegendarySelectableJokerView : View {
    
    @State var selected = false
    let joker : LegendaryJoker
    let onSelect : (Bool) -> Void
    
    init(selected: Bool = false, joker: LegendaryJoker, onSelect: @escaping (Bool) -> Void) {
        self._selected = State(initialValue: selected)
        self.joker = joker
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack {
            joker.sprite(color: selected ? .blue : .gray)
                .opacity(Double(selected ? 1 : 0.3))
        }.onTapGesture {
            selected.toggle()
            onSelect(selected)
        }
    }
}

struct SelectableJokerView : View {
    
    @State var selected = false
    let joker : Item
    let onSelect : (Bool) -> Void
    
    init(selected: Bool = false, joker: Item, onSelect: @escaping (Bool) -> Void) {
        self._selected = State(initialValue: selected)
        self.joker = joker
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack {
            joker.sprite(color: selected ? .blue : .gray)
                .opacity(Double(selected ? 1 : 0.3))
        }.onTapGesture {
            selected.toggle()
            onSelect(selected)
        }
    }
}

#Preview {
    TabView {
        FinderView()
            .modelContainer(for: SeedModel.self, inMemory: true)
    }
}
