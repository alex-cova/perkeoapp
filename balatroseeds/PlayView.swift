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
        VStack(alignment: .leading) {
            if(ante.ante > 1){
                Capsule()
                    .frame(height: 2)
                    .foregroundStyle(.white)
                    .padding()
            }
            Text("Ante \(ante.ante)")
                .underline()
                .font(.title)
                .foregroundStyle(.white)
            options(ante: ante)
            Text("Shop queue")
                .underline()
                .foregroundStyle(.white)
                .padding(.top)
            ScrollView(.horizontal) {
                shopView(ante: ante)
            }
            packsView(ante: ante)
        }.padding(.horizontal)
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
            .padding(.horizontal)
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        ante.boss.sprite()
                        Text(ante.boss.rawValue)
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                }
                HStack {
                    ForEach(astList(set: ante.tags), id: \.self.rawValue) { tag in
                        VStack {
                            tag.sprite()
                            Text(String(tag.rawValue.dropLast(4)))
                                .font(.caption)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            if ante.ante == 1 {
                Spacer()
                NavigationLink(destination: ResumeView(run: run)){
                    VStack {
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.white)
                        Text("Resume")
                            .font(.caption)
                    }
                }.buttonStyle(.borderedProminent)
            }
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
                    .underline()
                Text(choiceText(pack.choices))
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
    
    private func choiceText(_ options : Int) -> String {
        if options == 1 {
            return "Choose 1"
        }
        
        return "\(options) choices"
    }
    
    @ViewBuilder
    private func optionView(option: Option, ante : Ante) -> some View {
        VStack {
            if let legendary = option.legendary {
                legendary.sprite(edition: option.edition())                
                Text(legendary.rawValue)
                    .font(.caption)
                    .foregroundStyle(.white)
            } else {
                option.item.sprite(edition: option.edition())
                
                Text(option.item.rawValue)
                    .lineLimit(2)
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

struct EditionView: ViewModifier {
    var edition: Edition
    
    @ViewBuilder
    private func getImage(_ index: Int) -> some View {
        let frame = CGRect(x: index * 71, y: 0, width: 71, height: 95)
        if let cgImage = Images.editions.cgImage?.cropping(to: frame) {
            Image(decorative: cgImage, scale: Images.editions.scale, orientation: .up)
                .resizable()
                .frame(width: frame.width, height: frame.height)
        }else{
            Text("fuck")
        }
    }
    
    func body(content: Content) -> some View {
        if(edition == .Foil) {
            ZStack {
                content
                getImage(1)
            }
        }else if(edition == .Holographic){
            ZStack {
                content
                getImage(2)
            }
        }else if(edition == .Polychrome){
            ZStack {
                content
                getImage(3)
            }
        }else if(edition == .Negative){
            content.colorInvert()
        }else {
            content
        }
    }
}

#Preview {
    NavigationStack {
        PlayView(run: Balatro()
            .performAnalysis(seed: "TSJQOW5", maxDepth: 2, version: .v_101f))
    }
}
