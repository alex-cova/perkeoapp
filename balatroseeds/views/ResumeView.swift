//
//  ResumeView.swift
//  balatroseeds
//
//  Created by Alex on 27/01/25.
//

import SwiftUI

struct ResumeView: View {
    
    let run : Run
    @State private var scrollView: UIScrollView?
    @State private var initialAnimation: Bool = false
    @State private var timer = Timer.publish(every: 0.01, on: .current, in: .default).autoconnect()
    @State private var titleProgress: CGFloat = 0
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        VStack {
            AnimatedTitle(text: "Summary of \(run.seed)")
            ScrollView {
                InfiniteScrollView(collection: run.vouchers()) { card in
                    card.sprite()
                        .foregroundStyle(.white)
                        .font(.title)
                        .clipShape(.rect(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.4), radius: 10, x: 1, y: 0)
                        .scrollTransition(.interactive.threshold(.centered), axis: .horizontal) { content, phase in
                            content
                                .offset(y: phase == .identity ? -10 : 0)
                                .rotationEffect(.degrees(phase.value * 5), anchor: .bottom)
                        }
                } uiScrollView: {
                    scrollView = $0
                } onScroll: {
                    //updateActiveCard()
                }
                .scrollIndicators(.hidden)
                .scrollClipDisabled()
                .containerRelativeFrame(.vertical) { value, _ in
                    value * 0.15
                }.padding(.top)
                .visualEffect { [initialAnimation] content, proxy in
                    content
                        .offset(y: !initialAnimation ? -(proxy.size.height + 200) : 0)
                }
                
                ScrollView(.horizontal){
                    HStack(spacing: 20) {
                        ForEach(run.tags(), id: \.rawValue) { tag in
                            tag.sprite()
                        }
                    }
                }.padding(.vertical)
                LazyVGrid(columns: columns) {
                    ForEach(run.jokers()) { joker in
                        joker.joker.sprite(edition: joker.edition)
                            .badge(Text("joker.count"))
                    }

                    ForEach(run.spectrals(), id: \.rawValue) { spectral in
                        spectral.sprite()
                            .foregroundStyle(.white)
                    }
                }
            }
        }.background(Color(hex: "#1e1e1e"))
            .onReceive(timer) { _ in
                if let scrollView = scrollView {
                    scrollView.contentOffset.x += 0.35
                }
            }
            .task {
                try? await Task.sleep(for: .seconds(0.35))
                
                withAnimation(.smooth(duration: 0.75, extraBounce: 0)) {
                    initialAnimation = true
                }
                
                withAnimation(.smooth(duration: 2.5, extraBounce: 0).delay(0.3)) {
                    titleProgress = 1
                }
            }
        
    }

}

#Preview {
    ResumeView(run: Balatro()
        .performAnalysis(seed: "IGSPUNF"))
}
