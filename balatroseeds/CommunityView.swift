//
//  CommunityView.swift
//  balatroseeds
//
//  Created by Alex on 15/03/25.
//

import SwiftUI

struct CommunityView: View {
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var isAnimating = false
    private var animationDuration: Double = 1.5
    private var bounceHeight: CGFloat = 20.0
    
    var body: some View {
        ZStack {
            Color(hex: "1e1e1e").ignoresSafeArea()
            VStack {
                AnimatedTitle(text: "Community Seeds")
                    
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(0..<20) { _ in
                            CommunitySeedView()
                        }
                    }.scenePadding()
                }.clipped()
            }
        }
    }
}

struct CommunitySeedView : View {
    var body : some View {
        VStack(spacing: 5.0) {
            Text(Balatro.generateRandomString())
                .font(.customBody)
                .foregroundStyle(.white)
            Text("score: 1.0")
                .font(.customCaption)
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
