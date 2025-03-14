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
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().backgroundColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
        UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
        UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        UITableView.appearance().separatorColor = UIColor.systemRed
        
    }
    
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
        }.tint(.red)
        
    }
}

