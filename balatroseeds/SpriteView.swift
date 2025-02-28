//
//  SpriteView.swift
//  balatroseeds
//
//  Created by Alex on 27/01/25.
//

import SwiftUI

struct SpriteImageView: View {
    let spriteSheet: UIImage
    let frame: CGRect
    let card : Bool
    let edition: Edition?
    let item : Item
    
    init(_ item : Item, _ sprite : UIImage, _ x : Int,_ y : Int,_ w : Int, _ h : Int, _ card : Bool = false, edition : Edition? = nil){
        self.item = SpriteImageView.unwrap(item)
        self.spriteSheet = sprite
        self.frame = CGRect(x: x * w, y: y * h, width: w, height: h)
        self.card = card
        self.edition = edition
    }
    
    private static func unwrap(_ item : Item) -> Item {
        if let ei = item as? EditionItem {
            return ei.item
        }
        
        return item
    }
    
    private func getLegendaryFrame() -> CGRect {
        CGRect(x: frame.minX * 71, y: (frame.maxY + 1 ) * 95, width: 71, height: 95)
    }
    
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
    
    @ViewBuilder
    private func editionView() -> some View {
        if(edition == .Foil) {
            getImage(1)
        }else if(edition == .Holographic){
            getImage(2)
        }else if(edition == .Polychrome){
            getImage(3)
        }else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func getImage(x: Int, y : Int) -> some View {
        let frame = CGRect(x: x * 71, y: y * 95, width: 71, height: 95)
        let frame2 = CGRect(x: x * 71, y: (y + 1 ) * 95, width: 71, height: 95)
        if let cgImage = Images.jokers.cgImage?.cropping(to: frame) {
            ZStack {
                Image(decorative: cgImage, scale: Images.jokers.scale, orientation: .up)
                    .resizable()
                    .frame(width: frame.width, height: frame.height)
                
                if let cgImage2 = Images.jokers.cgImage?.cropping(to: frame2) {
                    Image(decorative: cgImage2, scale: Images.jokers.scale, orientation: .up)
                        .resizable()
                        .frame(width: frame.width, height: frame.height)
                }
            }
        }else{
            Text("fuck")
        }
    }
    
    @ViewBuilder
    private func getHologram() -> some View {
        let frame2 = CGRect(x: 2 * 71, y: 9 * 95, width: 71, height: 95)
        if let cgImage = Images.jokers.cgImage?.cropping(to: frame) {
            ZStack {
                Image(decorative: cgImage, scale: Images.jokers.scale, orientation: .up)
                    .resizable()
                    .frame(width: frame.width, height: frame.height)
                
                if let cgImage2 = Images.jokers.cgImage?.cropping(to: frame2) {
                    Image(decorative: cgImage2, scale: Images.jokers.scale, orientation: .up)
                        .resizable()
                        .frame(width: frame.width, height: frame.height)
                }
            }
        }else{
            Text("fuck")
        }
    }
    
    @ViewBuilder
    private func legendaryView() -> some View {
        if let legendary = item as? LegendaryJoker {
            if(legendary == .Perkeo){
                getImage(x : 7, y : 8)
            } else if(legendary == .Canio){
                getImage(x : 3, y : 8)
            } else if (legendary == .Triboulet) {
                getImage(x : 4, y : 8)
            } else if(legendary == .Yorick){
                getImage(x : 5, y : 8)
            } else if(legendary == .Chicot) {
                getImage(x : 6, y : 8)
            } else {
                EmptyView()
            }
        } else {
            EmptyView()
        }
    }
   
    var body: some View {
        VStack {
            if item.rawValue == "Hologram" {
                ZStack {
                    if edition == .Negative {
                        getHologram()
                            .colorInvert()
                    }else {
                        getHologram()
                    }
                    editionView()
                }
            } else if item is LegendaryJoker {
                if edition == .Negative {
                    legendaryView()
                        .colorInvert()
                }else {
                    ZStack {
                        legendaryView()
                        if edition != nil {
                            editionView()
                        }
                    }
                }
            } else {
                if let cgImage = spriteSheet.cgImage?.cropping(to: frame) {
                    if edition == .Negative {
                        Image(decorative: cgImage, scale: spriteSheet.scale, orientation: .up)
                            .resizable()
                            .frame(width: frame.width, height: frame.height)
                            .background(card ? .white : .clear)
                            .cornerRadius(card ? 8 : 0)
                            .colorInvert()
                    }else {
                        ZStack {
                            Image(decorative: cgImage, scale: spriteSheet.scale, orientation: .up)
                                .resizable()
                                .frame(width: frame.width, height: frame.height)
                                .background(card ? .white : .clear)
                                .cornerRadius(card ? 8 : 0)
                            
                            if edition != nil {
                                editionView()
                            }
                        }
                    }
                }
            }
            Text("**\(item.rawValue)** \(editionText())")
                .font(.caption)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 71, minHeight: 35)
                .foregroundStyle(.white)
        }
    }
    
    private func editionText() -> String {
        guard let e = edition else {
            return ""
        }
        
        
        if e == .NoEdition {
            
            return ""
        }
        
        return e.rawValue
    }
    
    private func edition(_ edition: Edition) -> some View {
        self.modifier(EditionView(edition: edition))
    }
}

#Preview {
    VStack {
        HStack {
            LegendaryJoker.Perkeo.sprite(edition: .Negative)
            LegendaryJoker.Triboulet.sprite(edition: .Holographic)
            Specials.THE_SOUL.sprite()
            RareJoker.Blueprint.sprite()
            Tarot.Death.sprite()
            
        }
        HStack {
            Spectral.Cryptid.sprite()
            UnCommonJoker.Arrowhead.sprite(edition: .NoEdition)
            CommonJoker.Ball.sprite()
            Planet.Earth.sprite()
            Specials.BLACKHOLE.sprite()
        }
        HStack {
            RareJoker.Hit_the_Road.sprite()
            UnCommonJoker.Hologram.sprite()
            Tarot.The_High_Priestess.sprite()
            Tarot.The_Wheel_of_Fortune.sprite()
            CommonJoker.Chaos_the_Clown.sprite()
        }
        HStack {
            UnCommonJoker.Ceremonial_Dagger.sprite()
            CommonJoker100.Ball.sprite()
            RareJoker.Baseball_Card.sprite()
            CommonJoker.Delayed_Gratification.sprite()
            EditionItem(edition: .Negative, LegendaryJoker.Perkeo).sprite(edition: .Negative)
        }
    }.background(Color(hex: "#1e1e1e"))
}
