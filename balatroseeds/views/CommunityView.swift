//
//  CommunityView.swift
//  balatroseeds
//
//  Created by Alex on 15/03/25.
//

import SwiftUI

struct CommunityView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var seeds: [CommunitySeed] = CommunitySeed.generateBatch()
    @State private var appeared = false
    @State private var refreshTick = 0

    private let columns = [
        GridItem(.adaptive(minimum: CommunityDesign.gridMinimum), spacing: CommunityDesign.gridSpacing)
    ]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                CommunitySeedsHeader()

                LazyVGrid(columns: columns, spacing: CommunityDesign.gridSpacing) {
                    ForEach(Array(seeds.enumerated()), id: \.element.id) { index, seed in
                        NavigationLink(value: seed.value) {
                            CommunitySeedView(seed: seed.value)
                        }
                        .buttonStyle(.plain)
                        .opacity(tileOpacity)
                        .offset(y: tileOffset)
                        .animation(tileAnimation(for: index), value: appeared)
                        .scrollTransition { content, phase in
                            content
                                .opacity(scrollOpacity(phase))
                                .scaleEffect(scrollScale(phase))
                        }
                    }
                }

                CommunityCreditsFooter()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color.customBackground)
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            refreshSeeds()
        }
        .sensoryFeedback(.impact(flexibility: .soft), trigger: refreshTick)
        .task {
            appeared = true
        }
        .navigationDestination(for: String.self) { seed in
            CommunitySeedDestination(seed: seed)
        }
    }

    private var tileOpacity: Double {
        if reduceMotion { return 1 }
        return appeared ? 1 : 0
    }

    private var tileOffset: Double {
        if reduceMotion { return 0 }
        return appeared ? 0 : 16
    }

    private func refreshSeeds() {
        seeds = CommunitySeed.generateBatch()
        appeared = false
        refreshTick += 1

        if reduceMotion {
            appeared = true
        } else {
            withAnimation(.spring(duration: 0.5, bounce: 0.25)) {
                appeared = true
            }
        }
    }

    private func tileAnimation(for index: Int) -> Animation? {
        if reduceMotion { return nil }
        return .spring(duration: 0.55, bounce: 0.28)
            .delay(Double(min(index, 11)) * 0.03)
    }

    private func scrollOpacity(_ phase: ScrollTransitionPhase) -> Double {
        if reduceMotion || phase.isIdentity { return 1 }
        return 0.45
    }

    private func scrollScale(_ phase: ScrollTransitionPhase) -> Double {
        if reduceMotion || phase.isIdentity { return 1 }
        return 0.94
    }
}

#Preview {
    NavigationStack {
        CommunityView()
            .environmentObject(AnalyzerViewModel(memoryOnly: true))
    }
}
