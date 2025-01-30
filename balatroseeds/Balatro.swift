//
//  Balatro.swift
//  balatroseeds
//
//  Created by Alex on 03/01/25.
//

class StringBuilder {
    var base = ""
    
    func append(_ string: Any) -> StringBuilder {
        base += "\(string)"
        return self
    }
    
    func append(_ char : Character) -> StringBuilder {
        base += String(char)
        return self
    }
    
    func append(_ int : Int) -> StringBuilder {
        base += String(int)
        return self
    }
    
    func toString() -> String {
        base
    }
}

public class Balatro {
    
    let options = [
        "Negative Tag",
        "Foil Tag",
        "Holographic Tag",
        "Polychrome Tag",
        "Rare Tag",
        "Golden Ticket",
        "Mr. Bones",
        "Acrobat",
        "Sock and Buskin",
        "Swashbuckler",
        "Troubadour",
        "Certificate",
        "Smeared Joker",
        "Throwback",
        "Hanging Chad",
        "Rough Gem",
        "Bloodstone",
        "Arrowhead",
        "Onyx Agate",
        "Glass Joker",
        "Showman",
        "Flower Pot",
        "Blueprint",
        "Wee Joker",
        "Merry Andy",
        "Oops! All 6s",
        "The Idol",
        "Seeing Double",
        "Matador",
        "Hit the Road",
        "The Duo",
        "The Trio",
        "The Family",
        "The Order",
        "The Tribe",
        "Stuntman",
        "Invisible Joker",
        "Brainstorm",
        "Satellite",
        "Shoot the Moon",
        "Driver's License",
        "Cartomancer",
        "Astronomer",
        "Burnt Joker",
        "Bootstraps",
        "Overstock Plus",
        "Liquidation",
        "Glow Up",
        "Reroll Glut",
        "Omen Globe",
        "Observatory",
        "Nacho Tong",
        "Recyclomancy",
        "Tarot Tycoon",
        "Planet Tycoon",
        "Money Tree",
        "Antimatter",
        "Illusion",
        "Petroglyph",
        "Retcon",
        "Palette"
    ]
    
    static let CHARACTERS = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    static func generateRandomString() -> String {
        let result =  StringBuilder()
        
        for _ in 0..<7 {
            let index = Int.random(in: 0..<CHARACTERS.count);
            _ = result.append(CHARACTERS.charAt(index));
        }
        return result.toString();
    }
    
    func indexOf(_ value : String) -> Int {
        for i in 0..<options.count {
            if options[i] == value {
                return i;
            }
        }
        return -1;
    }
        
    func performAnalysis(seed : String) -> Run {
        return performAnalysis(8, [15, 50, 50, 50, 50, 50, 50, 50], Deck.RED_DECK, Stake.White_Stake, Version.v_101f, seed);
    }
    
    func performAnalysis(seed : String, maxDepth: Int, version : Version) -> Run {
        var cards : [Int] = Array(repeating: 50, count: maxDepth)
        cards[0] = 15
        return performAnalysis(maxDepth, cards, Deck.RED_DECK, Stake.White_Stake, version, seed);
    }
    
    var analyzeCards = true
    var analyzeShop = true
    var analyzeCelestial = true
    var analyzeSpectralss = true
    var analyzeTags = true
    var analyzeBoss = true
    var analyzeStandard = true
    var analyzeArcana = true
    var analyzeVoucher = true
    
    func configureForSpeed(selections : [Item]) -> Balatro {
        analyzeBoss = false
        analyzeStandard = false
        analyzeTags = false
        analyzeSpectralss = false
        analyzeArcana = false
        
        for selection in selections {
            if selection is LegendaryJoker {
                analyzeArcana = true
                analyzeSpectralss = true
                break
            }
        }
        
        return self
    }
    
    func performAnalysis(_ maxDepth : Int,_ cardsPerAnte : [Int],_  deck : Deck,_  stake : Stake,_  version : Version,_  seed: String) -> Run {
        let selectedOptions : [Bool] = Array.init(repeating: true, count: 61)
        
        let inst =  Functions(seed);
        
        inst.setParams(InstanceParams(deck, stake, false, 1, version))
        inst.initLocks(1, false, false);
        inst.lock("Overstock Plus");
        inst.lock("Liquidation");
        inst.lock("Glow Up");
        inst.lock("Reroll Glut");
        inst.lock("Omen Globe");
        inst.lock("Observatory");
        inst.lock("Nacho Tong");
        inst.lock("Recyclomancy");
        inst.lock("Tarot Tycoon");
        inst.lock("Planet Tycoon");
        inst.lock("Money Tree");
        inst.lock("Antimatter");
        inst.lock("Illusion");
        inst.lock("Petroglyph");
        inst.lock("Retcon");
        inst.lock("Palette");
        
        for i in 0..<options.count {
            if (!selectedOptions[i]){ inst.lock(options[i]); }
        }
        
        inst.setDeck(deck);
        var antes : [Ante] = []
        
        for a in 1...maxDepth {
            let play = Ante(ante: a, functions: inst)
            antes.append(play)
            inst.initUnlocks(a, false);
            
            if analyzeBoss {
                play.boss = inst.nextBoss(a);
            }
            
            if analyzeVoucher {
                let voucher = inst.nextVoucher(a);
                play.voucher = voucher
                
                inst.lock(voucher);
                
                // Unlock next level voucher
                for i in stride(from: 0, to: Functions.VOUCHERS.count, by: 2){
                    if (Functions.VOUCHERS[i] == voucher) {
                        // Only unlock it if it's unlockable
                        if (selectedOptions[indexOf(Functions.VOUCHERS[i + 1].rawValue)]) {
                            inst.unlock(Functions.VOUCHERS[i + 1].rawValue);
                        }
                    }
                }
            }
            
                
            if analyzeTags {
                play.tags.insert(inst.nextTag(a))
                play.tags.insert(inst.nextTag(a))
            }
            
            for _ in stride(from: 1, to: cardsPerAnte[a - 1], by: 1){
                var sticker : Edition?
                
                let item = inst.nextShopItem(a);
                
                if (item.type == .Joker) {
                    if (item.jokerData.stickers.eternal){
                        sticker = .Eternal
                    }
                    if (item.jokerData.stickers.perishable){
                        sticker = .Perishable
                    }
                    if (item.jokerData.stickers.rental){
                        sticker = .Rental
                    }
                    if (item.jokerData.edition != .NoEdition){
                        sticker = item.jokerData.edition
                    }
                }
                
                play.addToQueue(value: item, sticker: sticker)
            }
            
            
            let numPacks = (a == 1) ? 4 : 6;
            
            for _ in(1...numPacks){
                let pack = inst.nextPack(a);
                let packInfo = inst.packInfo(pack);
                var options : [Option] = []
                
                switch(pack.kind){
                case .Celestial:
                    if !analyzeCelestial {
                        continue
                    }
                    
                    let cards = inst.nextCelestialPack(packInfo.size, a);
                    for c in 0..<packInfo.size {
                        options.append(Option(cards[c]))
                    }
                case .Arcana:
                    if !analyzeArcana {
                        continue
                    }
                    
                    let cards = inst.nextArcanaPack(packInfo.size, a);
                    for c in 0..<packInfo.size {
                        options.append(Option(cards[c]))
                        
                    }
                case .Buffoon:
                    let cards = inst.nextBuffoonPack(packInfo.size, a);
                    
                    for c in 0..<packInfo.size {
                        let joker = cards[c]
                        let sticker = Balatro.getSticker(joker)
                        
                        options.append(Option(sticker: sticker, joker.joker))
                        
                    }
                case .Spectral:
                    if !analyzeSpectralss {
                        continue
                    }
                    
                    let cards = inst.nextSpectralPack(packInfo.size, a);
                    for c in 0..<packInfo.size {
                        options.append(Option(cards[c]))
                    }
                case .Standard:
                    if !analyzeStandard {
                        continue
                    }
                    
                    let cards = inst.nextStandardPack(packInfo.size, a);
                    for c in 0..<packInfo.size {
                        let card = cards[c]
                        options.append(Option(card))
                    }
                }
                
                for option in options {
                    if(option.item.rawValue == Specials.THE_SHOUL.rawValue){
                        option.legendary = play.nextLegendary()
                    }
                }
                
                play.addPack(pack: packInfo, options: options)
            }
        }
        
        return Run(seed: seed, antes: antes)
    }
    
    static func  getSticker(_ joker : JokerData) -> Item? {
        var sticker : Item? = nil
        
        if (joker.stickers.eternal) {
            sticker = Edition.Eternal;
        }
        if (joker.stickers.perishable) {
            sticker = Edition.Perishable;
        }
        if (joker.stickers.rental) {
            sticker = Edition.Rental;
        }
        
        if(joker.edition != Edition.NoEdition){
            sticker = joker.edition
        }
        
        return sticker
    }
}
