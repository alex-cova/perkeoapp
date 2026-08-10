//
//  CommunityCreditsFooter.swift
//  balatroseeds
//
//  Created by Alex on 09/08/26.
//

import SwiftUI

struct CommunityCreditsFooter: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Credits")
                .font(.customBody)
                .foregroundStyle(.red)

            Text("Thanks to LocalThunk for Balatro, the Balatro Discord, and friends of the community: math, tacodiva, pifreak, saul, and others who helped along the way.")
                .font(.customCaption)
                .foregroundStyle(.white.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    CommunityCreditsFooter()
        .padding()
        .background(Color.customBackground)
}
