//
//  LoaderView.swift
//  balatroseeds
//
//  Created by Alex on 12/03/25.
//

import SwiftUI

struct LoadingView<Content>: View where Content: View {
    @Binding var isShowing: Bool
    var content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Your existing content
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                
                // Loading overlay
                if isShowing {
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 20) {
                            CircleLoader()
                                .frame(width: 80, height: 80)
                            
                            Text("Processing...")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .padding(30)
                    }
                    .transition(.opacity)
                }
            }
        }
    }
}

struct CircleLoader: View {
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(Color.white, lineWidth: 5)
            .frame(width: 60, height: 60)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .animation(
                Animation.linear(duration: 1)
                    .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                self.isAnimating = true
            }
    }
}
