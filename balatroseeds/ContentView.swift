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
    static let enhancers = UIImage(named: "Enhancers")!
    static let sprite = SpriteSheet()
}

struct ContentView: View {
    
    @Query private var seeds: [SeedModel]
    @State private var activeTab: TabItem = .analyzer

    init(){
        LookAndFeel.configure()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $activeTab) {
                Tab.init(value: .analyzer) {
                    AnalyzerView()
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                Tab.init(value: .finder) {
                    FinderView()
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                Tab.init(value: .community){
                    CommunityView()
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                Tab.init(value: .saved) {
                    SavedSeedsView()
                        .toolbarVisibility(.hidden, for: .tabBar)
                }.badge(seeds.count)
            }.tint(.red)
                .font(.customBody)
            InteractiveTabBar(activeTab: $activeTab)
        }
        
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SeedModel.self, inMemory: true)
}
