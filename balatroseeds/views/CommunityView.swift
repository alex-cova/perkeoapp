//
//  CommunityView.swift
//  balatroseeds
//
//  Created by Alex on 15/03/25.
//

import SwiftUI

struct CommunityView: View {
    
    @EnvironmentObject var model : AnalyzerViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var isAnimating = false
    private var animationDuration: Double = 1.5
    private var bounceHeight: CGFloat = 20.0
    @State var seeds : [String] = generateSeeds()
    
    var body: some View {
        ZStack {
            Color(hex: "1e1e1e").ignoresSafeArea()
            VStack {
                AnimatedTitle(text: "Community Seeds")
                    
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(seeds, id: \.self) { seed in
                            NavigationLink(destination: PlayView()
                                .navigationTitle(seed)
                                .onAppear {
                                    model.changeSeed(seed)
                                }) {
                                    CommunitySeedView(seed: seed)
                                }
                        }
                    }.scenePadding()
                        .background(Color(hex: "1e1e1e"))
                    Text("Thanks to LocalThunk for the amazing game, to the people at Balatro discord server, to math, tacodiva, saul and other friends of the community for their help and support! ")
                        .font(.customCaption)
                        .foregroundStyle(.white)
                        .padding()
                }.background(Color(hex: "1e1e1e"))
                .clipped()
                    .refreshable {
                        seeds = CommunityView.generateSeeds()
                    }
            }
        }.background(Color(hex: "1e1e1e"))
    }
    
    private static func generateSeeds() -> [String] {
        var seeds = [String]()
        
        for _ in 0..<80 {
            seeds.append(Balatro.generateRandomString())
        }
        
        return seeds
    }
}



struct CommunitySeedView : View {
    let seed : String
        
    var body : some View {
        VStack(spacing: 5.0) {
            Text(seed)
                .font(.customBody)
                .foregroundStyle(.white)
        }.frame(width: 120, height: 100)
            .border(Color.black, width: 5)
            .cornerRadius(8.0)
    }
    
    

}

#Preview {
    TabView {
        CommunityView()
    }
}
