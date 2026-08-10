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
            LegendaryView(joker: .Canio)
            Text("Enter Seed")
                .font(.customTitle)
                .foregroundStyle(.white)
            TextField("Seed", text: $model.seed)
                .frame(width: 200)
                .font(.customTitle)
                .multilineTextAlignment(.center)
                .padding(5)
                .background(.gray)
                .clipShape(.rect(cornerRadius: 8))
                .keyboardType(.alphabet)
                .onSubmit {
                    model.analyze()
                }
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
