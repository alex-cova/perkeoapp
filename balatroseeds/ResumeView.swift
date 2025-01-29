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
            Text("Resume of **\(run.seed)**")
                .font(.title2)
                .foregroundStyle(.white)
            ScrollView(.horizontal){
                HStack {
                    ForEach(run.tags(), id: \.rawValue) { tag in
                        tag.sprite()
                    }
                }
            }.padding(.vertical)
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(run.jokers()) { joker in
                        itemView(joker.joker, count: joker.count)
                    }
                }
            }
        }.background(Color(hex: "#1e1e1e"))
    }
    
    private func itemView(_ item : Item, count : Int) -> some View {
        VStack {
            item.sprite()
            if item is LegendaryJoker {
                Text(item.rawValue)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(.bottom)
            }else{
                Text("\(item.rawValue) x \(count)")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(.bottom)
            }
        }
    }
}

#Preview {
    ResumeView(run: Balatro().performAnalysis(seed: "2K9H9HN", maxDepth: 2, version: .v_100n))
}
