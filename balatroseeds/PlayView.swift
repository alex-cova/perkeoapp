//
//  PlayView.swift
//  balatroseeds
//
//  Created by Alex on 28/01/25.
//

import SwiftUI

struct PlayView : View {
    let run : Run
    
    var body: some View {
        VStack{
            NavigationLink(destination: ResumeView(run: run)){
                Label("Resume", systemImage: "arrow.right")
                    .foregroundStyle(.white)
            }
            ScrollView {
                render()
            }
        }.background(Color(hex: "#1e1e1e"))
    }
    
    @ViewBuilder
    func render() -> some View {
        ForEach(run.antes) { a in
            anteView(ante: a)
                .padding(.bottom)
        }
    }
    
    @ViewBuilder
    func anteView(ante: Ante) -> some View {
        VStack {
            if(ante.ante > 1){
                Capsule()
                    .frame(height: 2)
                    .foregroundStyle(.white)
                    .padding()
            }
            Text("Ante \(ante.ante)")
                .font(.title)
                .foregroundStyle(.white)
            options(ante: ante)
            Text("Shop queue")
                .foregroundStyle(.white)
            ScrollView(.horizontal) {
                shopView(ante: ante)
            }
            packsView(ante: ante)
        }
    }
    
    @ViewBuilder
    func options(ante: Ante) -> some View {
        HStack {
            VStack {
                ante.voucher.sprite()
                Text(ante.voucher.rawValue)
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            VStack {
                ante.boss.sprite()
                Text(ante.boss.rawValue)
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            ForEach(astList(set: ante.tags), id: \.self.rawValue) { tag in
                VStack {
                    tag.sprite()
                    Text(tag.rawValue)
                        .font(.caption)
                        .foregroundStyle(.white)
                }
            }
            Spacer()
        }.padding(.horizontal)
    }
    
    private func astList(set : Set<Tag>) -> [Tag] {
        var list : [Tag] = []
        list.append(contentsOf: set)
        return list
    }
    
    @ViewBuilder
    func packsView(ante : Ante) -> some View {
        ForEach(ante.packs) { pack in
            VStack {
                Text("\(pack.type.rawValue)")
                    .foregroundStyle(.white)
                Text("\(pack.choices) choices")
                    .font(.caption)
                    .foregroundStyle(.gray)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(pack.options) { option in
                            optionView(option: option, ante: ante)
                        }
                    }
                }
            }.padding(.top)
        }
    }
    
    @ViewBuilder
    func optionView(option: Option, ante : Ante) -> some View {
        VStack {
            if let legendary = option.legendary {
                option.item.sprite()
                    .edition(option.edition())
                
                Text(legendary.rawValue)
                    .font(.caption)
                    .foregroundStyle(.white)
            } else {
                option.item.sprite()
                    .edition(option.edition())
                Text(option.item.rawValue)
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundStyle(.white)
            }
        }
    }
    
    @ViewBuilder
    func shopView(ante : Ante) -> some View {
        HStack {
            ForEach(ante.shopQueue) { item in
                VStack {
                    item.item.sprite()
                        .edition(item.edition as? Edition ?? Edition.NoEdition)
                    Text(item.item.rawValue)
                        .foregroundStyle(.white)
                        .font(.caption)
                    if let edition = item.edition {
                        Text(edition.rawValue)
                            .foregroundStyle(.white)
                            .font(.caption)
                    } else {
                        Spacer()
                            .frame(height: 15)
                    }
                }
            }
        }
    }
}
