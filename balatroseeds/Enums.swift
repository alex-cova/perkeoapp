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

protocol Item : Encodable {
    var rawValue: String { get }
}

protocol Joker {
    
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
        return self == .Mega_Arcana_Pack || self == .Mega_Celestial_Pack || self == .Mega_Standard_Pack ||
        self == .Mega_Buffoon_Pack || self == .Mega_Spectral_Pack
    }
    
    var isJumbo: Bool {
        return self == .Jumbo_Arcana_Pack || self == .Jumbo_Celestial_Pack || self == .Jumbo_Standard_Pack ||
        self == .Jumbo_Buffoon_Pack || self == .Jumbo_Spectral_Pack
    }
    
    var isBuffoon: Bool {
        return self == .Buffoon_Pack || self == .Jumbo_Buffoon_Pack || self == .Mega_Buffoon_Pack
    }
    
    var isSpectral: Bool {
        return self == .Spectral_Pack || self == .Jumbo_Spectral_Pack || self == .Mega_Spectral_Pack
    }
}

enum Seal : String, CaseIterable, Item {
    case NoSeal = "No Seal"
    case RedSeal = "Red Seal"
    case BlueSeal = "Blue Seal"
    case GoldSeal = "Gold Seal"
    case PurpleSeal = "Purple Seal"
}

enum Edition : String, CaseIterable, Item {
    case Negative = "Negative"
    case Polychrome = "Polychrome"
    case Holographic = "Holographic"
    case Foil = "Foil"
    case NoEdition = "No Edition"
    case Eternal = "Eternal"
    case Perishable = "Perishable"
    case Rental = "Rental"
}

enum ItemType : String, CaseIterable, Item {
    case Joker = "Joker"
    case Tarot = "Tarot"
    case Planet = "Planet"
    case Spectral = "Spectral"
    case PlayingCard = "Playing Card"
}

enum Stake : String, CaseIterable, Item {
    case White_Stake = "White Stake"
    case Red_Stake = "Red Stake"
    case Green_Stake = "Green Stake"
    case Black_Stake = "Black Stake"
    case Blue_Stake = "Blue Stake"
    case Purple_Stake = "Purple Stake"
    case Orange_Stake = "Orange Stake"
    case Gold_Stake = "Gold Stake"
}

enum Specials : String, CaseIterable, Item {
    case BLACKHOLE = "Black Hole"
    case THE_SHOUL = "The Soul"
    case RETRY = "RETRY"
}

enum Voucher : String, CaseIterable, Item {
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
}

enum Version : Int, CaseIterable {
    case v_100n = 10014
    case v_101c = 10103
    case v_101f = 10106
}

enum UnCommonJoker101C : String, CaseIterable , Item, Joker {
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
}

enum UnCommonJoker100 : String, CaseIterable, Item, Joker {
    case Joker_Stencil  = "Joker Stencil"
    case Four_Fingers  = "Four Fingers"
    case Mime  = "Mime"
    case Ceremonial_Dagger  = "Ceremonial Dagger"
    case Marble_Joker  = "Marble Joker"
    case Loyalty_Card  = "Loyalty Card"
    case Dusk  = "Dusk"
    case Fibonacci  = "Fibonacci"
    case Steel_Joker  = "Steel Joker"
    case Hack  = "Hack"
    case Pareidolia  = "Pareidolia"
    case Space_Joker  = "Space Joker"
    case Burglar  = "Burglar"
    case Blackboard  = "Blackboard"
    case Constellation  = "Constellation"
    case Hiker  = "Hiker"
    case Card_Sharp  = "Card Sharp"
    case Madness  = "Madness"
    case Vampire  = "Vampire"
    case Shortcut  = "Shortcut"
    case Hologram  = "Hologram"
    case Vagabond  = "Vagabond"
    case Cloud_9  = "Cloud 9"
    case Rocket  = "Rocket"
    case Midas_Mask  = "Midas Mask"
    case Luchador  = "Luchador"
    case Gift_Card  = "Gift Card"
    case Turtle_Bean  = "Turtle Bean"
    case Erosion  = "Erosion"
    case Reserved_Parking  = "Reserved Parking"
    case To_the_Moon  = "To the Moon"
    case Stone_Joker  = "Stone Joker"
    case Lucky_Cat  = "Lucky Cat"
    case Bull  = "Bull"
    case Diet_Cola  = "Diet Cola"
    case Trading_Card  = "Trading Card"
    case Flash_Card  = "Flash Card"
    case Spare_Trousers  = "Spare Trousers"
    case Ramen  = "Ramen"
    case Seltzer  = "Seltzer"
    case Castle  = "Castle"
    case Mr_Bones  = "Mr. Bones"
    case Acrobat  = "Acrobat"
    case Sock_and_Buskin  = "Sock and Buskin"
    case Troubadour  = "Troubadour"
    case Certificate  = "Certificate"
    case Smeared_Joker  = "Smeared Joker"
    case Throwback  = "Throwback"
    case Rough_Gem  = "Rough Gem"
    case Bloodstone  = "Bloodstone"
    case Arrowhead  = "Arrowhead"
    case Onyx_Agate  = "Onyx Agate"
    case Glass_Joker  = "Glass Joker"
    case Showman  = "Showman"
    case Flower_Pot  = "Flower Pot"
    case Merry_Andy  = "Merry Andy"
    case Oops_All_6s  = "Oops! All 6s"
    case The_Idol  = "The Idol"
    case Seeing_Double  = "Seeing Double"
    case Matador  = "Matador"
    case Stuntman  = "Stuntman"
    case Satellite  = "Satellite"
    case Cartomancer  = "Cartomancer"
    case Astronomer  = "Astronomer"
    case Burnt_Joker  = "Burnt Joker"
    case Bootstraps  = "Bootstraps"
}


enum UnCommonJoker : String, CaseIterable, Item, Joker {
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
}

enum Tarot : String, CaseIterable, Item {
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
}

enum Tag : String, CaseIterable, Item {
    case Uncommon_Tag = "Uncommon Tag"
    case Rare_Tag = "Rare Tag"
    case Negative_Tag = "Negative Tag"
    case Foil_Tag = "Foil Tag"
    case Holographic_Tag = "Holographic Tag"
    case Polychrome_Tag = "Polychrome Tag"
    case Investment_Tag = "Investment Tag"
    case Voucher_Tag = "Voucher Tag"
    case Boss_Tag = "Boss Tag"
    case Standard_Tag = "Standard Tag"
    case Charm_Tag = "Charm Tag"
    case Meteor_Tag = "Meteor Tag"
    case Buffoon_Tag = "Buffoon Tag"
    case Handy_Tag = "Handy Tag"
    case Garbage_Tag = "Garbage Tag"
    case Ethereal_Tag = "Ethereal Tag"
    case Coupon_Tag = "Coupon Tag"
    case Double_Tag = "Double Tag"
    case Juggle_Tag = "Juggle Tag"
    case D6_Tag = "D6 Tag"
    case Top_up_Tag = "Top-up Tag"
    case Speed_Tag = "Speed Tag"
    case Orbital_Tag = "Orbital Tag"
    case Economy_Tag = "Economy Tag"
    
    
}

enum Spectral : String, CaseIterable, Item {
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
}

enum RareJoker101C : String, CaseIterable, Item, Joker {
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
}

enum RareJoker100 : String, CaseIterable, Item, Joker {
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
}

enum RareJoker : String, CaseIterable, Item, Joker {
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
    
}

enum Planet : String, CaseIterable, Item {
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
}

enum LegendaryJoker : String, CaseIterable, Item, Joker {
    case Canio = "Canio"
    case Triboulet = "Triboulet"
    case Yorick = "Yorick"
    case Chicot = "Chicot"
    case Perke = "Perkeo"
}

enum Enhancement : String, CaseIterable, Item {
    case Bonus = "Bonus"
    case Mult = "Mult"
    case Wild = "Wild"
    case Glass = "Glass"
    case Steel = "Steel"
    case Stone = "Stone"
    case Gold = "Gold"
    case Luck = "Lucky"
}

enum Deck : String, CaseIterable, Item {
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
}

enum CommonJoker100 : String, CaseIterable, Item, Joker {
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
}

enum CommonJoker : String, CaseIterable, Item, Joker {
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
}

enum Cards : String, CaseIterable, Item {
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
}

enum Boss : String, CaseIterable, Item {
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
    
}


enum Suit: String, CaseIterable, Item {
    case Hearts = "Hearts", Clubs = "Clubs", Diamonds = "Diamonds", Spades = "Spades"
    
    func index() -> Int {
        switch(self) {
        case .Hearts: return 0
        case .Clubs: return 1
        case .Diamonds: return 2
        case .Spades: return 3
        }
    }
}

enum Rank : String, CaseIterable, Item {
    case r_2 = "2", r_3 = "3", r_4 = "4", r_5 = "5", r_6 = "6", r_7 = "7", r_8 = "8", r_9 = "9", r_10 = "10"
    case Jack = "J", Queen = "Q", King = "K", Ace = "A"
    
    func index() -> Int {
        switch(self) {
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
}
