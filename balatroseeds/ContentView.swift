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

