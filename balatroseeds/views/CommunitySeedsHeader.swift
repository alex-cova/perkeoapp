//
//  CommunitySeedsHeader.swift
//  balatroseeds
//
//  Created by Alex on 09/08/26.
//

import SwiftUI

struct CommunitySeedsHeader: View {
    var body: some View {
        VStack(spacing: 8) {
            AnimatedTitle(text: "Community Seeds")

            Text("Pull to shuffle a fresh batch of random seeds.")
                .font(.customCaption)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    CommunitySeedsHeader()
        .padding()
        .background(Color.customBackground)
}
