//
//  Untitled.swift
//  balatroseeds
//
//  Created by Alex on 23/02/25.
//
import SwiftUI
import Combine
import SwiftData



struct AnalyzerView : View {
    @EnvironmentObject var model : AnalyzerViewModel
    
    var body: some View {
        mainView()
    }
    
    @ViewBuilder
    private func mainView() -> some View {
        VStack{
            HStack {
                TextField("Seed", text: $model.seed, onCommit: {
                    model.analyze()
                })
                .font(.customTitle)
                .multilineTextAlignment(.center)
                .padding(5)
                .background(.gray)
                .cornerRadius(8)
                .keyboardType(.alphabet)
                
                Button(action: {
                    model.analyze()
                }) {
                    Image(systemName: "sparkle.magnifyingglass")
                }.buttonStyle(.borderedProminent)
                    .tint(.blue)
                Button(action:model.random){
                    Image(systemName: "bolt")
                }.buttonStyle(.borderedProminent)
                    .tint(.yellow)
                Button(action:model.paste){
                    Image(systemName: "clipboard")
                }.buttonStyle(.borderedProminent)
                .tint(.green)
            }.padding(.horizontal)
            
            if(model.run != nil){
                PlayView()
                    .clipped()
            } else {
                Spacer()
                PerkeoView()
                VStack(alignment: .leading, spacing: 10.0) {
                    Label("Analyze seed", systemImage: "sparkle.magnifyingglass")
                        .font(.customBody)
                    Label("Generate a random seed", systemImage: "bolt")
                        .font(.customBody)
                    Label("Paste seed", systemImage: "clipboard")
                        .font(.customBody)
                }.foregroundStyle(.white)
                Spacer()
            }
        }.background(Color(hex: "#1e1e1e"))
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()),
                   GridItem(.flexible()),GridItem(.flexible())]
    

}

#Preview {
    NavigationStack {
        ContentView()
            .environment(AnalyzerViewModel())
    }
}

