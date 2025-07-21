//
//  SeedInput.swift
//  balatroseeds
//
//  Created by Alex on 14/07/25.
//

import SwiftUI

struct SeedInput : View {
    
    @EnvironmentObject var model : AnalyzerViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            PerkeoView()
            TextField("Seed", text: $model.seed, onCommit: {
                model.analyze()
            })
            .frame(width: 200)
            .font(.customTitle)
            .multilineTextAlignment(.center)
            .padding(5)
            .background(.gray)
            .cornerRadius(8)
            .keyboardType(.alphabet)
            Button(action: {
                model.analyze()
            }) {
                Label("Accept", systemImage: "checkmark")
                    .font(.customBody)
            }.buttonStyle(.borderedProminent)
                .tint(.red)
                
        }.background(Color.customBackground)
    }
}

#Preview {
    SeedInput()
        .environmentObject(AnalyzerViewModel())
}
