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
        self.item = item
        self.spriteSheet = sprite
        self.frame = CGRect(x: x * w, y: y * h, width: w, height: h)
        self.card = card
        self.edition = edition
    }
    
    func getLegendaryFrame() -> CGRect {
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
    func editionView() -> some View {
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
    func legendaryView() -> some View {
        if let legendary = item as? LegendaryJoker {
            if(legendary == .Perke){
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
        if item.rawValue == "Hologram" {
            getHologram()
        } else if item is LegendaryJoker {
            legendaryView()
        } else {
            if let cgImage = spriteSheet.cgImage?.cropping(to: frame) {
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
            } else {
                Image(systemName: "photo.fill")
                    .tint(.red)
            }
        }
    }
    
    func edition(_ edition: Edition) -> some View {
        self.modifier(EditionView(edition: edition))
    }
}
