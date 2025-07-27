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
    
    static let customBackground = Color(hex: "#1e1e1e")
    static let customRowBackground = Color(hex: "#4d4d4d")
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
            return SpriteImageView(self, Images.cards, card.rank.index(), card.suit.index(), 71, 95, card, edition: edition, color)
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
                return SpriteImageView(self, Images.tarots, tarot.pos.x, tarot.pos.y, 71, 95, edition: edition,  color)
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
                
        for deck in Deck.allCases {
            if(self.rawValue == deck.rawValue){
                switch deck {
                case .RED_DECK:
                    return SpriteImageView(self, Images.enhancers, 0, 0, 71, 95)
                case .BLUE_DECK:
                    return SpriteImageView(self, Images.enhancers, 0, 2, 71, 95)
                case .GREEN_DECK:
                    return SpriteImageView(self, Images.enhancers, 2, 2, 71, 95)
                case .YELLOW_DECK:
                    return SpriteImageView(self, Images.enhancers, 1, 2, 71, 95)
                case .BLACK_DECK:
                    return SpriteImageView(self, Images.enhancers, 3, 2, 71, 95)
                case .MAGIC_DECK:
                    return SpriteImageView(self, Images.enhancers, 0, 3, 71, 95)
                case .NEBULA_DECK:
                    return SpriteImageView(self, Images.enhancers, 3, 0, 71, 95)
                case .GHOST_DECK:
                    return SpriteImageView(self, Images.enhancers, 6, 2, 71, 95)
                case .ABANDONED_DECK:
                    return SpriteImageView(self, Images.enhancers, 3, 3, 71, 95)
                case.CHECKERED_DECK:
                    return SpriteImageView(self, Images.enhancers, 1, 3, 71, 95)
                case .ZODIAC_DECK:
                    return SpriteImageView(self, Images.enhancers, 4, 3, 71, 95)
                case .PAINTED_DECK:
                    return SpriteImageView(self, Images.enhancers, 3, 4, 71, 95)
                case .ANAGLYPH_DECK:
                    return SpriteImageView(self, Images.enhancers, 2, 4, 71, 95)
                case .PLASMA_DECK:
                    return SpriteImageView(self, Images.enhancers, 4, 2, 71, 95)
                case .ERRATIC_DECK:
                    return SpriteImageView(self, Images.enhancers, 2, 3, 71, 95)
                }
            }
        }
        
        for chip in Stake.allCases {
            if self.rawValue == chip.rawValue {
                switch chip {
                case .White_Stake:
                    return SpriteImageView(self, Images.chips, 0, 0, 29, 29)
                case .Red_Stake:
                    return SpriteImageView(self, Images.chips, 1, 0, 29, 29)
                case .Green_Stake:
                    return SpriteImageView(self, Images.chips, 2, 0, 29, 29)
                case .Blue_Stake:
                    return SpriteImageView(self, Images.chips, 3, 0, 29, 29)
                case .Black_Stake:
                    return SpriteImageView(self, Images.chips, 4, 0, 29, 29)
                case .Purple_Stake:
                    return SpriteImageView(self, Images.chips, 0, 1, 29, 29)
                case .Orange_Stake:
                    return SpriteImageView(self, Images.chips, 1, 1, 29, 29)
                case .Gold_Stake:
                    return SpriteImageView(self, Images.chips, 2, 1, 29, 29)
                }
            }
        }

        print("Missing: \(self.rawValue)")
        
        return SpriteImageView(self,Images.vouchers, 7, 3, 34, 45)
    }
}
