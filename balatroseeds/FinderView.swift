//
//  FinderView.swift
//  balatroseeds
//
//  Created by Alex on 26/01/25.
//
import SwiftUI

struct FinderView : View {
    
    @State private var value = 100000
    @State private var maxDepth : Int = 1
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
            Stepper {
                VStack {
                    Text("Seeds")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text("\(value)")
                }
            } onIncrement: {
                incrementStep()
            } onDecrement: {
                decrementStep()
            }
            .padding(5)
            Stepper {
                VStack {
                    Text("Max Ante")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text("\(maxDepth)")
                }
            } onIncrement: {
                maxDepth = min(maxDepth + 1, 25)
            } onDecrement: {
                maxDepth = max(maxDepth - 1, 1)
                
            }
            .padding(5)
            Picker("Version", selection: $version) {
                Text("\(Version.v_100n)").tag(Version.v_100n)
                Text("\(Version.v_101c)").tag(Version.v_101c)
                Text("\(Version.v_101f)").tag(Version.v_101f)
            }
            
            if !found.isEmpty {
                Button("Clear \(found.count)") {
                    selections.removeAll()
                    found.removeAll()
                }.tint(.red)
            }
            
            Section {
                Button(selections.isEmpty ? "Select Jokers" : "Selections \(selections.count)") {
                    showSheet.toggle()
                }
                
                if !selections.isEmpty {
                    Button("Search") {
                        if(!selections.isEmpty){
                            searching.toggle()
                        }
                    }.tint(.green)
                }
            }
            
            ForEach(found, id: \.self) { seed in
                NavigationLink(destination: PlayView(run: Balatro()
                    .performAnalysis(seed: seed))) {
                        Text(seed)
                    }.swipeActions {
                        Button("Save") {
                            modelContext.insert(SeedModel(timestamp: Date(), seed: seed))
                        }.tint(.green)
                    }
            }
            
        }.navigationTitle("Seed Finder")
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
    
    static var running = false
    
    private func doSearch(){
        if FinderView.running {
            return
        }
        
        progress = 0.0
        processed = 0
        seedsPerSecond = 0
        
        DispatchQueue.global(qos: .utility).async {
            FinderView.running = true
            let startTime = Date()
            
            for i in 0..<value{
                let seed = Balatro.generateRandomString()
                
                if !FinderView.running {
                    break
                }
                
                var currentMillis = Int(Date().timeIntervalSince1970 * 1000)
                
                var balatro = Balatro()
                balatro.maxDepth = maxDepth
                
                let play = balatro
                    .configureForSpeed(selections: selections)
                    .performAnalysis(seed: seed)
                
                currentMillis = Int(Date().timeIntervalSince1970 * 1000) - currentMillis
                
                if selections.allSatisfy({ play.contains($0) }) {
                    found.append(seed)
                }
                
                if i % 1000 == 0 {
                    DispatchQueue.main.async {
                        progress = Double(i) / max(Double(value), 1)
                        processed = i
                        speed = currentMillis
                        seedsPerSecond = Int(Double(i) / max(Double(Date().timeIntervalSince(startTime)), 1.0))
                    }
                }
            }
            
            FinderView.running = false
            
            DispatchQueue.main.async {
                searching = false
            }
            
        }
    }
    
    @State private var progress  = 0.0
    @State private var processed = 0
    @State private var speed = 0
    @State private var seedsPerSecond = 0
    
    @ViewBuilder
    private func searchView() -> some View{
        VStack {
            Image("triboulete")
            
            if found.isEmpty {
                Text("Searching...")
                    .font(.title2)
            } else {
                Text("\(found.count) seed found")
                    .font(.title2)
            }
            
            ProgressView(value: progress)
                .padding(.horizontal)
            Text("\(processed) / \(value)")
                .foregroundStyle(.gray)
            Text("\(speed) ms, | \(seedsPerSecond) Op/s")
                .font(.caption)
                .foregroundStyle(.gray)
            Spacer()
                .frame(height: 70)
            Divider()
                .padding()
            Button("Stop") {
                FinderView.running = false
                searching.toggle()
            }.tint(.red)
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
            Text(selections.isEmpty ? "Select" : "Selected: \(selections.count)")
                .font(.title2)
                .padding()
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
        }
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
            joker.sprite()
                .opacity(Double(selected ? 1 : 0.3))
            Text(joker.rawValue)
                .font(.caption)
                .foregroundStyle(selected ? .blue : .gray)
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
            joker.sprite()
                .opacity(Double(selected ? 1 : 0.3))
            Text(joker.rawValue)
                .font(.caption)
                .foregroundStyle(selected ? .blue : .gray)
        }.onTapGesture {
            selected.toggle()
            onSelect(selected)
        }
    }
}

#Preview {
    NavigationStack {
        FinderView()
            .modelContainer(for: SeedModel.self, inMemory: true)
    }
}
