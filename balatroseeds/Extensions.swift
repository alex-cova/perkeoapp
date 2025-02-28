//
//  Extensions.swift
//  balatroseeds
//
//  Created by Alex on 26/01/25.
//
import SwiftUI

extension Color {
    // Create a custom initializer for Color using a hex value
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = hex.hasPrefix("#") ? 1 : 0
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000ff) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}


extension Item {
    
    func sprite(edition: Edition? = nil) -> SpriteImageView {
        
        if let card = self as? Card {
            return SpriteImageView(self, Images.cards, card.rank.index(), card.suit.index(), 71, 95, true)
        }
        
        if(self.rawValue == Specials.BLACKHOLE.rawValue){
            return SpriteImageView(self, Images.tarots, 9, 3, 71, 95)
        }
        
        let jokers = Images.sprite.readJokers()
        
        for joker in jokers {
            if(joker.name == self.rawValue){
                return SpriteImageView(self, Images.jokers, joker.pos.x, joker.pos.y, 71, 95, edition: edition)
            }
        }
        
        let tarots = Images.sprite.readTarots()
        
        for tarot in tarots {
            if(tarot.name == self.rawValue){
                return SpriteImageView(self, Images.tarots, tarot.pos.x, tarot.pos.y, 71, 95)
            }
        }
        
        let vouchers = Images.sprite.readVouchers()
        
        for voucher in vouchers {
            if(voucher.name == self.rawValue){
                return SpriteImageView(self, Images.vouchers, voucher.pos.x, voucher.pos.y, 71, 95)
            }
        }
        
        let tags = Images.sprite.readTags()
        
        for tag in tags {
            if(tag.name == self.rawValue){
                return SpriteImageView(self, Images.tags, tag.pos.x, tag.pos.y, 34, 34)
            }
        }
        
        let bosses = Images.sprite.readBosses()
        
        for boss in bosses {
            if(boss.name == self.rawValue){
                return SpriteImageView(self, Images.bosses, boss.pos.x, boss.pos.y, 34, 34)
            }
        }
        
        if(self.rawValue == Specials.THE_SOUL.rawValue){
            return SpriteImageView(self, Images.tarots, 2, 2, 71, 95, edition: edition)
        }

        print("Missing: \(self.rawValue)")
        
        return SpriteImageView(self,Images.vouchers, 7, 3, 34, 45)
    }
}
