//
//  ResumeView.swift
//  balatroseeds
//
//  Created by Alex on 27/01/25.
//

import SwiftUI

struct ResumeView: View {
    
    let run : Run
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        VStack {
            AnimatedTitle(text: "Summary of \(run.seed)")
            ScrollView {
                ScrollView(.horizontal){
                    HStack {
                        ForEach(run.vouchers(), id: \.rawValue){ voucher in
                            voucher.sprite()
                        }
                    }
                }
                ScrollView(.horizontal){
                    HStack {
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
    }

}

#Preview {
    ResumeView(run: Balatro()
        .performAnalysis(seed: "IGSPUNF"))
}
