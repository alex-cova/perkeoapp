//
//  Enums.swift
//  balatroseeds
//
//  Created by Alex on 03/01/25.
//

import Foundation

enum PackKind {
    case Arcana, Celestial, Standard, Buffoon, Spectral
}

protocol Item: Encodable {
    var rawValue: String { get }
    var ordinal: Int { get }
    var y: Int { get }
}

protocol Joker {
    var type: JokerType { get }
}

enum JokerType {
    case LEGENDARY
    case RARE
    case UNCOMMON
    case COMMO

}

enum PackType: String, CaseIterable, Item {
    case RETRY = "RETRY"

    case Arcana_Pack = "Arcana Pack"
    case Jumbo_Arcana_Pack = "Jumbo Arcana Pack"
    case Mega_Arcana_Pack = "Mega Arcana Pack"

    case Celestial_Pack = "Celestial Pack"
    case Jumbo_Celestial_Pack = "Jumbo Celestial Pack"
    case Mega_Celestial_Pack = "Mega Celestial Pack"

    case Standard_Pack = "Standard Pack"
    case Jumbo_Standard_Pack = "Jumbo Standard Pack"
    case Mega_Standard_Pack = "Mega Standard Pack"

    case Buffoon_Pack = "Buffoon Pack"
    case Jumbo_Buffoon_Pack = "Jumbo Buffoon Pack"
    case Mega_Buffoon_Pack = "Mega Buffoon Pack"

    case Spectral_Pack = "Spectral Pack"
    case Jumbo_Spectral_Pack = "Jumbo Spectral Pack"
    case Mega_Spectral_Pack = "Mega Spectral Pack"

    var ordinal: Int {
        0
    }

    var y: Int {
        0
    }

    var value: Double {
        switch self {
        case .RETRY:
            return 22.42
        case .Arcana_Pack, .Celestial_Pack, .Standard_Pack:
            return 4
        case .Jumbo_Arcana_Pack, .Jumbo_Celestial_Pack, .Jumbo_Standard_Pack:
            return 2
        case .Mega_Arcana_Pack, .Mega_Celestial_Pack, .Mega_Standard_Pack:
            return 0.5
        case .Buffoon_Pack:
            return 1.2
        case .Jumbo_Buffoon_Pack:
            return 0.6
        case .Mega_Buffoon_Pack:
            return 0.15
        case .Spectral_Pack:
            return 0.6
        case .Jumbo_Spectral_Pack:
            return 0.3
        case .Mega_Spectral_Pack:
            return 0.07
        }
    }

    var kind: PackKind {
        switch self {
        case .Arcana_Pack, .Jumbo_Arcana_Pack, .Mega_Arcana_Pack:
            return .Arcana
        case .Celestial_Pack, .Jumbo_Celestial_Pack, .Mega_Celestial_Pack:
            return .Celestial
        case .Standard_Pack, .Jumbo_Standard_Pack, .Mega_Standard_Pack:
            return .Standard
        case .Buffoon_Pack, .Jumbo_Buffoon_Pack, .Mega_Buffoon_Pack:
            return .Buffoon
        case .Spectral_Pack, .Jumbo_Spectral_Pack, .Mega_Spectral_Pack:
            return .Spectral
        default:
            fatalError("Invalid pack type: \(self)")
        }
    }

    var isMega: Bool {
        return self == .Mega_Arcana_Pack || self == .Mega_Celestial_Pack
            || self == .Mega_Standard_Pack || self == .Mega_Buffoon_Pack
            || self == .Mega_Spectral_Pack
    }

    var isJumbo: Bool {
        return self == .Jumbo_Arcana_Pack || self == .Jumbo_Celestial_Pack
            || self == .Jumbo_Standard_Pack || self == .Jumbo_Buffoon_Pack
            || self == .Jumbo_Spectral_Pack
    }

    var isBuffoon: Bool {
        return self == .Buffoon_Pack || self == .Jumbo_Buffoon_Pack || self == .Mega_Buffoon_Pack
    }

    var isSpectral: Bool {
        return self == .Spectral_Pack || self == .Jumbo_Spectral_Pack || self == .Mega_Spectral_Pack
    }
}

enum Seal: String, CaseIterable, Item {
    case NoSeal = "No Seal"
    case RedSeal = "Red Seal"
    case BlueSeal = "Blue Seal"
    case GoldSeal = "Gold Seal"
    case PurpleSeal = "Purple Seal"

    var ordinal: Int {
        0
    }

    var y: Int {
        0
    }
}

enum Edition: String, CaseIterable, Item {
    case Negative = "Negative"
    case Polychrome = "Polychrome"
    case Holographic = "Holographic"
    case Foil = "Foil"
    case NoEdition = "No Edition"
    case Eternal = "Eternal"
    case Perishable = "Perishable"
    case Rental = "Rental"

    var ordinal: Int {
        switch(self){
        case .Negative : return 0
        case .Polychrome : return 1
        case .Holographic : return 2
        case .Foil : return 3
        case .NoEdition : return 4
        case .Eternal : return 5
        case .Perishable : return 6
        case .Rental: return 7
        }
    }

    var y: Int {
        -1
    }
}

enum ItemType: String, CaseIterable, Item {
    case Joker = "Joker"
    case Tarot = "Tarot"
    case Planet = "Planet"
    case Spectral = "Spectral"
    case PlayingCard = "Playing Card"

    var ordinal: Int {
        0
    }

    var y: Int {
        0
    }
}

enum Stake: String, CaseIterable, Item {
    case White_Stake = "White Stake"
    case Red_Stake = "Red Stake"
    case Green_Stake = "Green Stake"
    case Black_Stake = "Black Stake"
    case Blue_Stake = "Blue Stake"
    case Purple_Stake = "Purple Stake"
    case Orange_Stake = "Orange Stake"
    case Gold_Stake = "Gold Stake"

    var ordinal: Int {
        0
    }

    var y: Int {
        0
    }
}

enum Specials: String, CaseIterable, Item {
    case BLACKHOLE = "Black Hole"
    case THE_SOUL = "The Soul"

    var ordinal: Int {
        switch self {
        case .BLACKHOLE: return 0
        case .THE_SOUL: return 1
        }
    }

    var y: Int {
        9
    }
}

enum Voucher: String, CaseIterable, Item, Identifiable {
    case Overstock = "Overstock"
    case Overstock_Plus = "Overstock Plus"
    case Clearance_Sale = "Clearance Sale"
    case Liquidation = "Liquidation"
    case Hone = "Hone"
    case Glow_Up = "Glow Up"
    case Reroll_Surplus = "Reroll Surplus"
    case Reroll_Glut = "Reroll Glut"
    case Crystal_Ball = "Crystal Ball"
    case Omen_Globe = "Omen Globe"
    case Telescope = "Telescope"
    case Observatory = "Observatory"
    case Grabber = "Grabber"
    case Nacho_Tong = "Nacho Tong"
    case Wasteful = "Wasteful"
    case Recyclomancy = "Recyclomancy"
    case Tarot_Merchant = "Tarot Merchant"
    case Tarot_Tycoon = "Tarot Tycoon"
    case Planet_Merchant = "Planet Merchant"
    case Planet_Tycoon = "Planet Tycoon"
    case Seed_Money = "Seed Money"
    case Money_Tree = "Money Tree"
    case Blank = "Blank"
    case Antimatter = "Antimatter"
    case Magic_Trick = "Magic Trick"
    case Illusion = "Illusion"
    case Hieroglyph = "Hieroglyph"
    case Petroglyph = "Petroglyph"
    case Directors_Cut = "Director's Cut"
    case Retcon = "Retcon"
    case Paint_Brush = "Paint Brush"
    case Palett = "Palette"
    
    var id : String {
        rawValue
    }

    var ordinal: Int {
        switch self {
        case .Overstock: return 0
        case .Overstock_Plus: return 1
        case .Clearance_Sale: return 2
        case .Liquidation: return 3
        case .Hone: return 4
        case .Glow_Up: return 5
        case .Reroll_Surplus: return 6
        case .Reroll_Glut: return 7
        case .Crystal_Ball: return 8
        case .Omen_Globe: return 9
        case .Telescope: return 10
        case .Observatory: return 11
        case .Grabber: return 12
        case .Nacho_Tong: return 13
        case .Wasteful: return 14
        case .Recyclomancy: return 15
        case .Tarot_Merchant: return 16
        case .Tarot_Tycoon: return 17
        case .Planet_Merchant: return 18
        case .Planet_Tycoon: return 19
        case .Seed_Money: return 20
        case .Money_Tree: return 21
        case .Blank: return 22
        case .Antimatter: return 23
        case .Magic_Trick: return 24
        case .Illusion: return 25
        case .Hieroglyph: return 26
        case .Petroglyph: return 27
        case .Directors_Cut: return 28
        case .Retcon: return 29
        case .Paint_Brush: return 30
        case .Palett: return 31

        }
    }

    var y: Int {
        7
    }
}

enum Version: Int, CaseIterable {
    case v_100n = 10014
    case v_101c = 10103
    case v_101f = 10106
}

enum UnCommonJoker101C: String, CaseIterable, Item, Joker {
    case Joker_Stencil = "Joker Stencil"
    case Four_Fingers = "Four Fingers"
    case Mime = "Mime"
    case Ceremonial_Dagger = "Ceremonial Dagger"
    case Marble_Joker = "Marble Joker"
    case Loyalty_Card = "Loyalty Card"
    case Dusk = "Dusk"
    case Fibonacci = "Fibonacci"
    case Steel_Joker = "Steel Joker"
    case Hack = "Hack"
    case Pareidolia = "Pareidolia"
    case Space_Joker = "Space Joker"
    case Burglar = "Burglar"
    case Blackboard = "Blackboard"
    case Sixth_Sense = "Sixth Sense"
    case Constellation = "Constellation"
    case Hiker = "Hiker"
    case Card_Sharp = "Card Sharp"
    case Madness = "Madness"
    case Seance = "Seance"
    case Shortcut = "Shortcut"
    case Hologram = "Hologram"
    case Cloud_9 = "Cloud 9"
    case Rocket = "Rocket"
    case Midas_Mask = "Midas Mask"
    case Luchador = "Luchador"
    case Gift_Card = "Gift Card"
    case Turtle_Bean = "Turtle Bean"
    case Erosion = "Erosion"
    case To_the_Moon = "To the Moon"
    case Stone_Joker = "Stone Joker"
    case Lucky_Cat = "Lucky Cat"
    case Bull = "Bull"
    case Diet_Cola = "Diet Cola"
    case Trading_Card = "Trading Card"
    case Flash_Card = "Flash Card"
    case Spare_Trousers = "Spare Trousers"
    case Ramen = "Ramen"
    case Seltzer = "Seltzer"
    case Castle = "Castle"
    case Mr_Bones = "Mr. Bones"
    case Acrobat = "Acrobat"
    case Sock_and_Buskin = "Sock and Buskin"
    case Troubadour = "Troubadour"
    case Certificate = "Certificate"
    case Smeared_Joker = "Smeared Joker"
    case Throwback = "Throwback"
    case Rough_Gem = "Rough Gem"
    case Bloodstone = "Bloodstone"
    case Arrowhead = "Arrowhead"
    case Onyx_Agate = "Onyx Agate"
    case Glass_Joker = "Glass Joker"
    case Showman = "Showman"
    case Flower_Pot = "Flower Pot"
    case Merry_Andy = "Merry Andy"
    case Oops_All_6s = "Oops! All 6s"
    case The_Idol = "The Idol"
    case Seeing_Double = "Seeing Double"
    case Matador = "Matador"
    case Stuntman = "Stuntman"
    case Satellite = "Satellite"
    case Cartomancer = "Cartomancer"
    case Astronomer = "Astronomer"
    case Bootstraps = "Bootstraps"

    var ordinal: Int {
        switch self {
        case .Joker_Stencil: return 0
        case .Four_Fingers: return 1
        case .Mime: return 2
        case .Ceremonial_Dagger: return 3
        case .Marble_Joker: return 4
        case .Loyalty_Card: return 5
        case .Dusk: return 6
        case .Fibonacci: return 7
        case .Steel_Joker: return 8
        case .Hack: return 9
        case .Pareidolia: return 10
        case .Space_Joker: return 11
        case .Burglar: return 12
        case .Blackboard: return 13
        case .Sixth_Sense: return 14
        case .Constellation: return 15
        case .Hiker: return 16
        case .Card_Sharp: return 17
        case .Madness: return 18
        case .Seance: return 19
        case .Shortcut: return 20
        case .Hologram: return 21
        case .Cloud_9: return 22
        case .Rocket: return 23
        case .Midas_Mask: return 24
        case .Luchador: return 25
        case .Gift_Card: return 26
        case .Turtle_Bean: return 27
        case .Erosion: return 28
        case .To_the_Moon: return 29
        case .Stone_Joker: return 30
        case .Lucky_Cat: return 31
        case .Bull: return 32
        case .Diet_Cola: return 33
        case .Trading_Card: return 34
        case .Flash_Card: return 35
        case .Spare_Trousers: return 36
        case .Ramen: return 37
        case .Seltzer: return 38
        case .Castle: return 39
        case .Mr_Bones: return 40
        case .Acrobat: return 41
        case .Sock_and_Buskin: return 42
        case .Troubadour: return 43
        case .Certificate: return 44
        case .Smeared_Joker: return 45
        case .Throwback: return 46
        case .Rough_Gem: return 47
        case .Bloodstone: return 48
        case .Arrowhead: return 49
        case .Onyx_Agate: return 50
        case .Glass_Joker: return 51
        case .Showman: return 52
        case .Flower_Pot: return 53
        case .Merry_Andy: return 54
        case .Oops_All_6s: return 55
        case .The_Idol: return 56
        case .Seeing_Double: return 57
        case .Matador: return 58
        case .Stuntman: return 59
        case .Satellite: return 60
        case .Cartomancer: return 61
        case .Astronomer: return 62
        case .Bootstraps: return 63
        }
    }

    var y: Int {
        1
    }

    var type: JokerType {
        return .UNCOMMON
    }
}

enum UnCommonJoker100: String, CaseIterable, Item, Joker {
    case Joker_Stencil = "Joker Stencil"
    case Four_Fingers = "Four Fingers"
    case Mime = "Mime"
    case Ceremonial_Dagger = "Ceremonial Dagger"
    case Marble_Joker = "Marble Joker"
    case Loyalty_Card = "Loyalty Card"
    case Dusk = "Dusk"
    case Fibonacci = "Fibonacci"
    case Steel_Joker = "Steel Joker"
    case Hack = "Hack"
    case Pareidolia = "Pareidolia"
    case Space_Joker = "Space Joker"
    case Burglar = "Burglar"
    case Blackboard = "Blackboard"
    case Constellation = "Constellation"
    case Hiker = "Hiker"
    case Card_Sharp = "Card Sharp"
    case Madness = "Madness"
    case Vampire = "Vampire"
    case Shortcut = "Shortcut"
    case Hologram = "Hologram"
    case Vagabond = "Vagabond"
    case Cloud_9 = "Cloud 9"
    case Rocket = "Rocket"
    case Midas_Mask = "Midas Mask"
    case Luchador = "Luchador"
    case Gift_Card = "Gift Card"
    case Turtle_Bean = "Turtle Bean"
    case Erosion = "Erosion"
    case Reserved_Parking = "Reserved Parking"
    case To_the_Moon = "To the Moon"
    case Stone_Joker = "Stone Joker"
    case Lucky_Cat = "Lucky Cat"
    case Bull = "Bull"
    case Diet_Cola = "Diet Cola"
    case Trading_Card = "Trading Card"
    case Flash_Card = "Flash Card"
    case Spare_Trousers = "Spare Trousers"
    case Ramen = "Ramen"
    case Seltzer = "Seltzer"
    case Castle = "Castle"
    case Mr_Bones = "Mr. Bones"
    case Acrobat = "Acrobat"
    case Sock_and_Buskin = "Sock and Buskin"
    case Troubadour = "Troubadour"
    case Certificate = "Certificate"
    case Smeared_Joker = "Smeared Joker"
    case Throwback = "Throwback"
    case Rough_Gem = "Rough Gem"
    case Bloodstone = "Bloodstone"
    case Arrowhead = "Arrowhead"
    case Onyx_Agate = "Onyx Agate"
    case Glass_Joker = "Glass Joker"
    case Showman = "Showman"
    case Flower_Pot = "Flower Pot"
    case Merry_Andy = "Merry Andy"
    case Oops_All_6s = "Oops! All 6s"
    case The_Idol = "The Idol"
    case Seeing_Double = "Seeing Double"
    case Matador = "Matador"
    case Stuntman = "Stuntman"
    case Satellite = "Satellite"
    case Cartomancer = "Cartomancer"
    case Astronomer = "Astronomer"
    case Burnt_Joker = "Burnt Joker"
    case Bootstraps = "Bootstraps"

    var ordinal: Int {
        switch self {
        case .Joker_Stencil: return 0
        case .Four_Fingers: return 1
        case .Mime: return 2
        case .Ceremonial_Dagger: return 3
        case .Marble_Joker: return 4
        case .Loyalty_Card: return 5
        case .Dusk: return 6
        case .Fibonacci: return 7
        case .Steel_Joker: return 8
        case .Hack: return 9
        case .Pareidolia: return 10
        case .Space_Joker: return 11
        case .Burglar: return 12
        case .Blackboard: return 13
        case .Constellation: return 14
        case .Hiker: return 15
        case .Card_Sharp: return 16
        case .Madness: return 17
        case .Vampire: return 18
        case .Shortcut: return 19
        case .Hologram: return 20
        case .Vagabond: return 21
        case .Cloud_9: return 22
        case .Rocket: return 23
        case .Midas_Mask: return 24
        case .Luchador: return 25
        case .Gift_Card: return 26
        case .Turtle_Bean: return 27
        case .Erosion: return 28
        case .Reserved_Parking: return 29
        case .To_the_Moon: return 30
        case .Stone_Joker: return 31
        case .Lucky_Cat: return 32
        case .Bull: return 33
        case .Diet_Cola: return 34
        case .Trading_Card: return 35
        case .Flash_Card: return 36
        case .Spare_Trousers: return 37
        case .Ramen: return 38
        case .Seltzer: return 39
        case .Castle: return 40
        case .Mr_Bones: return 41
        case .Acrobat: return 42
        case .Sock_and_Buskin: return 43
        case .Troubadour: return 44
        case .Certificate: return 45
        case .Smeared_Joker: return 46
        case .Throwback: return 47
        case .Rough_Gem: return 48
        case .Bloodstone: return 49
        case .Arrowhead: return 50
        case .Onyx_Agate: return 51
        case .Glass_Joker: return 52
        case .Showman: return 53
        case .Flower_Pot: return 54
        case .Merry_Andy: return 55
        case .Oops_All_6s: return 56
        case .The_Idol: return 57
        case .Seeing_Double: return 58
        case .Matador: return 59
        case .Stuntman: return 60
        case .Satellite: return 61
        case .Cartomancer: return 62
        case .Astronomer: return 63
        case .Burnt_Joker: return 64
        case .Bootstraps: return 65
        }
    }

    var y: Int {
        1
    }

    var type: JokerType {
        return .UNCOMMON
    }
}

enum UnCommonJoker: String, CaseIterable, Item, Joker {
    case Joker_Stencil = "Joker Stencil"
    case Four_Fingers = "Four Fingers"
    case Mime = "Mime"
    case Ceremonial_Dagger = "Ceremonial Dagger"
    case Marble_Joker = "Marble Joker"
    case Loyalty_Card = "Loyalty Card"
    case Dusk = "Dusk"
    case Fibonacci = "Fibonacci"
    case Steel_Joker = "Steel Joker"
    case Hack = "Hack"
    case Pareidolia = "Pareidolia"
    case Space_Joker = "Space Joker"
    case Burglar = "Burglar"
    case Blackboard = "Blackboard"
    case Sixth_Sense = "Sixth Sense"
    case Constellation = "Constellation"
    case Hiker = "Hiker"
    case Card_Sharp = "Card Sharp"
    case Madness = "Madness"
    case Seance = "Seance"
    case Vampire = "Vampire"
    case Shortcut = "Shortcut"
    case Hologram = "Hologram"
    case Cloud_9 = "Cloud 9"
    case Rocket = "Rocket"
    case Midas_Mask = "Midas Mask"
    case Luchador = "Luchador"
    case Gift_Card = "Gift Card"
    case Turtle_Bean = "Turtle Bean"
    case Erosion = "Erosion"
    case To_the_Moon = "To the Moon"
    case Stone_Joker = "Stone Joker"
    case Lucky_Cat = "Lucky Cat"
    case Bull = "Bull"
    case Diet_Cola = "Diet Cola"
    case Trading_Card = "Trading Card"
    case Flash_Card = "Flash Card"
    case Spare_Trousers = "Spare Trousers"
    case Ramen = "Ramen"
    case Seltzer = "Seltzer"
    case Castle = "Castle"
    case Mr_Bones = "Mr. Bones"
    case Acrobat = "Acrobat"
    case Sock_and_Buskin = "Sock and Buskin"
    case Troubadour = "Troubadour"
    case Certificate = "Certificate"
    case Smeared_Joker = "Smeared Joker"
    case Throwback = "Throwback"
    case Rough_Gem = "Rough Gem"
    case Bloodstone = "Bloodstone"
    case Arrowhead = "Arrowhead"
    case Onyx_Agate = "Onyx Agate"
    case Glass_Joker = "Glass Joker"
    case Showman = "Showman"
    case Flower_Pot = "Flower Pot"
    case Merry_Andy = "Merry Andy"
    case Oops_All_6s = "Oops! All 6s"
    case The_Idol = "The Idol"
    case Seeing_Double = "Seeing Double"
    case Matador = "Matador"
    case Satellite = "Satellite"
    case Cartomancer = "Cartomancer"
    case Astronomer = "Astronomer"
    case Bootstrap = "Bootstraps"

    var ordinal: Int {
        switch self {
        case .Joker_Stencil: return 0
        case .Four_Fingers: return 1
        case .Mime: return 2
        case .Ceremonial_Dagger: return 3
        case .Marble_Joker: return 4
        case .Loyalty_Card: return 5
        case .Dusk: return 6
        case .Fibonacci: return 7
        case .Steel_Joker: return 8
        case .Hack: return 9
        case .Pareidolia: return 10
        case .Space_Joker: return 11
        case .Burglar: return 12
        case .Blackboard: return 13
        case .Sixth_Sense: return 14
        case .Constellation: return 15
        case .Hiker: return 16
        case .Card_Sharp: return 17
        case .Madness: return 18
        case .Seance: return 19
        case .Vampire: return 20
        case .Shortcut: return 21
        case .Hologram: return 22
        case .Cloud_9: return 23
        case .Rocket: return 24
        case .Midas_Mask: return 25
        case .Luchador: return 26
        case .Gift_Card: return 27
        case .Turtle_Bean: return 28
        case .Erosion: return 29
        case .To_the_Moon: return 30
        case .Stone_Joker: return 31
        case .Lucky_Cat: return 32
        case .Bull: return 33
        case .Diet_Cola: return 34
        case .Trading_Card: return 35
        case .Flash_Card: return 36
        case .Spare_Trousers: return 37
        case .Ramen: return 38
        case .Seltzer: return 39
        case .Castle: return 40
        case .Mr_Bones: return 41
        case .Acrobat: return 42
        case .Sock_and_Buskin: return 43
        case .Troubadour: return 44
        case .Certificate: return 45
        case .Smeared_Joker: return 46
        case .Throwback: return 47
        case .Rough_Gem: return 48
        case .Bloodstone: return 49
        case .Arrowhead: return 50
        case .Onyx_Agate: return 51
        case .Glass_Joker: return 52
        case .Showman: return 53
        case .Flower_Pot: return 54
        case .Merry_Andy: return 55
        case .Oops_All_6s: return 56
        case .The_Idol: return 57
        case .Seeing_Double: return 58
        case .Matador: return 59
        case .Satellite: return 60
        case .Cartomancer: return 61
        case .Astronomer: return 62
        case .Bootstrap: return 63
        }
    }

    var y: Int {
        1
    }

    var type: JokerType {
        return .UNCOMMON
    }
}

enum Tarot: String, CaseIterable, Item {
    case The_Fool = "The Fool"
    case The_Magician = "The Magician"
    case The_High_Priestess = "The High Priestess"
    case The_Empress = "The Empress"
    case The_Emperor = "The Emperor"
    case The_Hierophant = "The Hierophant"
    case The_Lovers = "The Lovers"
    case The_Chariot = "The Chariot"
    case Justice = "Justice"
    case The_Hermit = "The Hermit"
    case The_Wheel_of_Fortune = "The Wheel of Fortune"
    case Strength = "Strength"
    case The_Hanged_Man = "The Hanged Man"
    case Death = "Death"
    case Temperance = "Temperance"
    case The_Devil = "The Devil"
    case The_Tower = "The Tower"
    case The_Star = "The Star"
    case The_Moon = "The Moon"
    case The_Sun = "The Sun"
    case Judgement = "Judgement"
    case The_World = "The World"

    var ordinal: Int {
        switch self {
        case .The_Fool: return 0
        case .The_Magician: return 1
        case .The_High_Priestess: return 2
        case .The_Empress: return 3
        case .The_Emperor: return 4
        case .The_Hierophant: return 5
        case .The_Lovers: return 6
        case .The_Chariot: return 7
        case .Justice: return 8
        case .The_Hermit: return 9
        case .The_Wheel_of_Fortune: return 10
        case .Strength: return 11
        case .The_Hanged_Man: return 12
        case .Death: return 13
        case .Temperance: return 14
        case .The_Devil: return 15
        case .The_Tower: return 16
        case .The_Star: return 17
        case .The_Moon: return 18
        case .The_Sun: return 19
        case .Judgement: return 20
        case .The_World: return 21
        }
    }

    var y: Int {
        4
    }
}

public enum Tag: String, CaseIterable, Item {
    case Uncommon_Tag = "Uncommon"
    case Rare_Tag = "Rare"
    case Negative_Tag = "Negative"
    case Foil_Tag = "Foil"
    case Holographic_Tag = "Holographic"
    case Polychrome_Tag = "Polychrome"
    case Investment_Tag = "Investment"
    case Voucher_Tag = "Voucher"
    case Boss_Tag = "Boss"
    case Standard_Tag = "Standard"
    case Charm_Tag = "Charm"
    case Meteor_Tag = "Meteor"
    case Buffoon_Tag = "Buffoon"
    case Handy_Tag = "Handy"
    case Garbage_Tag = "Garbage"
    case Ethereal_Tag = "Ethereal"
    case Coupon_Tag = "Coupon"
    case Double_Tag = "Double"
    case Juggle_Tag = "Juggle"
    case D6_Tag = "D6"
    case Top_up_Tag = "Top-up"
    case Speed_Tag = "Speed"
    case Orbital_Tag = "Orbital"
    case Economy_Tag = "Economy"

    var ordinal: Int {
        switch self {
        case .Uncommon_Tag: return 0
        case .Rare_Tag: return 1
        case .Negative_Tag: return 2
        case .Foil_Tag: return 3
        case .Holographic_Tag: return 4
        case .Polychrome_Tag: return 5
        case .Investment_Tag: return 6
        case .Voucher_Tag: return 7
        case .Boss_Tag: return 8
        case .Standard_Tag: return 9
        case .Charm_Tag: return 10
        case .Meteor_Tag: return 11
        case .Buffoon_Tag: return 12
        case .Handy_Tag: return 13
        case .Garbage_Tag: return 14
        case .Ethereal_Tag: return 15
        case .Coupon_Tag: return 16
        case .Double_Tag: return 17
        case .Juggle_Tag: return 18
        case .D6_Tag: return 19
        case .Top_up_Tag: return 20
        case .Speed_Tag: return 21
        case .Orbital_Tag: return 22
        case .Economy_Tag: return 23
        }
    }

    var y: Int {
        8
    }
}

enum Spectral: String, CaseIterable, Item {
    case Familiar = "Familiar"
    case Grim = "Grim"
    case Incantation = "Incantation"
    case Talisman = "Talisman"
    case Aura = "Aura"
    case Wraith = "Wraith"
    case Sigil = "Sigil"
    case Ouija = "Ouija"
    case Ectoplasm = "Ectoplasm"
    case Immolate = "Immolate"
    case Ankh = "Ankh"
    case Deja_Vu = "Deja Vu"
    case Hex = "Hex"
    case Trance = "Trance"
    case Medium = "Medium"
    case Cryptid = "Cryptid"
    case RETRY = "RETRY"
    case RETRY2 = "RETRY2"

    var ordinal: Int {
        switch self {
        case .Familiar: return 0
        case .Grim: return 1
        case .Incantation: return 2
        case .Talisman: return 3
        case .Aura: return 4
        case .Wraith: return 5
        case .Sigil: return 6
        case .Ouija: return 7
        case .Ectoplasm: return 8
        case .Immolate: return 9
        case .Ankh: return 10
        case .Deja_Vu: return 11
        case .Hex: return 12
        case .Trance: return 13
        case .Medium: return 14
        case .Cryptid: return 15
        case .RETRY: return 16
        case .RETRY2: return 17
        }
    }

    var y: Int {
        5
    }
}

enum RareJoker101C: String, CaseIterable, Item, Joker {
    case DNA = "DNA"
    case Vampire = "Vampire"
    case Vagabond = "Vagabond"
    case Baron = "Baron"
    case Obelisk = "Obelisk"
    case Baseball_Card = "Baseball Card"
    case Ancient_Joker = "Ancient Joker"
    case Campfire = "Campfire"
    case Blueprint = "Blueprint"
    case Wee_Joker = "Wee Joker"
    case Hit_the_Road = "Hit the Road"
    case The_Duo = "The Duo"
    case The_Trio = "The Trio"
    case The_Family = "The Family"
    case The_Order = "The Order"
    case The_Tribe = "The Tribe"
    case Invisible_Joker = "Invisible Joker"
    case Brainstorm = "Brainstorm"
    case Drivers_License = "Drivers License"
    case Burnt_Joke = "Burnt Joker"

    var ordinal: Int {
        switch self {
        case .DNA: return 0
        case .Vampire: return 1
        case .Vagabond: return 2
        case .Baron: return 3
        case .Obelisk: return 4
        case .Baseball_Card: return 5
        case .Ancient_Joker: return 6
        case .Campfire: return 7
        case .Blueprint: return 8
        case .Wee_Joker: return 9
        case .Hit_the_Road: return 10
        case .The_Duo: return 11
        case .The_Trio: return 12
        case .The_Family: return 13
        case .The_Order: return 14
        case .The_Tribe: return 15
        case .Invisible_Joker: return 16
        case .Brainstorm: return 17
        case .Drivers_License: return 18
        case .Burnt_Joke: return 19
        }
    }

    var y: Int {
        2
    }

    var type: JokerType {
        return .RARE
    }
}

enum RareJoker100: String, CaseIterable, Item, Joker {
    case DNA = "DNA"
    case Sixth_Sense = "Sixth Sense"
    case Seance = "Seance"
    case Baron = "Baron"
    case Obelisk = "Obelisk"
    case Baseball_Card = "Baseball Card"
    case Ancient_Joker = "Ancient Joker"
    case Campfire = "Campfire"
    case Blueprint = "Blueprint"
    case Wee_Joker = "Wee Joker"
    case Hit_the_Road = "Hit the Road"
    case The_Duo = "The Duo"
    case The_Trio = "The Trio"
    case The_Family = "The Family"
    case The_Order = "The Order"
    case The_Tribe = "The Tribe"
    case Invisible_Joker = "Invisible Joker"
    case Brainstorm = "Brainstorm"
    case Drivers_License = "Drivers Licens"

    var ordinal: Int {
        switch self {
        case .DNA: return 0
        case .Sixth_Sense: return 1
        case .Seance: return 2
        case .Baron: return 3
        case .Obelisk: return 4
        case .Baseball_Card: return 5
        case .Ancient_Joker: return 6
        case .Campfire: return 7
        case .Blueprint: return 8
        case .Wee_Joker: return 9
        case .Hit_the_Road: return 10
        case .The_Duo: return 11
        case .The_Trio: return 12
        case .The_Family: return 13
        case .The_Order: return 14
        case .The_Tribe: return 15
        case .Invisible_Joker: return 16
        case .Brainstorm: return 17
        case .Drivers_License: return 18
        }
    }

    var y: Int {
        2
    }

    var type: JokerType {
        return .RARE
    }
}

enum RareJoker: String, CaseIterable, Item, Joker {
    case DNA = "DNA"
    case Vagabond = "Vagabond"
    case Baron = "Baron"
    case Obelisk = "Obelisk"
    case Baseball_Card = "Baseball Card"
    case Ancient_Joker = "Ancient Joker"
    case Campfire = "Campfire"
    case Blueprint = "Blueprint"
    case Wee_Joker = "Wee Joker"
    case Hit_the_Road = "Hit the Road"
    case The_Duo = "The Duo"
    case The_Trio = "The Trio"
    case The_Family = "The Family"
    case The_Order = "The Order"
    case The_Tribe = "The Tribe"
    case Stuntman = "Stuntman"
    case Invisible_Joker = "Invisible Joker"
    case Brainstorm = "Brainstorm"
    case Drivers_License = "Drivers License"
    case Burnt_Joke = "Burnt Joker"

    var ordinal: Int {
        switch self {
        case .DNA: return 0
        case .Vagabond: return 1
        case .Baron: return 2
        case .Obelisk: return 3
        case .Baseball_Card: return 4
        case .Ancient_Joker: return 5
        case .Campfire: return 6
        case .Blueprint: return 7
        case .Wee_Joker: return 8
        case .Hit_the_Road: return 9
        case .The_Duo: return 10
        case .The_Trio: return 11
        case .The_Family: return 12
        case .The_Order: return 13
        case .The_Tribe: return 14
        case .Stuntman: return 15
        case .Invisible_Joker: return 16
        case .Brainstorm: return 17
        case .Drivers_License: return 18
        case .Burnt_Joke: return 19
        }
    }

    var y: Int {
        2
    }

    var type: JokerType {
        return .RARE
    }
}

enum Planet: String, CaseIterable, Item {
    case Mercury = "Mercury"
    case Venus = "Venus"
    case Earth = "Earth"
    case Mars = "Mars"
    case Jupiter = "Jupiter"
    case Saturn = "Saturn"
    case Uranus = "Uranus"
    case Neptune = "Neptune"
    case Pluto = "Pluto"
    case Planet_X = "Planet X"
    case Ceres = "Ceres"
    case Eri = "Eris"

    var ordinal: Int {
        switch self {
        case .Mercury: return 0
        case .Venus: return 1
        case .Earth: return 2
        case .Mars: return 3
        case .Jupiter: return 4
        case .Saturn: return 5
        case .Uranus: return 6
        case .Neptune: return 7
        case .Pluto: return 8
        case .Planet_X: return 9
        case .Ceres: return 10
        case .Eri: return 11
        }
    }

    var y: Int {
        3
    }
}

enum LegendaryJoker: String, CaseIterable, Item, Joker {
    case Canio = "Canio"
    case Triboulet = "Triboulet"
    case Yorick = "Yorick"
    case Chicot = "Chicot"
    case Perkeo = "Perkeo"

    var ordinal: Int {
        switch self {
        case .Canio: return 0
        case .Triboulet: return 1
        case .Yorick: return 2
        case .Chicot: return 3
        case .Perkeo: return 4
        }
    }

    var y: Int {
        10
    }

    var type: JokerType {
        return .LEGENDARY
    }
}

enum Enhancement: String, CaseIterable, Item {
    case Bonus = "Bonus"
    case Mult = "Mult"
    case Wild = "Wild"
    case Glass = "Glass"
    case Steel = "Steel"
    case Stone = "Stone"
    case Gold = "Gold"
    case Luck = "Lucky"

    var ordinal: Int {
        0
    }

    var y: Int {
        0
    }
}

enum Deck: String, CaseIterable, Item {
    case RED_DECK = "Red Deck"
    case BLUE_DECK = "Blue Deck"
    case YELLOW_DECK = "Yellow Deck"
    case GREEN_DECK = "Green Deck"
    case BLACK_DECK = "Black Deck"
    case MAGIC_DECK = "Magic Deck"
    case NEBULA_DECK = "Nebula Deck"
    case GHOST_DECK = "Ghost Deck"
    case ABANDONED_DECK = "Abandoned Deck"
    case CHECKERED_DECK = "Checkered Deck"
    case ZODIAC_DECK = "Zodiac Deck"
    case PAINTED_DECK = "Painted Deck"
    case ANAGLYPH_DECK = "Anaglyph Deck"
    case PLASMA_DECK = "Plasma Deck"
    case ERRATIC_DECK = "Erratic Deck"

    var ordinal: Int {
        0
    }

    var y: Int {
        0
    }
}

enum CommonJoker100: String, CaseIterable, Item, Joker {
    case Joker = "Joker"
    case Greedy_Joker = "Greedy Joker"
    case Lusty_Joker = "Lusty Joker"
    case Wrathful_Joker = "Wrathful Joker"
    case Gluttonous_Joker = "Gluttonous Joker"
    case Jolly_Joker = "Jolly Joker"
    case Zany_Joker = "Zany Joker"
    case Mad_Joker = "Mad Joker"
    case Crazy_Joker = "Crazy Joker"
    case Droll_Joker = "Droll Joker"
    case Sly_Joker = "Sly Joker"
    case Wily_Joker = "Wily Joker"
    case Clever_Joker = "Clever Joker"
    case Devious_Joker = "Devious Joker"
    case Crafty_Joker = "Crafty Joker"
    case Half_Joker = "Half Joker"
    case Credit_Card = "Credit Card"
    case Banner = "Banner"
    case Mystic_Summit = "Mystic Summit"
    case Ball = "8 Ball"
    case Misprint = "Misprint"
    case Raised_Fist = "Raised Fist"
    case Chaos_the_Clown = "Chaos the Clown"
    case Scary_Face = "Scary Face"
    case Abstract_Joker = "Abstract Joker"
    case Delayed_Gratification = "Delayed Gratification"
    case Gros_Michel = "Gros Michel"
    case Even_Steven = "Even Steven"
    case Odd_Todd = "Odd Todd"
    case Scholar = "Scholar"
    case Business_Card = "Business Card"
    case Supernova = "Supernova"
    case Ride_the_Bus = "Ride the Bus"
    case Egg = "Egg"
    case Runner = "Runner"
    case Ice_Cream = "Ice Cream"
    case Splash = "Splash"
    case Blue_Joker = "Blue Joker"
    case Faceless_Joker = "Faceless Joker"
    case Green_Joker = "Green Joker"
    case Superposition = "Superposition"
    case To_Do_List = "To Do List"
    case Cavendish = "Cavendish"
    case Red_Card = "Red Card"
    case Square_Joker = "Square Joker"
    case Riff_raff = "Riff-raff"
    case Photograph = "Photograph"
    case Mail_In_Rebate = "Mail In Rebate"
    case Hallucination = "Hallucination"
    case Fortune_Teller = "Fortune Teller"
    case Juggler = "Juggler"
    case Drunkard = "Drunkard"
    case Golden_Joker = "Golden Joker"
    case Popcorn = "Popcorn"
    case Walkie_Talkie = "Walkie Talkie"
    case Smiley_Face = "Smiley Face"
    case Golden_Ticket = "Golden Ticket"
    case Swashbuckler = "Swashbuckler"
    case Hanging_Chad = "Hanging Chad"
    case Shoot_the_Moon = "Shoot the Moon"

    var ordinal: Int {
        switch self {
        case .Joker: return 0
        case .Greedy_Joker: return 1
        case .Lusty_Joker: return 2
        case .Wrathful_Joker: return 3
        case .Gluttonous_Joker: return 4
        case .Jolly_Joker: return 5
        case .Zany_Joker: return 6
        case .Mad_Joker: return 7
        case .Crazy_Joker: return 8
        case .Droll_Joker: return 9
        case .Sly_Joker: return 10
        case .Wily_Joker: return 11
        case .Clever_Joker: return 12
        case .Devious_Joker: return 13
        case .Crafty_Joker: return 14
        case .Half_Joker: return 15
        case .Credit_Card: return 16
        case .Banner: return 17
        case .Mystic_Summit: return 18
        case .Ball: return 19
        case .Misprint: return 20
        case .Raised_Fist: return 21
        case .Chaos_the_Clown: return 22
        case .Scary_Face: return 23
        case .Abstract_Joker: return 24
        case .Delayed_Gratification: return 25
        case .Gros_Michel: return 26
        case .Even_Steven: return 27
        case .Odd_Todd: return 28
        case .Scholar: return 29
        case .Business_Card: return 30
        case .Supernova: return 31
        case .Ride_the_Bus: return 32
        case .Egg: return 33
        case .Runner: return 34
        case .Ice_Cream: return 35
        case .Splash: return 36
        case .Blue_Joker: return 37
        case .Faceless_Joker: return 38
        case .Green_Joker: return 39
        case .Superposition: return 40
        case .To_Do_List: return 41
        case .Cavendish: return 42
        case .Red_Card: return 43
        case .Square_Joker: return 44
        case .Riff_raff: return 45
        case .Photograph: return 46
        case .Mail_In_Rebate: return 47
        case .Hallucination: return 48
        case .Fortune_Teller: return 49
        case .Juggler: return 50
        case .Drunkard: return 51
        case .Golden_Joker: return 52
        case .Popcorn: return 53
        case .Walkie_Talkie: return 54
        case .Smiley_Face: return 55
        case .Golden_Ticket: return 56
        case .Swashbuckler: return 57
        case .Hanging_Chad: return 58
        case .Shoot_the_Moon: return 59
        }
    }

    var y: Int {
        return 0
    }

    var type: JokerType {
        return .COMMO
    }
}

enum CommonJoker: String, CaseIterable, Item, Joker {
    case Joker = "Joker"
    case Greedy_Joker = "Greedy Joker"
    case Lusty_Joker = "Lusty Joker"
    case Wrathful_Joker = "Wrathful Joker"
    case Gluttonous_Joker = "Gluttonous Joker"
    case Jolly_Joker = "Jolly Joker"
    case Zany_Joker = "Zany Joker"
    case Mad_Joker = "Mad Joker"
    case Crazy_Joker = "Crazy Joker"
    case Droll_Joker = "Droll Joker"
    case Sly_Joker = "Sly Joker"
    case Wily_Joker = "Wily Joker"
    case Clever_Joker = "Clever Joker"
    case Devious_Joker = "Devious Joker"
    case Crafty_Joker = "Crafty Joker"
    case Half_Joker = "Half Joker"
    case Credit_Card = "Credit Card"
    case Banner = "Banner"
    case Mystic_Summit = "Mystic Summit"
    case Ball = "8 Ball"
    case Misprint = "Misprint"
    case Raised_Fist = "Raised Fist"
    case Chaos_the_Clown = "Chaos the Clown"
    case Scary_Face = "Scary Face"
    case Abstract_Joker = "Abstract Joker"
    case Delayed_Gratification = "Delayed Gratification"
    case Gros_Michel = "Gros Michel"
    case Even_Steven = "Even Steven"
    case Odd_Todd = "Odd Todd"
    case Scholar = "Scholar"
    case Business_Card = "Business Card"
    case Supernova = "Supernova"
    case Ride_the_Bus = "Ride the Bus"
    case Egg = "Egg"
    case Runner = "Runner"
    case Ice_Cream = "Ice Cream"
    case Splash = "Splash"
    case Blue_Joker = "Blue Joker"
    case Faceless_Joker = "Faceless Joker"
    case Green_Joker = "Green Joker"
    case Superposition = "Superposition"
    case To_Do_List = "To Do List"
    case Cavendish = "Cavendish"
    case Red_Card = "Red Card"
    case Square_Joker = "Square Joker"
    case Riffraff = "Riff-raff"
    case Photograph = "Photograph"
    case Reserved_Parking = "Reserved Parking"
    case Mail_In_Rebate = "Mail In Rebate"
    case Hallucination = "Hallucination"
    case Fortune_Teller = "Fortune Teller"
    case Juggler = "Juggler"
    case Drunkard = "Drunkard"
    case Golden_Joker = "Golden Joker"
    case Popcorn = "Popcorn"
    case Walkie_Talkie = "Walkie Talkie"
    case Smiley_Face = "Smiley Face"
    case Golden_Ticket = "Golden Ticket"
    case Swashbuckler = "Swashbuckler"
    case Hanging_Chad = "Hanging Chad"
    case Shoot_the_Moo = "Shoot the Moon"

    var ordinal: Int {
        switch self {
        case .Joker: return 0
        case .Greedy_Joker: return 1
        case .Lusty_Joker: return 2
        case .Wrathful_Joker: return 3
        case .Gluttonous_Joker: return 4
        case .Jolly_Joker: return 5
        case .Zany_Joker: return 6
        case .Mad_Joker: return 7
        case .Crazy_Joker: return 8
        case .Droll_Joker: return 9
        case .Sly_Joker: return 10
        case .Wily_Joker: return 11
        case .Clever_Joker: return 12
        case .Devious_Joker: return 13
        case .Crafty_Joker: return 14
        case .Half_Joker: return 15
        case .Credit_Card: return 16
        case .Banner: return 17
        case .Mystic_Summit: return 18
        case .Ball: return 19
        case .Misprint: return 20
        case .Raised_Fist: return 21
        case .Chaos_the_Clown: return 22
        case .Scary_Face: return 23
        case .Abstract_Joker: return 24
        case .Delayed_Gratification: return 25
        case .Gros_Michel: return 26
        case .Even_Steven: return 27
        case .Odd_Todd: return 28
        case .Scholar: return 29
        case .Business_Card: return 30
        case .Supernova: return 31
        case .Ride_the_Bus: return 32
        case .Egg: return 33
        case .Runner: return 34
        case .Ice_Cream: return 35
        case .Splash: return 36
        case .Blue_Joker: return 37
        case .Faceless_Joker: return 38
        case .Green_Joker: return 39
        case .Superposition: return 40
        case .To_Do_List: return 41
        case .Cavendish: return 42
        case .Red_Card: return 43
        case .Square_Joker: return 44
        case .Riffraff: return 45
        case .Photograph: return 46
        case .Reserved_Parking: return 47
        case .Mail_In_Rebate: return 48
        case .Hallucination: return 49
        case .Fortune_Teller: return 50
        case .Juggler: return 51
        case .Drunkard: return 52
        case .Golden_Joker: return 53
        case .Popcorn: return 54
        case .Walkie_Talkie: return 55
        case .Smiley_Face: return 56
        case .Golden_Ticket: return 57
        case .Swashbuckler: return 58
        case .Hanging_Chad: return 59
        case .Shoot_the_Moo: return 60
        }
    }

    var y: Int {
        return 0
    }

    var type: JokerType {
        return .COMMO
    }
}

enum Packs: String, CaseIterable, Item {
    case RETRY = "RETRY"
    case Arcana_Pack = "Arcana Pack"
    case Jumbo_Arcana_Pack = "Jumbo Arcana Pack"
    case Mega_Arcana_Pack = "Mega Arcana Pack"
    case Celestial_Pack = "Celestial Pack"
    case Jumbo_Celestial_Pack = "Jumbo Celestial Pack"
    case Mega_Celestial_Pack = "Mega Celestial Pack"
    case Standard_Pack = "Standard Pack"
    case Jumbo_Standard_Pack = "Jumbo Standard Pack"
    case Mega_Standard_Pack = "Mega Standard Pack"
    case Buffoon_Pack = "Buffoon Pack"
    case Jumbo_Buffoon_Pack = "Jumbo Buffoon Pack"
    case Mega_Buffoon_Pack = "Mega Buffoon Pack"
    case Spectral_Pack = "Spectral Pack"
    case Jumbo_Spectral_Pack = "Jumbo Spectral Pack"
    case Mega_Spectral_Pack = "Mega Spectral Pack"

    var value: Double {
        switch self {
        case .RETRY: return 22.42
        case .Arcana_Pack: return 4
        case .Jumbo_Arcana_Pack: return 2
        case .Mega_Arcana_Pack: return 0.5
        case .Celestial_Pack: return 4
        case .Jumbo_Celestial_Pack: return 2
        case .Mega_Celestial_Pack: return 0.5
        case .Standard_Pack: return 4
        case .Jumbo_Standard_Pack: return 2
        case .Mega_Standard_Pack: return 0.5
        case .Buffoon_Pack: return 1.2
        case .Jumbo_Buffoon_Pack: return 0.6
        case .Mega_Buffoon_Pack: return 0.15
        case .Spectral_Pack: return 0.6
        case .Jumbo_Spectral_Pack: return 0.3
        case .Mega_Spectral_Pack: return 0.07
        }
    }

    var ordinal: Int {
        switch self {
        case .RETRY: return 0
        case .Arcana_Pack: return 1
        case .Jumbo_Arcana_Pack: return 2
        case .Mega_Arcana_Pack: return 3
        case .Celestial_Pack: return 4
        case .Jumbo_Celestial_Pack: return 5
        case .Mega_Celestial_Pack: return 6
        case .Standard_Pack: return 7
        case .Jumbo_Standard_Pack: return 8
        case .Mega_Standard_Pack: return 9
        case .Buffoon_Pack: return 10
        case .Jumbo_Buffoon_Pack: return 11
        case .Mega_Buffoon_Pack: return 12
        case .Spectral_Pack: return 13
        case .Jumbo_Spectral_Pack: return 14
        case .Mega_Spectral_Pack: return 15
        }
    }

    var y: Int {
        return -1
    }

}

enum Cards: String, CaseIterable, Item {
    case C_2 = "C_2"
    case C_3 = "C_3"
    case C_4 = "C_4"
    case C_5 = "C_5"
    case C_6 = "C_6"
    case C_7 = "C_7"
    case C_8 = "C_8"
    case C_9 = "C_9"
    case C_A = "C_A"
    case C_J = "C_J"
    case C_K = "C_K"
    case C_Q = "C_Q"
    case C_T = "C_T"
    case D_2 = "D_2"
    case D_3 = "D_3"
    case D_4 = "D_4"
    case D_5 = "D_5"
    case D_6 = "D_6"
    case D_7 = "D_7"
    case D_8 = "D_8"
    case D_9 = "D_9"
    case D_A = "D_A"
    case D_J = "D_J"
    case D_K = "D_K"
    case D_Q = "D_Q"
    case D_T = "D_T"
    case H_2 = "H_2"
    case H_3 = "H_3"
    case H_4 = "H_4"
    case H_5 = "H_5"
    case H_6 = "H_6"
    case H_7 = "H_7"
    case H_8 = "H_8"
    case H_9 = "H_9"
    case H_A = "H_A"
    case H_J = "H_J"
    case H_K = "H_K"
    case H_Q = "H_Q"
    case H_T = "H_T"
    case S_2 = "S_2"
    case S_3 = "S_3"
    case S_4 = "S_4"
    case S_5 = "S_5"
    case S_6 = "S_6"
    case S_7 = "S_7"
    case S_8 = "S_8"
    case S_9 = "S_9"
    case S_A = "S_A"
    case S_J = "S_J"
    case S_K = "S_K"
    case S_Q = "S_Q"
    case S_T = "S_T"

    var ordinal: Int {
        return 0
    }

    var y: Int {
        return 0
    }
}

enum Boss: String, CaseIterable, Item {
    case The_Arm = "The Arm"
    case The_Club = "The Club"
    case The_Eye = "The Eye"
    case Amber_Acorn = "Amber Acorn"
    case Cerulean_Bell = "Cerulean Bell"
    case Crimson_Heart = "Crimson Heart"
    case Verdant_Leaf = "Verdant Leaf"
    case Violet_Vessel = "Violet Vessel"
    case The_Fish = "The Fish"
    case The_Flint = "The Flint"
    case The_Goad = "The Goad"
    case The_Head = "The Head"
    case The_Hook = "The Hook"
    case The_House = "The House"
    case The_Manacle = "The Manacle"
    case The_Mark = "The Mark"
    case The_Mouth = "The Mouth"
    case The_Needle = "The Needle"
    case The_Ox = "The Ox"
    case The_Pillar = "The Pillar"
    case The_Plant = "The Plant"
    case The_Psychic = "The Psychic"
    case The_Serpent = "The Serpent"
    case The_Tooth = "The Tooth"
    case The_Wall = "The Wall"
    case The_Water = "The Water"
    case The_Wheel = "The Wheel"
    case The_Windo = "The Window"

    var y: Int {
        6
    }

    var startsWithT: Bool {
        switch self {
        case .The_Arm: return true
        case .The_Club: return true
        case .The_Eye: return true
        case .The_Fish: return true
        case .The_Flint: return true
        case .The_Goad: return true
        case .The_Head: return true
        case .The_Hook: return true
        case .The_House: return true
        case .The_Manacle: return true
        case .The_Mark: return true
        case .The_Mouth: return true
        case .The_Needle: return true
        case .The_Ox: return true
        case .The_Pillar: return true
        case .The_Plant: return true
        case .The_Psychic: return true
        case .The_Serpent: return true
        case .The_Tooth: return true
        case .The_Wall: return true
        case .The_Water: return true
        case .The_Wheel: return true
        case .The_Windo: return true
        default: return false

        }
    }

    var ordinal: Int {
        switch self {
        case .The_Arm:
            return 0
        case .The_Club:
            return 1
        case .The_Eye:
            return 2
        case .Amber_Acorn:
            return 3
        case .Cerulean_Bell:
            return 4
        case .Crimson_Heart:
            return 5
        case .Verdant_Leaf:
            return 6
        case .Violet_Vessel:
            return 7
        case .The_Fish:
            return 8
        case .The_Flint:
            return 9
        case .The_Goad:
            return 10
        case .The_Head:
            return 11
        case .The_Hook:
            return 12
        case .The_House:
            return 13
        case .The_Manacle:
            return 14
        case .The_Mark:
            return 15
        case .The_Mouth:
            return 16
        case .The_Needle:
            return 17
        case .The_Ox:
            return 18
        case .The_Pillar:
            return 19
        case .The_Plant:
            return 20
        case .The_Psychic:
            return 21
        case .The_Serpent:
            return 22
        case .The_Tooth:
            return 23
        case .The_Wall:
            return 24
        case .The_Water:
            return 25
        case .The_Wheel:
            return 26
        case .The_Windo:
            return 27
        }
    }
}

enum Suit: String, CaseIterable, Item {
    case Hearts = "Hearts"
    case Clubs = "Clubs"
    case Diamonds = "Diamonds"
    case Spades = "Spades"

    func index() -> Int {
        switch self {
        case .Hearts: return 0
        case .Clubs: return 1
        case .Diamonds: return 2
        case .Spades: return 3
        }
    }

    var ordinal: Int {
        switch self {
        case .Hearts:
            return 0
        case .Clubs:
            return 1
        case .Diamonds:
            return 2
        case .Spades:
            return 3
        }
    }

    var y: Int {
        return -1
    }
}

enum Rank: String, CaseIterable, Item {
    case r_2 = "2"
    case r_3 = "3"
    case r_4 = "4"
    case r_5 = "5"
    case r_6 = "6"
    case r_7 = "7"
    case r_8 = "8"
    case r_9 = "9"
    case r_10 = "10"
    case Jack = "J"
    case Queen = "Q"
    case King = "K"
    case Ace = "A"

    func index() -> Int {
        switch self {
        case .r_2: return 0
        case .r_3: return 1
        case .r_4: return 2
        case .r_5: return 3
        case .r_6: return 4
        case .r_7: return 5
        case .r_8: return 6
        case .r_9: return 7
        case .r_10: return 8
        case .Jack: return 9
        case .Queen: return 10
        case .King: return 11
        case .Ace: return 12
        }
    }

    var ordinal: Int {
        0
    }

    var y: Int {
        0
    }
}

