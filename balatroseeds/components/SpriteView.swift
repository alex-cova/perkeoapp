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
    let card : Card?
    let edition: Edition?
    let item : Item
    let foregroundColor : Color
    let animated: Bool
    
    init(_ item : Item, _ sprite : UIImage, _ x : Int,_ y : Int,_ w : Int, _ h : Int, _ card : Card? = nil, edition : Edition? = nil,_ foregroundColor : Color = .white, animated: Bool = true){
        self.item = SpriteImageView.unwrap(item)
        self.spriteSheet = sprite
        self.frame = CGRect(x: x * w, y: y * h, width: w, height: h)
        self.card = card
        self.edition = edition
        self.foregroundColor = foregroundColor
        self.animated = animated
    }
    
    private static func unwrap(_ item : Item) -> Item {
        if let ei = item as? EditionItem {
            return ei.item
        }
        
        return item
    }
    
    @ViewBuilder
    private func getImage(_ index: Int) -> some View {
        let frame = CGRect(x: index * 71, y: 0, width: 71, height: 95)
        if let cgImage = Images.editions.cgImage?.cropping(to: frame) {
            Image(decorative: cgImage, scale: Images.editions.scale, orientation: .up)
                .resizable()
                .frame(width: frame.width, height: frame.height)
                .opacity(isAnimating ? 0.3 : 1.0)
        }else{
            Color.clear
                .frame(width: frame.width, height: frame.height)
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
                        .scaleEffect( isAnimating ? 0.95 : 1.06)
                        .rotationEffect( isAnimating ? .degrees(4) : .degrees(-6))
                }
            }
        }else{
            Color.clear
                .frame(width: frame.width, height: frame.height)
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
                        .rotationEffect( isAnimating ? .degrees(-5) : .degrees(5))
                }
            }
        }else{
            Color.clear
                .frame(width: frame.width, height: frame.height)
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
    
    @State private var isAnimating = false
    var animationDuration: Double = 1.5
    var bounceHeight: CGFloat = 20.0
    
    var body: some View {
        VStack {
            if item.rawValue == "Hologram" {
                ZStack {
                    if edition == .Negative {
                        getHologram()
                            .colorInvert()
                    }else {
                        getHologram()
                        editionView()
                    }
                }.task(id: animated) {
                    isAnimating = animated
                }
            } else if item is LegendaryJoker {
                ZStack {
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
                }.task(id: animated) {
                    isAnimating = animated
                }
            } else if item is Card {
                renderCard()
            } else {
                if let cgImage = spriteSheet.cgImage?.cropping(to: frame) {
                    if edition == .Negative {
                        Image(decorative: cgImage, scale: spriteSheet.scale, orientation: .up)
                            .resizable()
                            .frame(width: frame.width, height: frame.height)
                            .colorInvert()
                    }else {
                        ZStack {
                            Image(decorative: cgImage, scale: spriteSheet.scale, orientation: .up)
                                .resizable()
                                .frame(width: frame.width, height: frame.height)
                            if edition != nil {
                                editionView()
                            }
                        }
                    }
                }
            }
            getDescription()
        }.foregroundStyle(foregroundColor)
            .animation(
                animated
                    ? Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: true)
                    : nil,
                value: isAnimating
            )
    }
    
    @ViewBuilder
    private func getDescription() -> some View {
        VStack {
            Text(item.rawValue)
                .font(.customCaption)
                .bold()
                .multilineTextAlignment(.center)
            
            if let edition = edition {
                if edition != .NoEdition {
                    Text(edition.rawValue)
                        .foregroundStyle(.red)
                        .font(.customCaption)
                        .multilineTextAlignment(.center)
                }
            }
        }.frame(maxWidth: 71, minHeight: 35)
    }
    
    
    /// Enhancer sprite-sheet coordinates: { Bonus: (1,1), Mult: (2,1), Wild: (3,1), Glass: (5,1), Steel: (6,1), Stone: (5,0), Gold: (6,0), Lucky: (4,1) }
    private func enhancementPosition(_ enhancement: Enhancement?) -> (x: Int, y: Int) {
        switch enhancement {
        case .Luck: (4, 1)
        case .Bonus: (1, 1)
        case .Wild: (3, 1)
        case .Gold: (6, 0)
        case .Stone: (5, 0)
        case .Steel: (6, 1)
        case .Glass: (5, 1)
        case .Mult: (2, 1)
        case nil: (1, 0)
        }
    }

    @ViewBuilder
    private func backgroundCard(_ c : Card) -> some View {
        let (x, y) = enhancementPosition(c.enhancement)
        let frame = CGRect(x: x * 71, y: y * 95, width: 71, height: 95)

        if let cgImage = Images.enhancers.cgImage?.cropping(to: frame) {
            Image(decorative: cgImage, scale: Images.enhancers.scale, orientation: .up)
                .resizable()
                .frame(width: frame.width, height: frame.height)
        } else {
            Color.clear
                .frame(width: frame.width, height: frame.height)
        }
    }

    private func renderCard() -> some View{
        let c = card!
        
        return ZStack {
            backgroundCard(c)
            
            if c.enhancement != .Stone {
                if let cgImage = spriteSheet.cgImage?.cropping(to: frame) {
                    Image(decorative: cgImage, scale: spriteSheet.scale, orientation: .up)
                        .resizable()
                        .frame(width: frame.width, height: frame.height)
                }
            }
            
            if c.edition != .NoEdition {
                editionView()
            }
            
            if c.seal != .NoSeal {
                renderSeal(c)
            }
        }
    }
    
    
    private func sealPosition(_ seal: Seal) -> (x: Int, y: Int) {
        switch seal {
        case .RedSeal: (5, 4)
        case .GoldSeal: (2, 0)
        case .PurpleSeal: (4, 4)
        case .BlueSeal: (6, 4)
        case .NoSeal: (0, 0)
        }
    }

    @ViewBuilder
    private func renderSeal(_ c : Card) -> some View {
        let (x, y) = sealPosition(c.seal)
        let frame = CGRect(x: x * 71, y: y * 95, width: 71, height: 95)

        if let cgImage = Images.enhancers.cgImage?.cropping(to: frame) {
            Image(decorative: cgImage, scale: Images.enhancers.scale, orientation: .up)
                .resizable()
                .frame(width: frame.width, height: frame.height)
        } else {
            Color.clear
                .frame(width: frame.width, height: frame.height)
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
    ScrollView {
        HStack {
            LegendaryJoker.Perkeo.sprite(edition: .Negative)
            LegendaryJoker.Triboulet.sprite(edition: .Holographic)
            Specials.THE_SOUL.sprite()
            RareJoker.Blueprint.sprite(edition: .Polychrome)
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
            RareJoker.Hit_the_Road.sprite(edition: .Foil)
            UnCommonJoker.Hologram.sprite()
            Tarot.The_High_Priestess.sprite()
            Tarot.The_Wheel_of_Fortune.sprite()
            CommonJoker.Chaos_the_Clown.sprite()
        }
        HStack {
            UnCommonJoker.Ceremonial_Dagger.sprite()
            CommonJoker.Ball.sprite()
            RareJoker.Baseball_Card.sprite()
            CommonJoker.Delayed_Gratification.sprite()
            EditionItem(edition: .Negative, LegendaryJoker.Perkeo).sprite(edition: .Negative)
        }
        
        HStack {
            Tarot.The_Wheel_of_Fortune.sprite(edition: .Foil)
            Tarot.The_Wheel_of_Fortune.sprite(edition: .Polychrome)
            Tarot.The_Wheel_of_Fortune.sprite(edition: .Holographic)
            Tarot.The_Wheel_of_Fortune.sprite(edition: .Negative)
        }
        HStack {
            Card(Cards.H_K, .Luck, .NoEdition, .RedSeal).sprite()
            Card(Cards.H_K, .Gold, .NoEdition, .BlueSeal).sprite()
            Card(Cards.H_K, .Mult, .NoEdition, .PurpleSeal).sprite()
            Card(Cards.H_K, .Bonus, .NoEdition, .GoldSeal).sprite()
            Card(Cards.H_K, .Glass, .NoEdition, .RedSeal).sprite()
            
        }
        HStack {
            Card(Cards.H_K, .Stone, .NoEdition, .RedSeal).sprite()
            Card(Cards.H_K, .Steel, .NoEdition, .RedSeal).sprite()
            Card(Cards.H_K, .Wild, .NoEdition, .NoSeal).sprite()
        }
        
    }.background(Color(hex: "#1e1e1e"))
}
