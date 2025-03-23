//
//  Components.swift
//  balatroseeds
//
//  Created by Alex on 13/03/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    public func legendaryJokerImage(x: Int, y : Int) -> some View {
        let frame = CGRect(x: x * 71, y: y * 95, width: 71, height: 95)
        let frame2 = CGRect(x: x * 71, y: (y + 1 ) * 95, width: 71, height: 95)
        if let cgImage = Images.jokers.cgImage?.cropping(to: frame) {
            ZStack {
                Image(decorative: cgImage, scale: Images.jokers.scale, orientation: .up)
                    .resizable()
                    .frame(width: frame.width, height: frame.height)
                
                if let cgImage2 = Images.jokers.cgImage?.cropping(to: frame2) {
                    Image(decorative: cgImage2, scale: Images.jokers.scale, orientation: .up)
                        .resizable()
                        .frame(width: frame.width, height: frame.height)
                }
            }
        }else{
            Text("fuck")
        }
    }
    
    @ViewBuilder
    public func seedNavigation(_ seed: String) -> some View {
        ZStack {
            Color(hex: "#1e1e1e").ignoresSafeArea()
            PlayView()
                .clipped()
                .navigationTitle(seed)
        }
    }
}

struct PerkeoView : View {
    
    @State private var isAnimating = false
    private var animationDuration: Double = 1.5
    private var bounceHeight: CGFloat = 20.0
    
    var body: some View {
        legendaryJokerImage(x: 7, y: 8)
            .padding()
            .rotationEffect( isAnimating ? .degrees(2) : .degrees(-2))
                .onAppear {
                    // Start the animation when the view appears
                    isAnimating = true
                }
            .animation(
                Animation.easeInOut(duration: animationDuration)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
    }
}


struct TribouleteView : View {
    
    @State private var isAnimating = false
    private var animationDuration: Double = 1.5
    private var bounceHeight: CGFloat = 20.0
    
    var body: some View {
        Image("triboulete")
            .padding()
            .rotationEffect( isAnimating ? .degrees(2) : .degrees(-2))
                .onAppear {
                    // Start the animation when the view appears
                    isAnimating = true
                }
            .animation(
                Animation.easeInOut(duration: animationDuration)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
    }
}

struct AnimatedTitle : View {
    
    private let text : String
    @State private var isAnimating = false
    private var animationDuration: Double = 1.5
    private var bounceHeight: CGFloat = 20.0
    
    public init(text: String){
        self.text = text
    }
    
    
    var body: some View {
        Text(text)
            .font(.customTitle)
            .foregroundStyle(.white)
            .scaleEffect(.random(in:  1.2...1.4 ))
            .rotationEffect( isAnimating ? .degrees(2) : .degrees(-2))
                .onAppear {
                    // Start the animation when the view appears
                    isAnimating = true
                }
            .animation(
                Animation.easeInOut(duration: animationDuration)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
    }
}
