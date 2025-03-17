//
//  PlayView.swift
//  balatroseeds
//
//  Created by Alex on 28/01/25.
//

import SwiftUI

struct PlayView : View {
    let run : Run
    
    init(run: Run){
        self.run = run
    }
    
    var body: some View {
        ScrollView {
            ForEach(run.antes) { a in
                anteView(ante: a)
                    .padding(.bottom)
            }
        }.background(Color(hex: "#1e1e1e"))
    }
    
    @ViewBuilder
    func anteView(ante: Ante) -> some View {
        VStack(alignment: .leading) {
            Text("Ante \(ante.ante)")
                .bold()
                .font(.customTitle)
                .foregroundStyle(.white)
            separator()
            options(ante: ante)
            Text("Shop queue")
                .font(.customBody)
                .foregroundStyle(.white)
                .padding(.top)
            separator()
            ScrollView(.horizontal) {
                shopView(ante: ante)
            }
            packsView(ante: ante)
        }.padding(.horizontal)
    }
    
    @ViewBuilder
    func separator() -> some View {
        Rectangle()
            .foregroundStyle(Color(hex: "#2d2d2d"))
            .frame(height: 1)
            .padding(.bottom)
    }
    
    @ViewBuilder
    func options(ante: Ante) -> some View {
        HStack {
            ante.voucher.sprite()
                .padding(.horizontal)
            VStack(alignment: .leading) {
                if ante.ante == 1 {
                    HStack {
                        Spacer()
                        NavigationLink(destination: ResumeView(run: run)){
                            HStack {
                                Image(systemName: "checklist")
                                    .foregroundStyle(.white)
                                Text("Summary")
                                    .bold()
                                    .font(.customCaption)
                            }
                        }.buttonStyle(.borderedProminent)
                        Button(action: {
                            UIPasteboard.general.string = run.seed
                        }, label: {
                            HStack {
                                Image(systemName: "document.on.document")
                                    .foregroundStyle(.white)
                                Text("Copy")
                                    .bold()
                                    .font(.customCaption)
                            }
                        }).buttonStyle(.borderedProminent)
                            .tint(.green)
                        Spacer()
                    }.padding(.bottom)
                }
                HStack {
                    ante.boss.sprite()
                    ForEach(astList(set: ante.tags), id: \.self.rawValue) { tag in
                        VStack {
                            tag.sprite()
                        }
                    }
                }
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
                    .font(.customBody)
                    .foregroundStyle(.white)
                Text(choiceText(pack.choices))
                    .font(.customCaption)
                    .foregroundStyle(.white)
                separator()
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
    private func optionView(option: EditionItem, ante : Ante) -> some View {
        option.item.sprite(edition: option.edition)
    }
    
    @ViewBuilder
    func shopView(ante : Ante) -> some View {
        HStack {
            ForEach(ante.shopQueue) { item in
                VStack {
                    item.item.sprite(edition: item.edition ?? .NoEdition)
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
            .performAnalysis(seed: "IGSPUNF"))
    }
}
