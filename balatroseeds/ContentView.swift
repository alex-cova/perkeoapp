//
//  ContentView.swift
//  balatroseeds
//
//  Created by Alex on 03/01/25.
//

import SwiftUI
import CoreGraphics
import SwiftData


class Images {
    static let bosses = UIImage(named: "BlindChips")!
    static let vouchers = UIImage(named: "Vouchers")!
    static let jokers = UIImage(named: "Jokers")!
    static let tarots = UIImage(named: "Tarots")!
    static let tags = UIImage(named: "tags")!
    static let cards = UIImage(named: "8BitDeck")!
    static let editions = UIImage(named: "Editions")!
    static let sprite = SpriteSheet()
}



struct EditionView: ViewModifier {
    var edition: Edition
    
    @ViewBuilder
    private func getImage(_ index: Int) -> some View {
        let frame = CGRect(x: index * 71, y: 0, width: 71, height: 95)
        if let cgImage = Images.editions.cgImage?.cropping(to: frame) {
            Image(decorative: cgImage, scale: Images.editions.scale, orientation: .up)
                .resizable()
                .frame(width: frame.width, height: frame.height)
        }else{
            Text("fuck")
        }
    }
    
    func body(content: Content) -> some View {
        if(edition == .Foil) {
            ZStack {
                content
                getImage(1)
            }
        }else if(edition == .Holographic){
            ZStack {
                content
                getImage(2)
            }
        }else if(edition == .Polychrome){
            ZStack {
                content
                getImage(3)
            }
        }else {
            content
        }
    }
}



struct ContentView: View {
    
    @Query private var seeds: [SeedModel]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView {
            Tab("Analyzer", systemImage: "sparkle.magnifyingglass") {
                AnalyzerView()
            }
            Tab("Finder", systemImage: "mail.and.text.magnifyingglass") {
                FinderView()
            }
            Tab("Saved", systemImage: "externaldrive") {
                SavedSeedsView()
            }.badge(seeds.count)
        }
    }
}

struct AnalyzerView : View {
    
    @State var seed = ""
    @State var run : Run?
    @State var maxAnte = 8
    @Environment(\.modelContext) private var modelContext
    
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
                
                Button(action: analyze) {
                    Image(systemName: "sparkle.magnifyingglass")
                }.buttonStyle(.borderedProminent)
                    .tint(.blue)
                Button(action:paste){
                    Image(systemName: "document.on.clipboard")
                }.buttonStyle(.borderedProminent)
                    .tint(.green)
                Button(action:copy){
                    Image(systemName: "document.on.document")
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                Button(action: {
                    modelContext.insert(SeedModel(timestamp: Date(), seed: seed))
                }){
                    Image(systemName: "square.and.arrow.down")
                }
                .buttonStyle(.borderedProminent)
                .tint(.gray)
                Button(action:random){
                    Image(systemName: "bolt")
                }.buttonStyle(.borderedProminent)
                    .tint(.yellow)
            }.padding(.horizontal)
            
            Stepper {
                Text("Max Ante: **\(maxAnte)**")
            } onIncrement: {
                maxAnte += 1
            } onDecrement: {
                maxAnte -= 1
                if maxAnte < 1 { maxAnte = 1 }
            }.padding()
                .background(.gray)
                .cornerRadius(8.0)
            
            if(run != nil){
                PlayView(run: run!)
            } else {
                Spacer()
            }
        }.background(Color(hex: "#1e1e1e"))
    }
    
    func random(){
        seed = Balatro.generateRandomString()
        analyze()
    }
    
    func copy(){
        UIPasteboard.general.string = seed
    }
    
    func paste(){
        if let clipboardText = UIPasteboard.general.string {
            seed = clipboardText
        }
    }
    
    func analyze(){
        if(seed.isEmpty){ return }
        
        run = Balatro()
            .performAnalysis(seed: seed, maxDepth: maxAnte, version: .v_101f)
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .modelContainer(for: SeedModel.self, inMemory: true)
    }
}

