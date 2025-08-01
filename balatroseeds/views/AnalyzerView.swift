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
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()),
                   GridItem(.flexible()),GridItem(.flexible())]
    
    var body: some View {
        mainView()
    }
    
    @ViewBuilder
    private func mainView() -> some View {
        VStack{
            if(model.run != nil){
                PlayView()
                    .clipped()
            } else {
                Spacer()
                    .frame(maxWidth: .infinity)
                LegendaryView(joker: .Perkeo)
                
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("On the top right corner you will find the following options:")
                        .font(.customCaption)
                    Label("Seed Options (Copy, Paste, Random)", systemImage: "option")
                        .font(.customBody)
                    Label("Run Settings", systemImage: "gear")
                        .font(.customBody)
                    Label("Seed summary", systemImage: "checklist")
                        .font(.customBody)
                }.foregroundStyle(.white)
                Button(action: {
                    model.showInput.toggle()
                }) {
                    Text("Enter a seed")
                        .font(.customBody)
                }.buttonStyle(.borderedProminent)
                    .padding(.vertical)
                    .tint(.red)
                Spacer()
                    .frame(maxWidth: .infinity)
            }
        }.background(Color.customBackground)
    }

}

#Preview {
    NavigationView {
        ContentView()
            .environment(AnalyzerViewModel())
    }
}

