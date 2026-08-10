//
//  CommunitySeedView.swift
//  balatroseeds
//
//  Created by Alex on 15/03/25.
//

import SwiftUI

struct CommunitySeedView: View {
    let seed: String

    var body: some View {
        Text(seed)
            .font(.customBody)
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .padding(.horizontal, 8)
            .background(Color.customRowBackground)
            .clipShape(.rect(cornerRadius: CommunityDesign.cornerRadius))
            .accessibilityLabel("Seed \(seed)")
            .accessibilityHint("Opens seed analysis")
    }
}

#Preview {
    CommunitySeedView(seed: "PERKEO01")
        .padding()
        .background(Color.customBackground)
}
