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
    static let boosters = UIImage(named: "boosters")!
    static let chips = UIImage(named: "chips")!
    static let sprite = SpriteSheet()
}

struct ContentView: View {
    @EnvironmentObject var model : AnalyzerViewModel
    @Query private var seeds: [SeedModel]
    
    init(){
        LookAndFeel.configure()
    }
    
    var body: some View {
        if #available(iOS 18, *) {
            tabView()
                .navigationTitle(model.activeTab == .analyzer ? model.title: "")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    if model.showOptions {
                        toolbar()
                    }
                }
                .sheet(isPresented: $model.showInput) {
                    SeedInput()
                        .presentationDetents([.medium])
                        .presentationBackground(Color.customBackground)
                    
                }
        }else {
            tabView17()
                .navigationTitle(model.activeTab == .analyzer ? model.title : "")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    if model.showOptions {
                        toolbar()
                    }
                }.sheet(isPresented: $model.showInput) {
                    SeedInput()
                        .presentationDetents([.medium])
                        .presentationBackground(Color.customBackground)
                }
        }
    }
    
    @ViewBuilder
    func tabView17() -> some View {
        TabView(selection: $model.activeTab) {
            AnalyzerView()
                .tag(TabItem.analyzer)
                .tabItem {
                    Label(TabItem.analyzer.rawValue, systemImage: TabItem.analyzer.symbolImage)
                }
            SavedSeedsView()
                .tag(TabItem.saved)
                .tabItem {
                    Label(TabItem.saved.rawValue, systemImage: TabItem.saved.symbolImage)
                }
            FinderView()
                .tag(TabItem.finder)
                .tabItem {
                    Label(TabItem.finder.rawValue, systemImage: TabItem.finder.symbolImage)
                }
            CommunityView()
                .tag(TabItem.community)
                .tabItem {
                    Label(TabItem.community.rawValue, systemImage: TabItem.community.symbolImage)
                }
        }.toastView(toast: $model.toast)
            .sheet(isPresented: $model.configSheet) {
                ConfigView()
                    .presentationDetents([.medium, .large])
                    .onDisappear {
                        model.analyze()
                    }
            }.sheet(isPresented: $model.showSummary) {
                ResumeView(run: model.run!)
            }
    }
    
    @ViewBuilder
    func toolbar() -> some View {
        Menu(content:  {
            Button(action: model.random) {
                Label("Random seed", systemImage: "sparkles")
            }
            Button(action: model.paste) {
                Label("Paste seed", systemImage: "clipboard")
            }
            Button(action: model.copy){
                Label("Copy seed", systemImage: "doc.on.clipboard")
            }
            Button(action: model.enterSeed) {
                Label("Enter a seed", systemImage: "square.and.pencil")
            }
        }, label : {
            Image(systemName: "option")
                .tint(.red)
        })
        
        if model.run != nil {
            Button(action: {
                model.showSummary.toggle()
            }) {
                Image(systemName:"checklist")
            }.tint(.red)
        }
        
        Button(action: {
            model.configSheet.toggle()
        }) {
            Image(systemName:"gear")
        }.tint(.red)
    }
    
    
    @available(iOS 18, *)
    func tabView() -> some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $model.activeTab) {
                Tab.init(value: .analyzer) {
                    AnalyzerView()
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                Tab.init(value: .saved) {
                    SavedSeedsView()
                        .toolbarVisibility(.hidden, for: .tabBar)
                }.badge(seeds.count)
                Tab.init(value: .finder) {
                    FinderView()
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                Tab.init(value: .community){
                    CommunityView()
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
            }.tint(.red)
                .font(.customBody)
                .padding(.bottom, model.activeTab == .analyzer ? 0  : 60)
            InteractiveTabBar(activeTab: $model.activeTab)
        }.toastView(toast: $model.toast)
            .sheet(isPresented: $model.configSheet) {
                ConfigView()
                    .presentationDetents([.medium, .large])
                    .onDisappear {
                        model.analyze()
                    }
            }.sheet(isPresented: $model.showSummary) {
                ResumeView(run: model.run!)
            }.sheet(isPresented: $model.showSaveView) {
                SaveSeedView(model: model)
                    .presentationDetents([.medium])
                    .presentationBackground(Color.customBackground)
            }
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .environment(AnalyzerViewModel(memoryOnly: true))
    }
}
