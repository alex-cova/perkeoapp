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
    @EnvironmentObject var model : AnalyzerViewModel
    @Query private var seeds: [SeedModel]

    init(){
        LookAndFeel.configure()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $model.activeTab) {
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
            InteractiveTabBar(activeTab: $model.activeTab)
        }.toastView(toast: $model.toast)
            .sheet(isPresented: $model.configSheet) {
                ConfigView()
                    .presentationDetents([.medium, .large])
                    .onDisappear {
                        model.analyze()
                    }
            }
        
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SeedModel.self, inMemory: true)
}
