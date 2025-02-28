//
//  Structs.swift
//  balatroseeds
//
//  Created by Alex on 03/01/25.
//

class JokerStickers {
    var eternal = false
    var perishable = false
    var rental = false
}

class JokerData {
    var joker : Item = CommonJoker.Joker
    var rarity : String = "Common"
    var edition : Edition  = .NoEdition
    var stickers : JokerStickers = JokerStickers()
    
    init(_ joker: Item,_ rarity: String,_ edition: Edition,_ stickers: JokerStickers) {
        self.joker = joker
        self.rarity = rarity
        self.edition = edition
        self.stickers = stickers
    }
    
    init(){
        
    }
    
    func sprite() -> SpriteImageView {
        joker.sprite(edition: edition)
    }
}

class Card: Item {
    var base: Cards
    var enhancement: Enhancement?
    var edition: Edition = .NoEdition
    var seal: Seal = .NoSeal

    var rawValue: String {
        return "\(rank.rawValue) \(suit.rawValue)"
    }

    var ordinal: Int {
        return base.ordinal
    }

    var y: Int {
        return base.y
    }

    init(_ base: Cards, _ enhancement: Enhancement?, _ edition: Edition, _ seal: Seal) {
        self.base = base
        self.enhancement = enhancement
        self.edition = edition
        self.seal = seal
    }

    var suit: Suit {
        switch base.rawValue.charAt(0) {
        case "C":
            return .Clubs
        case "H":
            return .Hearts
        case "D":
            return .Diamonds
        default:
            return .Spades
        }
    }

    var rank: Rank {
        switch base.rawValue.charAt(2) {
        case "T":
            return .r_10
        case "J":
            return .Jack
        case "Q":
            return .Queen
        case "K":
            return .King
        case "3":
            return .r_3
        case "4":
            return .r_4
        case "5":
            return .r_5
        case "6":
            return .r_6
        case "7":
            return .r_7
        case "8":
            return .r_8
        case "9":
            return .r_9
        case "A":
            return .Ace
        default:
            return .r_2
        }
    }
}

class EditionItem: Encodable, Identifiable, Item {
    let edition: Edition
    let item: Item

    init(edition: Edition, _ item: Item) {
        
        if item is EditionItem {
            fatalError("Cannot create EditionItem from EditionItem")
        }
        
        self.edition = edition
        self.item = item
    }

    init(_ item: Item) {
        if item is EditionItem {
            fatalError("Cannot create EditionItem from EditionItem")
        }
        
        self.edition = .NoEdition
        self.item = item
    }

    enum CodingKeys: CodingKey {
        case sticker
        case item
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if  edition != .NoEdition {
            try container.encode(edition, forKey: .sticker)
        }
        try container.encode(item.rawValue, forKey: .item)
    }

    var rawValue: String {
        return item.rawValue
    }

    var ordinal: Int {
        return item.ordinal
    }

    var y: Int {
        return item.y
    }
}

class Pack : Encodable, Identifiable {
    var type : PackType = .RETRY
    var size : Int = 0
    var choices = 0
    var options : [EditionItem]
    
    init(_ type: PackType,_ size: Int,_ choices: Int, options: [EditionItem]) {
        self.type = type
        self.size = size
        self.choices = choices
        self.options = options
    }
    
    init(_ type: PackType,_ size: Int,_ choices: Int) {
        self.type = type
        self.size = size
        self.choices = choices
        self.options = []
    }
    
    var kind : PackKind {
        type.kind
    }
    
    func containsOption(_ name : String) -> Bool {
        for option in options {
            if option.item.rawValue == name {
                return true
            }
        }
        return false
    }
}

class ShopInstance {
    var jokerRate : Double = 20.0
    var tarotRate : Double = 4.0
    var planetRate : Double = 4.0
    var playingCardRate : Double = 0.0
    var spectralRate : Double = 0.0
    
    init(_ jokerRate: Double,_ tarotRate: Double,_ planetRate: Double,_ playingCardRate: Double,_ spectralRate: Double) {
        self.jokerRate = jokerRate
        self.tarotRate = tarotRate
        self.planetRate = planetRate
        self.playingCardRate = playingCardRate
        self.spectralRate = spectralRate
    }
    
    func getTotalRate() -> Double {
        jokerRate + tarotRate + planetRate + playingCardRate + spectralRate
    }
    
}

class ShopItem {
    var type : ItemType = .Tarot
    var item : Item = Tarot.The_Fool
    var jokerData : JokerData = JokerData()
    
    init(){
        
    }
    
    init(_ type: ItemType,_ item: Item) {
        self.type = type
        self.item = item
        self.jokerData = JokerData()
    }
    
    init(_ type: ItemType,_ item: Item,_ jokerData: JokerData) {
        self.type = type
        self.item = item
        self.jokerData = jokerData
    }
}


class InstanceParams {
    var deck : Deck
    var stake : Stake
    var showman : Bool
    var sixesFactor : Int
    var version : Int
    var vouchers : Set<Voucher>
    
    init(){
        deck = Deck.RED_DECK
        stake = Stake.White_Stake
        showman = false
        sixesFactor = 1
        version = Version.v_101c.rawValue
        vouchers = Set<Voucher>()
    }
    
    init (_ deck: Deck,_ stake: Stake,_ showman: Bool,_ sixesFactor: Int,_ version: Version){
        self.deck = deck
        self.stake = stake
        self.showman = showman
        self.sixesFactor = sixesFactor
        self.version = version.rawValue
        self.vouchers = Set<Voucher>()
    }
}
