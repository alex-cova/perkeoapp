//
//  Extensions.swift
//  balatroseeds
//
//  Created by Alex on 26/01/25.
//
import SwiftUI

extension Font {
    static func customFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.custom("m6x11plus", size: size, relativeTo: .body)
            .weight(weight)
    }
    
    // Convenience methods for different font styles
    static let customHeadline = customFont(size: 20, weight: .bold)
    static let customTitle = customFont(size: 24, weight: .bold)
    static let customBody = customFont(size: 18)
    static let customCaption = customFont(size: 12)
}

extension Color {
    // Create a custom initializer for Color using a hex value
    init(hex: String) {
        
        let hex = hex.replacingOccurrences(of: "#", with: "")
        
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000ff) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

extension String {
    func isValidSeed() -> Bool{
        return self.range(of: "^[a-zA-Z0-9]{1,8}$", options: .regularExpression) != nil
    }
    
    func normalizeSeed() -> String {
        self.uppercased().replacingOccurrences(of: "0", with: "O")
    }
}

extension Item {
    
    func sprite(edition: Edition? = nil, color: Color = .white) -> SpriteImageView {
        
        if let card = self as? Card {
            return SpriteImageView(self, Images.cards, card.rank.index(), card.suit.index(), 71, 95, card, color)
        }
        
        if(self.rawValue == Specials.BLACKHOLE.rawValue){
            return SpriteImageView(self, Images.tarots, 9, 3, 71, 95, nil, color)
        }
        
        let jokers = Images.sprite.readJokers()
        
        for joker in jokers {
            if(joker.name == self.rawValue){
                return SpriteImageView(self, Images.jokers, joker.pos.x, joker.pos.y, 71, 95, edition: edition, color)
            }
        }
        
        let tarots = Images.sprite.readTarots()
        
        for tarot in tarots {
            if(tarot.name == self.rawValue){
                return SpriteImageView(self, Images.tarots, tarot.pos.x, tarot.pos.y, 71, 95, nil,  color)
            }
        }
        
        let vouchers = Images.sprite.readVouchers()
        
        for voucher in vouchers {
            if(voucher.name == self.rawValue){
                return SpriteImageView(self, Images.vouchers, voucher.pos.x, voucher.pos.y, 71, 95, nil, color)
            }
        }
        
        let tags = Images.sprite.readTags()
        
        for tag in tags {
            if(tag.name == "\(self.rawValue) Tag"){
                return SpriteImageView(self, Images.tags, tag.pos.x, tag.pos.y, 34, 34, nil, color)
            }
        }
        
        let bosses = Images.sprite.readBosses()
        
        for boss in bosses {
            if(boss.name == self.rawValue){
                return SpriteImageView(self, Images.bosses, boss.pos.x, boss.pos.y, 34, 34, nil, color)
            }
        }
        
        if(self.rawValue == Specials.THE_SOUL.rawValue){
            return SpriteImageView(self, Images.tarots, 2, 2, 71, 95, edition: edition, color)
        }
        
        print("Missing: \(self.rawValue)")
        
        return SpriteImageView(self,Images.vouchers, 7, 3, 34, 45)
    }
}
