//
//  SaveSeedView.swift
//  balatroseeds
//
//  Created by Alex on 29/07/25.
//

import SwiftUI

struct SaveSeedView : View {
    
    @State var description : String = ""
    @State var level : JokerType = .COMMON
    let model : AnalyzerViewModel
    
    var body : some View {
        Form {
            Section {
                HStack {
                    UnCommonJoker.Certificate.sprite()
                    VStack(alignment: .leading) {
                        Text("Seed: \(model.seed)")
                            .font(.customTitle)
                            .foregroundStyle(.white)
                        Text("Score: \(model.run?.score ?? 0)")
                            .font(.customBody)
                            .foregroundStyle(.white)
                        Spacer()
                    }.padding(.vertical)
                }
                TextField("Description", text: $description)
                    .font(.customTitle)
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .background(.gray)
                    .cornerRadius(8)
                    .keyboardType(.alphabet)
                List {
                    Picker("Level", selection: $level) {
                        ForEach(JokerType.allCases, id: \.hashValue) { type in
                            Text(type.rawValue)
                                .foregroundStyle(.white)
                                .tag(type)
                        }
                    }.font(.customBody)
                        .foregroundStyle(.white)
                        .pickerStyle(.menu)
                        .tint(.red)
                }
            }.listRowBackground(Color.customBackground)
            
            Section {
                Button("Save seed") {
                    model.store(level: level, title: description)
                }.buttonStyle(.borderedProminent)
            }.listRowBackground(Color.customBackground)
        }.scrollContentBackground(.hidden)
        .background(Color.customBackground)
            
    }
}

#Preview {
    SaveSeedView(model : AnalyzerViewModel())
        .background(Color.customBackground)
}
