//
//  Extensions.swift
//  balatroseeds
//
//  Created by Alex on 26/01/25.
//
import SwiftUI
import Foundation
import CryptoKit

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

extension Date {
    func generateDailyCode() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateString = formatter.string(from: self)

        let hash = SHA256.hash(data: Data(dateString.utf8))
        let charset = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

        return hash.prefix(8).map {
            charset[Int($0) % charset.count]
        }.map(String.init).joined()
    }
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
    
    func sprite(edition: Edition? = nil, color: Color = .white, animated: Bool = true) -> SpriteImageView {
        
        if let card = self as? Card {
            return SpriteImageView(self, Images.cards, card.rank.index(), card.suit.index(), 71, 95, card, edition: edition, color, animated: animated)
        }
        
        if(self.rawValue == Specials.BLACKHOLE.rawValue){
            return SpriteImageView(self, Images.tarots, 9, 3, 71, 95, nil, color, animated: animated)
        }

        if let joker = Images.sprite.joker(named: rawValue) {
            return SpriteImageView(self, Images.jokers, joker.pos.x, joker.pos.y, 71, 95, edition: edition, color, animated: animated)
        }

        if let tarot = Images.sprite.tarot(named: rawValue) {
            return SpriteImageView(self, Images.tarots, tarot.pos.x, tarot.pos.y, 71, 95, edition: edition, color, animated: animated)
        }

        if let voucher = Images.sprite.voucher(named: rawValue) {
            return SpriteImageView(self, Images.vouchers, voucher.pos.x, voucher.pos.y, 71, 95, nil, color, animated: animated)
        }

        if let tag = Images.sprite.tag(named: "\(rawValue) Tag") {
            return SpriteImageView(self, Images.tags, tag.pos.x, tag.pos.y, 34, 34, nil, color, animated: animated)
        }

        if let boss = Images.sprite.boss(named: rawValue) {
            return SpriteImageView(self, Images.bosses, boss.pos.x, boss.pos.y, 34, 34, nil, color, animated: animated)
        }
        
        if(self.rawValue == Specials.THE_SOUL.rawValue){
            return SpriteImageView(self, Images.tarots, 2, 2, 71, 95, edition: edition, color, animated: animated)
        }
                
        for deck in Deck.allCases {
            if(self.rawValue == deck.rawValue){
                switch deck {
                case .RED_DECK:
                    return SpriteImageView(self, Images.enhancers, 0, 0, 71, 95, animated: animated)
                case .BLUE_DECK:
                    return SpriteImageView(self, Images.enhancers, 0, 2, 71, 95, animated: animated)
                case .GREEN_DECK:
                    return SpriteImageView(self, Images.enhancers, 2, 2, 71, 95, animated: animated)
                case .YELLOW_DECK:
                    return SpriteImageView(self, Images.enhancers, 1, 2, 71, 95, animated: animated)
                case .BLACK_DECK:
                    return SpriteImageView(self, Images.enhancers, 3, 2, 71, 95, animated: animated)
                case .MAGIC_DECK:
                    return SpriteImageView(self, Images.enhancers, 0, 3, 71, 95, animated: animated)
                case .NEBULA_DECK:
                    return SpriteImageView(self, Images.enhancers, 3, 0, 71, 95, animated: animated)
                case .GHOST_DECK:
                    return SpriteImageView(self, Images.enhancers, 6, 2, 71, 95, animated: animated)
                case .ABANDONED_DECK:
                    return SpriteImageView(self, Images.enhancers, 3, 3, 71, 95, animated: animated)
                case.CHECKERED_DECK:
                    return SpriteImageView(self, Images.enhancers, 1, 3, 71, 95, animated: animated)
                case .ZODIAC_DECK:
                    return SpriteImageView(self, Images.enhancers, 4, 3, 71, 95, animated: animated)
                case .PAINTED_DECK:
                    return SpriteImageView(self, Images.enhancers, 3, 4, 71, 95, animated: animated)
                case .ANAGLYPH_DECK:
                    return SpriteImageView(self, Images.enhancers, 2, 4, 71, 95, animated: animated)
                case .PLASMA_DECK:
                    return SpriteImageView(self, Images.enhancers, 4, 2, 71, 95, animated: animated)
                case .ERRATIC_DECK:
                    return SpriteImageView(self, Images.enhancers, 2, 3, 71, 95, animated: animated)
                }
            }
        }
        
        for chip in Stake.allCases {
            if self.rawValue == chip.rawValue {
                switch chip {
                case .White_Stake:
                    return SpriteImageView(self, Images.chips, 0, 0, 29, 29, animated: animated)
                case .Red_Stake:
                    return SpriteImageView(self, Images.chips, 1, 0, 29, 29, animated: animated)
                case .Green_Stake:
                    return SpriteImageView(self, Images.chips, 2, 0, 29, 29, animated: animated)
                case .Blue_Stake:
                    return SpriteImageView(self, Images.chips, 3, 0, 29, 29, animated: animated)
                case .Black_Stake:
                    return SpriteImageView(self, Images.chips, 4, 0, 29, 29, animated: animated)
                case .Purple_Stake:
                    return SpriteImageView(self, Images.chips, 0, 1, 29, 29, animated: animated)
                case .Orange_Stake:
                    return SpriteImageView(self, Images.chips, 1, 1, 29, 29, animated: animated)
                case .Gold_Stake:
                    return SpriteImageView(self, Images.chips, 2, 1, 29, 29, animated: animated)
                }
            }
        }

        print("Missing: \(self.rawValue)")
        
        return SpriteImageView(self,Images.vouchers, 7, 3, 34, 45, animated: animated)
    }
}
