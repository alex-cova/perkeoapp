//
//  Functions.swift
//  balatroseeds
//
//  Created by Alex on 03/01/25.
//

class Functions : Lock {
    static let TAROTS : [Tarot] = Tarot.allCases
    static let PLANETS : [Planet] = Planet.allCases
    static let SPECTRALS : [Spectral] = Spectral.allCases
    static let LEGENDARY_JOKERS : [LegendaryJoker] = LegendaryJoker.allCases
    static let UNCOMMON_JOKERS : [UnCommonJoker] = UnCommonJoker.allCases
    static let UNCOMMON_JOKERS_101C : [UnCommonJoker101C] = UnCommonJoker101C.allCases
    static let UNCOMMON_JOKERS_100 : [UnCommonJoker100] = UnCommonJoker100.allCases
    static let CARDS : [Cards] = Cards.allCases
    static let ENHANCEMENTS : [Enhancement] = Enhancement.allCases
    static let VOUCHERS : [Voucher] = Voucher.allCases
    static let TAGS : [Tag] = Tag.allCases
    static let PACKS : [PackType] = PackType.allCases
    static let RARE_JOKERS : [RareJoker] = RareJoker.allCases
    static let RARE_JOKERS_101C : [RareJoker101C] = RareJoker101C.allCases
    static let RARE_JOKERS_100 : [RareJoker100] = RareJoker100.allCases
    static let COMMON_JOKERS : [CommonJoker] = CommonJoker.allCases
    static let COMMON_JOKERS_100 : [CommonJoker100] = CommonJoker100.allCases
    static let BOSSES : [Boss] = Boss.allCases
    
    var params : InstanceParams
    var cache : Cache
    
    let seed : String
    let hashedSeed : Double
    
    init(_ s : String) {
        seed = s;
        hashedSeed = Util.pseudohash(s)
        params = InstanceParams()
        cache = Cache()
    }
    
    func setParams(_ params : InstanceParams) {
        self.params = params;
    }
    
    func randint(_ id: String, _ min : Int, _ max : Int) -> Int{
        LuaRandom.randint(seed: getNode(id), min, max)
    }
    
    func random(_ id : String) -> Double {
        LuaRandom.random(seed: getNode(id))
    }
    
    func getNode(_ ID : String) -> Double {
        var c = cache.nodes[ID]
        
        if (c == nil) {
            c = Util.pseudohash("\(ID)\(seed)")
            cache.nodes[ID] = c
        }
        
        let pre = (c! * 1.72431234 + 2.134453429141)
            .truncatingRemainder(dividingBy: 1)
        let value = Util.round13(pre)
        
        cache.nodes[ID] = value
        
        return (value + hashedSeed) / 2.0
    }
    
    
    func randweightedchoice(_ ID : String,_ items : [PackType]) -> PackType{
        var poll = random(ID)
        poll = poll * 22.42
        
        var idx = 1
        var weight : Double = 0.0
        
        while (weight < poll) {
            weight += items[idx].value
            idx += 1
        }
        
        return items[idx - 1]
    }
    
    
    func randchoice<T : RawRepresentable>(_ ID : String, _ items : [T]) -> T where T.RawValue == String  {
        var item = items[randint(ID, 0, items.count - 1)]
        if (!params.showman && isLocked(item.rawValue) || "RETRY" == item.rawValue) {
            var resample = 2;
            while (true) {
                item = items[randint("\(ID)_resample\(resample)", 0, items.count - 1)]
                resample += 1
                if ((!isLocked(item.rawValue) && "RETRY" != item.rawValue) || resample > 1000){
                    return item
                }
            }
        }
        return item
    }
    
    // Card Generators
    func nextTarot(_ source : String,_ ante : Int,_ soulable : Bool) -> Item {
        if (soulable && (params.showman || !isLocked("The Soul")) && random("soul_Tarot\(ante)") > 0.997) {
            return Specials.THE_SHOUL;
        }
        return randchoice("Tarot\(source)\(ante)", Functions.TAROTS);
    }
    
    func  nextPlanet(_ source : String,_ ante : Int,_ soulable : Bool) -> Item {
        if (soulable && (params.showman || !isLocked(Specials.BLACKHOLE.rawValue)) && random("soul_Planet\(ante)") > 0.997) {
            return Specials.BLACKHOLE;
        }
        return randchoice("Planet\(source)\(ante)", Functions.PLANETS);
    }
    
    func nextSpectral(_ source : String,_ ante : Int,_ soulable : Bool) -> Item {
        if (soulable) {
            var forcedKey : Item = Specials.RETRY;
            if ((params.showman || !isLocked("The Soul")) && random("soul_Spectral\(ante)") > 0.997){
                forcedKey = Specials.THE_SHOUL
            }
            
            if ((params.showman || !isLocked("Black Hole")) && random("soul_Spectral\(ante)") > 0.997){
                forcedKey = Specials.BLACKHOLE
            }
            if (forcedKey.rawValue != "RETRY"){ return forcedKey}
        }
        
        return randchoice("Spectral\(source)\(ante)", Functions.SPECTRALS);
    }
    
    static let setA = Set.of("Gros Michel", "Ice Cream", "Cavendish", "Luchador", "Turtle Bean", "Diet Cola", "Popcorn", "Ramen", "Seltzer", "Mr. Bones", "Invisible Joker");
    static let setB = Set.of("Ceremonial Dagger", "Ride the Bus", "Runner", "Constellation", "Green Joker", "Red Card", "Madness", "Square Joker", "Vampire", "Rocket", "Obelisk", "Lucky Cat", "Flash Card", "Spare Trousers", "Castle", "Wee Joker");
    
    
    func nextJoker(_ source : String,_  ante : Int,_  hasStickers : Bool) -> JokerData{
        
        // Get rarity
        var rarity = ""
        switch (source) {
        case "sou": rarity = "4"
        case "wra", "rta": rarity = "3"
        case "uta": rarity = "2"
        default :
            let rarityPoll = random("rarity\(ante)\(source)");
            if (rarityPoll > 0.95){ rarity = "3"}
            else if (rarityPoll > 0.7){ rarity = "2"}
            else{ rarity = "1"}
            
        }
        
        
        // Get edition
        var editionRate : Double = 1
        if (isVoucherActive(Voucher.Glow_Up)){ editionRate = 4}
        else if (isVoucherActive(Voucher.Hone)){ editionRate = 2}
        var edition : Edition = .NoEdition
        let editionPoll = random("edi\(source)\(ante)");
        
        if (editionPoll > 0.997){
            edition = .Negative
        }
        else if (editionPoll > 1 - 0.006 * editionRate){ edition = .Polychrome}
        else if (editionPoll > 1 - 0.02 * editionRate){ edition = .Holographic }
        else if (editionPoll > 1 - 0.04 * editionRate){ edition = .Foil }
        else { edition = .NoEdition}
        
        // Get next joker
        var joker : Item = CommonJoker.Joker
        switch (rarity) {
        case "4":
            if (params.version > 10099){ joker = randchoice("Joker4", Functions.LEGENDARY_JOKERS)}
            else{ joker = randchoice("Joker4\(source)\(ante)", Functions.LEGENDARY_JOKERS)}
            
        case "3":
            if (params.version > 10103) {
                joker = randchoice("Joker3\(source)\(ante)", Functions.RARE_JOKERS);
            }else if (params.version > 10099) {
                joker = randchoice("Joker3\(source)\(ante)", Functions.RARE_JOKERS_101C);
            } else {
                joker = randchoice("Joker3\(source)\(ante)", Functions.RARE_JOKERS_100);
            }
            
        case "2" :
            if(params.version > 10103) {
                joker = randchoice("Joker2\(source)\(ante)", Functions.UNCOMMON_JOKERS);
            } else if (params.version > 10099) {
                joker = randchoice("Joker2\(source)\(ante)", Functions.UNCOMMON_JOKERS_101C);
            } else {
                joker = randchoice("Joker2\(source)\(ante)",  Functions.UNCOMMON_JOKERS_100);
            }
            
        default :
            if (params.version > 10099) {
                joker = randchoice("Joker1\(source)\(ante)",Functions.COMMON_JOKERS);
            } else {
                joker = randchoice("Joker1\(source)\(ante)",  Functions.COMMON_JOKERS_100);
            }
        }
        
        // Get next joker stickers
        let stickers = JokerStickers()
        if (hasStickers) {
            if (params.version > 10103) {
                let searchForSticker = (params.stake == Stake.Black_Stake ||
                                        params.stake == Stake.Blue_Stake ||
                                        params.stake == Stake.Purple_Stake ||
                                        params.stake == Stake.Orange_Stake ||
                                        params.stake == Stake.Gold_Stake)
                
                var stickerPoll = 0.0
                
                if searchForSticker {
                    let k = ((source.equals("buf")) ? "packetper" : "etperpoll")
                    stickerPoll = random("\(k)\(ante)");
                }
                
                if (stickerPoll > 0.7) {
                    if (!Functions.setA.contains(joker.rawValue)) {
                        stickers.eternal = true;
                    }
                }
                
                if ((stickerPoll > 0.4 && stickerPoll <= 0.7) && (params.stake == Stake.Orange_Stake || params.stake == Stake.Gold_Stake)) {
                    if (!Functions.setB.contains(joker.rawValue)) {
                        stickers.perishable = true;
                    }
                }
                
                if (params.stake == Stake.Gold_Stake) {
                    let r = ((source.equals("buf")) ? "packssjr" : "ssjr")
                    stickers.rental = random("\(r)\(ante)") > 0.7;
                }
                
            } else {
                if (params.stake == Stake.Black_Stake || params.stake == Stake.Blue_Stake || params.stake == Stake.Purple_Stake || params.stake == Stake.Orange_Stake || params.stake == Stake.Gold_Stake) {
                    if (!Functions.setA.contains(joker.rawValue)) {
                        stickers.eternal = random("stake_shop_joker_eternal\(ante)") > 0.7;
                    }
                }
                if (params.version > 10099) {
                    if ((params.stake == Stake.Orange_Stake || params.stake == Stake.Gold_Stake) && !stickers.eternal) {
                        stickers.perishable = random("ssjp\(ante)") > 0.49;
                    }
                    if (params.stake == Stake.Gold_Stake) {
                        stickers.rental = random("ssjr\(ante)") > 0.7;
                    }
                }
            }
        }
        
        return JokerData(joker, rarity, edition, stickers);
    }
    
    // Shop Logic
    func getShopInstance() -> ShopInstance {
        var tarotRate : Double = 4
        var planetRate : Double = 4
        var playingCardRate : Double = 0
        var spectralRate : Double = 0
        
        if (params.deck == Deck.GHOST_DECK) {
            spectralRate = 2;
        }
        if (isVoucherActive(Voucher.Tarot_Tycoon)) {
            tarotRate = 32;
        } else if (isVoucherActive(Voucher.Tarot_Merchant)) {
            tarotRate = 9.6;
        }
        if (isVoucherActive(Voucher.Planet_Tycoon)) {
            planetRate = 32;
        } else if (isVoucherActive(Voucher.Planet_Tycoon)) {
            planetRate = 9.6;
        }
        if (isVoucherActive(Voucher.Magic_Trick)) {
            playingCardRate = 4;
        }
        
        return ShopInstance(20, tarotRate, planetRate, playingCardRate, spectralRate);
    }
    
    func nextShopItem(_ ante : Int) -> ShopItem{
        let shop = getShopInstance()
        var cdtPoll = random("cdt\(ante)") * shop.getTotalRate();
        var type : ItemType
        if (cdtPoll < shop.jokerRate){ type = .Joker}
        else {
            cdtPoll -= shop.jokerRate;
            if (cdtPoll < shop.tarotRate){ type = .Tarot}
            else {
                cdtPoll -= shop.tarotRate;
                if (cdtPoll < shop.planetRate){ type = .Planet}
                else {
                    cdtPoll -= shop.planetRate;
                    if (cdtPoll < shop.playingCardRate){ type = .PlayingCard}
                    else{ type = .Spectral}
                }
            }
        }
        
        switch (type) {
        case .Joker:
            let jkr = nextJoker("sho", ante, true);
            return ShopItem(type, jkr.joker, jkr);
            
        case .Tarot:
            return ShopItem(type, nextTarot("sho", ante, false));
            
        case .Planet:
            return ShopItem(type, nextPlanet("sho", ante, false));
            
        case .Spectral :
            return ShopItem(type, nextSpectral("sho", ante, false));
        default:
            return ShopItem();
            
        }
        // Todo: Magic Trick support
    }
    
    // Packs and Pack Contents
    func  nextPack(_ ante : Int) -> PackType {
        if (ante <= 2 && !cache.generatedFirstPack && params.version > 10099) {
            cache.generatedFirstPack = true;
            return .Buffoon_Pack;
        }
        
        return randweightedchoice("shop_pack\(ante)", Functions.PACKS);
    }
    
    func packInfo(_ pack : PackType) -> Pack {
        if (pack.isMega) {
            return Pack(pack, (pack.isBuffoon || pack.isSpectral) ? 4 : 5, 2);
        } else if (pack.isJumbo) {
            return Pack(pack, (pack.isBuffoon || pack.isSpectral) ? 4 : 5, 1);
        } else {
            return Pack(pack, (pack.isBuffoon || pack.isSpectral) ? 2 : 3, 1);
        }
    }
    
    func nextStandardCard(_ ante : Int) -> Card{
        
        // Enhancement
        var enhancement : Enhancement? = nil
        if (random("stdset\(ante)") <= 0.6){
            //enhancement = "No Enhancement";
        } else{
            enhancement = randchoice("Enhancedsta\(ante)", Functions.ENHANCEMENTS);
        }
        
        // Base
        let base = randchoice("frontsta\(ante)" , Functions.CARDS);
        
        // Edition
        var edition : Edition = .NoEdition
        
        let editionPoll = random("standard_edition\(ante)");
        
        if (editionPoll > 0.988){
            edition = .Polychrome;
        } else if (editionPoll > 0.96){
            edition = .Holographic;
        }else if (editionPoll > 0.92){
            edition = .Foil;
        }
        
        
        // Seal
        var seal : Seal = .NoSeal
        
        if (random("stdseal\(ante)") <= 0.8){
            seal = .NoSeal;
        } else {
            let sealPoll = random("stdsealtype\(ante)");
            
            if (sealPoll > 0.75){
                seal = .RedSeal;
            } else if (sealPoll > 0.5){
                seal = .BlueSeal;
            }else if (sealPoll > 0.25){
                seal = .GoldSeal;
            }else{
                seal = .PurpleSeal;
            }
        }
        
        return Card(base, enhancement, edition, seal);
    }
    
    func  nextArcanaPack(_ size : Int,_ ante : Int) -> [Item]{
        var pack : [Item] = []
        
        for i in 0..<size {
            if (isVoucherActive(Voucher.Omen_Globe) && random("omen_globe") > 0.8) {
                pack.append(nextSpectral("ar2", ante, true));
            } else { pack.append(nextTarot("ar1", ante, true));}
            if (!params.showman){ lock(pack[i]);}
        }
        
        for i in 0..<size {
            unlock(pack[i]);
        }
        return pack;
    }
    
    func  nextCelestialPack(_ size : Int,_ ante : Int) -> [Item] {
        var pack : [Item] = []
        
        for i in 0..<size {
            pack.append(nextPlanet("pl1", ante, true));
            if (!params.showman){ lock(pack[i]);}
        }
        
        for i in 0..<size {
            unlock(pack[i]);
        }
        
        return pack;
    }
    
    func nextSpectralPack(_ size : Int,_ ante : Int) -> [Item]{
        var pack : [Item] = []
        
        for i in 0..<size {
            pack.append(nextSpectral("spe", ante, true));
            if (!params.showman){ lock(pack[i]);}
        }
        
        for i in 0..<size {
            unlock(pack[i]);
        }
        
        return pack;
    }
    
    func nextStandardPack(_ size : Int,_ ante : Int) -> [Card] {
        var pack : [Card] = []
        
        for _ in 0..<size {
            pack.append(nextStandardCard(ante))
        }
        
        
        return pack;
    }
    
    func nextBuffoonPack(_ size : Int,_ ante : Int) -> [JokerData]{
        var pack : [JokerData] = []
        
        for i in 0..<size {
            pack.append(nextJoker("buf", ante, true));
            if (!params.showman){ lock(pack[i].joker)}
        }
        
        
        for i in 0..<size {
            unlock(pack[i].joker);
        }
        return pack;
    }
    
    // Misc methods
    func isVoucherActive(_ voucher : Voucher) -> Bool{
        return params.vouchers.contains(voucher);
    }
    
    func activateVoucher(_ voucher : Voucher) {
        params.vouchers.insert(voucher);
        lock(voucher.rawValue);
        // Unlock next level voucher
        for i in stride(from: 0, to: Functions.VOUCHERS.count, by: 2) {
            if (Functions.VOUCHERS[i] == voucher) {
                unlock(Functions.VOUCHERS[i + 1].rawValue);
            }
        }
    }
    
    func nextVoucher(_ ante : Int) -> Voucher {
        return randchoice("Voucher\(ante)", Functions.VOUCHERS);
    }
    
    func setDeck(_ deck : Deck) {
        params.deck = deck
        switch (deck) {
        case .MAGIC_DECK:
            activateVoucher(.Crystal_Ball);
            break;
        case .NEBULA_DECK:
            activateVoucher(.Telescope);
            break;
        case .ZODIAC_DECK:
            activateVoucher(.Tarot_Merchant);
            activateVoucher(.Planet_Merchant);
            activateVoucher(.Overstock);
            break;
        default:
            break;
        }
    }
    
    func nextTag(_ ante : Int) -> Tag{
        return randchoice("Tag\(ante)", Functions.TAGS);
    }
    
    func nextBoss(_ ante : Int) -> Boss {
        var bossPool : [Boss] = []
        var numBosses = 0;
        
        // First pass: Try to find unlocked bosses
        for boss in Functions.BOSSES {
            if (!isLocked(boss.rawValue)) {
                if ((ante % 8 == 0 && boss.rawValue.charAt(0) != "T") ||
                    (ante % 8 != 0 && boss.rawValue.charAt(0) == "T")) {
                    bossPool.append(boss)
                    numBosses += 1
                }
            }
        }
        
        // If no bosses found, unlock appropriate bosses and try again
        if (numBosses == 0) {
            for boss in Functions.BOSSES {
                if ((ante % 8 == 0 && boss.rawValue.charAt(0) != "T") ||
                    (ante % 8 != 0 && boss.rawValue.charAt(0) == "T")) {
                    unlock(boss.rawValue)
                }
            }
            return nextBoss(ante);
        }
        
        let chosenBoss = randchoice("boss", bossPool);
        lock(chosenBoss);
        return chosenBoss;
    }
    
}

