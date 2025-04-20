//
//  Functions.swift
//  balatroseeds
//
//  Created by Alex on 03/01/25.
//

class Functions: Lock {
    
    static let TAROTS: [Tarot] = Tarot.allCases
    static let PLANETS: [Planet] = Planet.allCases
    static let SPECTRALS: [Spectral] = Spectral.allCases
    static let LEGENDARY_JOKERS: [LegendaryJoker] = LegendaryJoker.allCases
    static let UNCOMMON_JOKERS: [UnCommonJoker] = UnCommonJoker.allCases
    static let UNCOMMON_JOKERS_101C: [UnCommonJoker101C] = UnCommonJoker101C.allCases
    static let UNCOMMON_JOKERS_100: [UnCommonJoker100] = UnCommonJoker100.allCases
    static let CARDS: [Cards] = Cards.allCases
    static let ENHANCEMENTS: [Enhancement] = Enhancement.allCases
    static let VOUCHERS: [Voucher] = Voucher.allCases
    static let TAGS: [Tag] = Tag.allCases
    static let PACKS: [PackType] = PackType.allCases
    static let RARE_JOKERS: [RareJoker] = RareJoker.allCases
    static let RARE_JOKERS_101C: [RareJoker101C] = RareJoker101C.allCases
    static let RARE_JOKERS_100: [RareJoker100] = RareJoker100.allCases
    static let COMMON_JOKERS: [CommonJoker] = CommonJoker.allCases
    static let COMMON_JOKERS_100: [CommonJoker100] = CommonJoker100.allCases
    static let BOSSES: [Boss] = Boss.allCases
    
    var params: InstanceParams
    var cache: Cache
    
    let seed: String
    let hashedSeed: Double
    let ante: Int
    
    init(_ s: String, _ ante: Int) {
        self.seed = s
        self.ante = ante
        hashedSeed = Util.pseudohash(s)
        params = InstanceParams()
        cache = Cache()
    }
    
    func setParams(_ params: InstanceParams) {
        self.params = params
    }
    
    func randint(_ id: String, _ min: Int, _ max: Int) -> Int {
        LuaRandom.randint(seed: getNode(id), min, max)
    }
    
    func random(_ id: String) -> Double {
        LuaRandom.random(seed: getNode(id))
    }
    
    func getNode(_ ID: String) -> Double {
        var c = cache.nodes[ID]
        
        if c == nil {
            c = Util.pseudohash("\(ID)\(seed)")
            cache.nodes[ID] = c
        }
        
        let pre = (c! * 1.72431234 + 2.134453429141)
            .truncatingRemainder(dividingBy: 1)
        let value = Util.round13(pre)
        
        cache.nodes[ID] = value
        
        return (value + hashedSeed) / 2.0
    }
    
    func randweightedchoice(_ ID: String, _ items: [PackType]) -> PackType {
        var poll = random(ID)
        poll = poll * 22.42
        
        var idx = 1
        var weight: Double = 0.0
        
        while weight < poll {
            weight += items[idx].value
            idx += 1
        }
        
        return items[idx - 1]
    }
    
    func randchoice<T: Item>(_ ID: String, _ items: [T]) -> T {
        let item = _randchoice(ID, items)
        
        if item.rawValue.starts(with: "RETRY") {
            fatalError("Unspected retry item: \(item.rawValue)")
        }
        
        return item
    }
    
    func _randchoice<T: Item>(_ ID: String, _ items: [T]) -> T {
        var item = items[randint(ID, 0, items.count - 1)]

        if params.showman {
            return item
        }

        var retry = ("RETRY" == item.rawValue || "RETRY2" == item.rawValue)

        if isLocked(item) || retry {
            var resample = 2
            while true {
                item = items[randint("\(ID)_resample\(resample)", 0, items.count - 1)]
                resample += 1
                retry = ("RETRY" == item.rawValue || "RETRY2" == item.rawValue)
                if (!isLocked(item) && !retry) || resample > 1000 {
                    return item
                }
            }
        }
        return item
    }
    
    // Card Generators
    func nextTarot(_ source: String, _ ante: Int, _ soulable: Bool) -> Item {
        if soulable && (params.showman || !isLocked(Specials.THE_SOUL))
            && random(Functions.soul_TarotArr[ante]) > 0.997 {
            let data =  nextJoker("sou", joker1Arr: Functions.joker1SouArr, joker2Arr: Functions.joker2SouArr,
                                  joker3Arr: Functions.joker3SouArr, joker4Arr: Functions.joker4SouArr, rarityArr: Functions.raritySouArr,
                                  editionArr: Functions.editionSouArr, ante, true)
            lock(data.joker)
            lock(Specials.THE_SOUL)
            return EditionItem(edition: data.edition, data.joker)
        }
        return randchoice(source, Functions.TAROTS)
    }
    
    func nextPlanet(_ source: String, _ ante: Int, _ soulable: Bool) -> Item {
        if soulable && (params.showman || !isLocked(Specials.BLACKHOLE))
            && random(Functions.soul_PlanetArr[ante]) > 0.997
        {
            return Specials.BLACKHOLE
        }
        return randchoice(source, Functions.PLANETS)
    }
    
    func nextSpectral(_ source: String, _ ante: Int, _ soulable: Bool) -> Item {
        if soulable {
            var forcedKey : Item?
            var edition : Edition = .NoEdition
            
            if ((params.showman || !isLocked(Specials.THE_SOUL)) && random(Functions.soul_SpectralArr[ante]) > 0.997) {
                let data =  nextJoker("sou", joker1Arr: Functions.joker1SouArr, joker2Arr: Functions.joker2SouArr,
                                      joker3Arr: Functions.joker3SouArr, joker4Arr: Functions.joker4SouArr, rarityArr: Functions.raritySouArr,
                                      editionArr: Functions.editionSouArr, ante, true);
                
                forcedKey = data.joker
                edition = data.edition
                
                lock(data.joker)
            }
            
            if ((params.showman || !isLocked(Specials.BLACKHOLE)) && random(Functions.soul_SpectralArr[ante]) > 0.997) {
                forcedKey = Specials.BLACKHOLE;
            }
            
            
            if (forcedKey != nil) {
                return EditionItem(edition: edition, forcedKey!)
            }
        }
        
        return randchoice(source, Functions.SPECTRALS)
    }
    
    func edition(_ ante: Int, editionArr: [String]) -> Edition {
        // Get edition
        var editionRate: Double = 1
        
        if isVoucherActive(Voucher.Glow_Up) {
            editionRate = 4
        } else if isVoucherActive(Voucher.Hone) {
            editionRate = 2
        }
        
        var edition: Edition = .NoEdition
        let editionPoll = random(editionArr[ante])
        
        if editionPoll > 0.997 {
            edition = .Negative
        } else if editionPoll > 1 - 0.006 * editionRate {
            edition = .Polychrome
        } else if editionPoll > 1 - 0.02 * editionRate {
            edition = .Holographic
        } else if editionPoll > 1 - 0.04 * editionRate {
            edition = .Foil
        } else {
            edition = .NoEdition
        }
        
        return edition
    }
    
    static let setA = Set.of(
        "Gros Michel", "Ice Cream", "Cavendish", "Luchador", "Turtle Bean", "Diet Cola", "Popcorn",
        "Ramen", "Seltzer", "Mr. Bones", "Invisible Joker")
    static let setB = Set.of(
        "Ceremonial Dagger", "Ride the Bus", "Runner", "Constellation", "Green Joker", "Red Card",
        "Madness", "Square Joker", "Vampire", "Rocket", "Obelisk", "Lucky Cat", "Flash Card",
        "Spare Trousers", "Castle", "Wee Joker")
    
    func nextJoker(
        _ source: String, joker1Arr: [String], joker2Arr: [String], joker3Arr: [String],
        joker4Arr: [String],
        rarityArr: [String], editionArr: [String], _ ante: Int, _ hasStickers: Bool
    ) -> JokerData {
        // Get rarity
        var rarity = ""
        
        switch source {
        case "sou": rarity = "4"
        case "wra", "rta": rarity = "3"
        case "uta": rarity = "2"
        default:
            let rarityPoll = random(rarityArr[ante])
            if rarityPoll > 0.95 {
                rarity = "3"
            } else if rarityPoll > 0.7 {
                rarity = "2"
            } else {
                rarity = "1"
            }
            
        }
        
        let edition = edition(ante, editionArr: editionArr)
        
        // Get next joker
        var joker: Item = CommonJoker.Joker
        
        switch rarity {
        case "4":
            if params.version > 10099 {
                joker = randchoice("Joker4", Functions.LEGENDARY_JOKERS)
            } else {
                joker = randchoice(joker4Arr[ante], Functions.LEGENDARY_JOKERS)
            }
            
        case "3":
            if params.version > 10103 {
                joker = randchoice(joker3Arr[ante], Functions.RARE_JOKERS)
            } else if params.version > 10099 {
                joker = randchoice(joker3Arr[ante], Functions.RARE_JOKERS_101C)
            } else {
                joker = randchoice(joker3Arr[ante], Functions.RARE_JOKERS_100)
            }
            
        case "2":
            if params.version > 10103 {
                joker = randchoice(joker2Arr[ante], Functions.UNCOMMON_JOKERS)
            } else if params.version > 10099 {
                joker = randchoice(joker2Arr[ante], Functions.UNCOMMON_JOKERS_101C)
            } else {
                joker = randchoice(joker2Arr[ante], Functions.UNCOMMON_JOKERS_100)
            }
            
        default:
            if params.version > 10099 {
                joker = randchoice(joker1Arr[ante], Functions.COMMON_JOKERS)
            } else {
                joker = randchoice(joker1Arr[ante], Functions.COMMON_JOKERS_100)
            }
        }
        
        // Get next joker stickers
        let stickers = JokerStickers()
        if hasStickers {
            if params.version > 10103 {
                let searchForSticker =
                (params.stake == Stake.Black_Stake || params.stake == Stake.Blue_Stake
                 || params.stake == Stake.Purple_Stake || params.stake == Stake.Orange_Stake
                 || params.stake == Stake.Gold_Stake)
                
                var stickerPoll = 0.0
                
                if searchForSticker {
                    if source == "buf" {
                        stickerPoll = random(Functions.packetperArr[ante])
                    } else {
                        stickerPoll = random(Functions.etperpollArr[ante])
                    }
                }
                
                if stickerPoll > 0.7 {
                    if !Functions.setA.contains(joker.rawValue) {
                        stickers.eternal = true
                    }
                }
                
                if (stickerPoll > 0.4 && stickerPoll <= 0.7)
                    && (params.stake == Stake.Orange_Stake || params.stake == Stake.Gold_Stake)
                {
                    if !Functions.setB.contains(joker.rawValue) {
                        stickers.perishable = true
                    }
                }
                
                if params.stake == Stake.Gold_Stake {
                    if source == "buf" {
                        stickers.rental = random(Functions.packssjrArr[ante]) > 0.7
                    } else {
                        stickers.rental = random(Functions.ssjrArr[ante]) > 0.7
                    }
                }
                
            } else {
                if params.stake == Stake.Black_Stake || params.stake == Stake.Blue_Stake
                    || params.stake == Stake.Purple_Stake || params.stake == Stake.Orange_Stake
                    || params.stake == Stake.Gold_Stake
                {
                    if !Functions.setA.contains(joker.rawValue) {
                        stickers.eternal = random(Functions.stake_shop_joker_eternalArr[ante]) > 0.7
                    }
                }
                if params.version > 10099 {
                    if (params.stake == Stake.Orange_Stake || params.stake == Stake.Gold_Stake)
                        && !stickers.eternal
                    {
                        stickers.perishable = random(Functions.ssjpArr[ante]) > 0.49
                    }
                    if params.stake == Stake.Gold_Stake {
                        stickers.rental = random(Functions.ssjrArr[ante]) > 0.7
                    }
                }
            }
        }
        
        return JokerData(joker, rarity, edition, stickers)
    }
    
    // Shop Logic
    func getShopInstance() -> ShopInstance {
        var tarotRate: Double = 4
        var planetRate: Double = 4
        var playingCardRate: Double = 0
        var spectralRate: Double = 0
        
        if params.deck == Deck.GHOST_DECK {
            spectralRate = 2
        }
        
        if isVoucherActive(Voucher.Tarot_Tycoon) {
            tarotRate = 32
        } else if isVoucherActive(Voucher.Tarot_Merchant) {
            tarotRate = 9.6
        }
        
        if isVoucherActive(Voucher.Planet_Tycoon) {
            planetRate = 32
        } else if isVoucherActive(Voucher.Planet_Tycoon) {
            planetRate = 9.6
        }
        
        if isVoucherActive(Voucher.Magic_Trick) {
            playingCardRate = 4
        }
        
        return ShopInstance(20, tarotRate, planetRate, playingCardRate, spectralRate)
    }
    
    func nextShopItem(_ ante: Int) -> ShopItem {
        let shop = getShopInstance()
        var cdtPoll = random(Functions.cdtArr[ante]) * shop.getTotalRate()
        var type: ItemType
        
        if cdtPoll < shop.jokerRate {
            type = .Joker
        } else {
            cdtPoll -= shop.jokerRate
            if cdtPoll < shop.tarotRate {
                type = .Tarot
            } else {
                cdtPoll -= shop.tarotRate
                if cdtPoll < shop.planetRate {
                    type = .Planet
                } else {
                    cdtPoll -= shop.planetRate
                    if cdtPoll < shop.playingCardRate {
                        type = .PlayingCard
                    } else {
                        type = .Spectral
                    }
                }
            }
        }
        
        switch type {
        case .Joker:
            let jkr = nextJoker(
                "sho", joker1Arr: Functions.joker1ShoArr,
                joker2Arr: Functions.joker2ShoArr,
                joker3Arr: Functions.joker3ShoArr,
                joker4Arr: Functions.joker4ShoArr,
                rarityArr: Functions.rarityShoArr, editionArr: Functions.editionShoArr, ante, true)
            return ShopItem(type, jkr.joker, jkr)
        case .Tarot:
            return ShopItem(type, nextTarot(Functions.tarotShoArr[ante], ante, false))
        case .Planet:
            return ShopItem(type, nextPlanet(Functions.planetShoArr[ante], ante, false))
        case .Spectral:
            return ShopItem(type, nextSpectral(Functions.spectralShoArr[ante], ante, false))
        case .PlayingCard:
            return ShopItem(type, nextStandardCard(ante))
        }
        // Todo: Magic Trick support
    }
    
    // Packs and Pack Contents
    func nextPack(_ ante: Int) -> PackType {
        if ante <= 2 && !cache.generatedFirstPack && params.version > 10099 {
            cache.generatedFirstPack = true
            return .Buffoon_Pack
        }
        
        return randweightedchoice(Functions.shop_packArr[ante], Functions.PACKS)
    }
    
    func packInfo(_ pack: PackType) -> Pack {
        if pack.isMega {
            return Pack(pack, (pack.isBuffoon || pack.isSpectral) ? 4 : 5, 2)
        } else if pack.isJumbo {
            return Pack(pack, (pack.isBuffoon || pack.isSpectral) ? 4 : 5, 1)
        } else {
            return Pack(pack, (pack.isBuffoon || pack.isSpectral) ? 2 : 3, 1)
        }
    }
    
    func nextStandardCard(_ ante: Int) -> Card {
        // Enhancement
        var enhancement: Enhancement? = nil
        if random(Functions.stdsetArr[ante]) <= 0.6 {
            //enhancement = "No Enhancement"
        } else {
            enhancement = randchoice(Functions.enhancedstaArr[ante], Functions.ENHANCEMENTS)
        }
        
        // Base
        let base = randchoice(Functions.frontstaArr[ante], Functions.CARDS)
        
        // Edition
        var edition: Edition = .NoEdition
        
        let editionPoll = random(Functions.standard_editionArr[ante])
        
        if editionPoll > 0.988 {
            edition = .Polychrome
        } else if editionPoll > 0.96 {
            edition = .Holographic
        } else if editionPoll > 0.92 {
            edition = .Foil
        }
        
        // Seal
        var seal: Seal = .NoSeal
        
        if random(Functions.stdsealArr[ante]) <= 0.8 {
            seal = .NoSeal
        } else {
            let sealPoll = random(Functions.stdsealtypeArr[ante])
            
            if sealPoll > 0.75 {
                seal = .RedSeal
            } else if sealPoll > 0.5 {
                seal = .BlueSeal
            } else if sealPoll > 0.25 {
                seal = .GoldSeal
            } else {
                seal = .PurpleSeal
            }
        }
        
        return Card(base, enhancement, edition, seal)
    }
    
    func nextArcanaPack(_ size: Int, _ ante: Int) -> [Item] {
        var pack: [Item] = []
        
        for i in 0..<size {
            if isVoucherActive(Voucher.Omen_Globe) && random("omen_globe") > 0.8 {
                pack.append(nextSpectral(Functions.spectralAr2Arr[ante], ante, true))
            } else {
                pack.append(nextTarot(Functions.tarotAr1Arr[ante], ante, true))
            }
            
            if !params.showman {
                lock(pack[i])
            }
        }
        
        if params.showman {
            return pack
        }
        
        for p in pack {
            if p is EditionItem {
                unlock(Specials.THE_SOUL)
                continue
            }
            unlock(p)
        }
        
        return pack
    }
    
    func nextCelestialPack(_ size: Int, _ ante: Int) -> [Item] {
        var pack: [Item] = []
        
        for i in 0..<size {
            pack.append(nextPlanet(Functions.planetpl1lArr[ante], ante, true))
            
            if !params.showman {
                lock(pack[i])
            }
        }
        
        if params.showman {
            return pack
        }
        
        for p in pack {
            unlock(p)
        }
        
        return pack
    }
    
    func nextSpectralPack(_ size: Int, _ ante: Int) -> [Item] {
        var pack: [Item] = []
        
        for i in 0..<size {
            pack.append(nextSpectral(Functions.spectralSpeArr[ante], ante, true))
            if !params.showman {
                lock(pack[i])
            }
        }
        
        if params.showman {
            return pack
        }
        
        for p in pack {
            if p is EditionItem {
                continue
            }
            unlock(p)
        }
        
        return pack
    }
    
    func nextStandardPack(_ size: Int, _ ante: Int) -> [Card] {
        var pack: [Card] = []
        
        for _ in 0..<size {
            pack.append(nextStandardCard(ante))
        }
        
        return pack
    }
    
    func nextBuffoonPack(_ size: Int, _ ante: Int) -> [JokerData] {
        var pack: [JokerData] = []
        
        for i in 0..<size {
            pack.append(
                nextJoker(
                    "buf", joker1Arr: Functions.joker1BufArr,
                    joker2Arr: Functions.joker2BufArr,
                    joker3Arr: Functions.joker3BufArr,
                    joker4Arr: Functions.joker4BufArr,
                    rarityArr: Functions.rarityBufArr, editionArr: Functions.editionShoArr, ante,
                    true))
            if !params.showman {
                lock(pack[i].joker)
            }
        }
        
        if params.showman {
            return pack
        }
        
        for p in pack {
            unlock(p.joker)
        }
        
        return pack
    }
    
    // Misc methods
    func isVoucherActive(_ voucher: Voucher) -> Bool {
        return params.vouchers.contains(voucher)
    }
    
    func activateVoucher(_ voucher: Voucher) {
        params.vouchers.insert(voucher)
        lock(voucher)
        // Unlock next level voucher
        for i in stride(from: 0, to: Functions.VOUCHERS.count, by: 2) {
            if Functions.VOUCHERS[i] == voucher {
                unlock(Functions.VOUCHERS[i + 1])
            }
        }
    }
    
    func nextVoucher(_ ante: Int) -> Voucher {
        return randchoice(Functions.VoucherArr[ante], Functions.VOUCHERS)
    }
    
    func setDeck(_ deck: Deck) {
        params.deck = deck
        switch deck {
        case .MAGIC_DECK:
            activateVoucher(.Crystal_Ball)
            break
        case .NEBULA_DECK:
            activateVoucher(.Telescope)
            break
        case .ZODIAC_DECK:
            activateVoucher(.Tarot_Merchant)
            activateVoucher(.Planet_Merchant)
            activateVoucher(.Overstock)
            break
        default:
            break
        }
    }
    
    func nextTag(_ ante: Int) -> Tag {
        return randchoice(Functions.TagArr[ante], Functions.TAGS)
    }
    
    func nextBoss(_ ante: Int) -> Boss {
        var bossPool: [Boss] = []
        var numBosses = 0
        
        // First pass: Try to find unlocked bosses
        for boss in Functions.BOSSES {
            if !isLocked(boss) {
                if (ante % 8 == 0 && !boss.startsWithT)
                    || (ante % 8 != 0 && boss.startsWithT)
                {
                    bossPool.append(boss)
                    numBosses += 1
                }
            }
        }
        
        // If no bosses found, unlock appropriate bosses and try again
        if numBosses == 0 {
            for boss in Functions.BOSSES {
                if (ante % 8 == 0 && !boss.startsWithT)
                    || (ante % 8 != 0 && boss.startsWithT)
                {
                    unlock(boss)
                }
            }
            return nextBoss(ante)
        }
        
        let chosenBoss = randchoice("boss", bossPool)
        lock(chosenBoss)
        return chosenBoss
    }
    
    static let planetShoArr: [String] = construct(pattern: "Planetsho%d")
    static let planetpl1lArr: [String] = construct(pattern: "Planetpl1%d")
    static let tarotShoArr: [String] = construct(pattern: "Tarotsho%d")
    static let tarotAr1Arr: [String] = construct(pattern: "Tarotar1%d")
    static let tarotarArr: [String] = construct(pattern: "Tarotar%d")
    
    static let spectralShoArr: [String] = construct(pattern: "Spectralsho%d")
    static let spectralAr2Arr: [String] = construct(pattern: "Spectralar2%d")
    static let spectralSpeArr: [String] = construct(pattern: "Spectralspe%d")
    
    static let joker4ShoArr: [String] = construct(pattern: "Joker4sho%d")
    static let joker4BufArr: [String] = construct(pattern: "Joker4buf%d")
    static let joker4SouArr: [String] = construct(pattern: "Joker4sou%d")
    
    static let joker3ShoArr: [String] = construct(pattern: "Joker3sho%d")
    static let joker3BufArr: [String] = construct(pattern: "Joker3buf%d")
    static let joker3SouArr: [String] = construct(pattern: "Joker3sou%d")
    
    static let joker2ShoArr: [String] = construct(pattern: "Joker2sho%d")
    static let joker2BufArr: [String] = construct(pattern: "Joker2buf%d")
    static let joker2SouArr: [String] = construct(pattern: "Joker2sou%d")
    
    static let joker1ShoArr: [String] = construct(pattern: "Joker1sho%d")
    static let joker1BufArr: [String] = construct(pattern: "Joker1buf%d")
    static let joker1SouArr: [String] = construct(pattern: "Joker1sou%d")
    
    static let rarityShoArr: [String] = construct(pattern: "rarity%dsho")
    static let rarityBufArr: [String] = construct(pattern: "rarity%dbuf")
    static let raritySouArr: [String] = construct(pattern: "rarity%dsou")
    static let editionShoArr: [String] = construct(pattern: "edisho%d")
    static let editionBufArr: [String] = construct(pattern: "edibuf%d")
    static let editionSouArr: [String] = construct(pattern: "edisou%d")
    
    static let packssjrArr: [String] = construct(pattern: "packssjr%d")
    static let etperpollArr: [String] = construct(pattern: "etperpoll%d")
    static let packetperArr: [String] = construct(pattern: "packetper%d")
    static let stake_shop_joker_eternalArr: [String] = construct(
        pattern: "stake_shop_joker_eternal%d")
    static let ssjpArr: [String] = construct(pattern: "ssjp%d")
    static let ssjrArr: [String] = construct(pattern: "ssjr%d")
    static let shop_packArr: [String] = construct(pattern: "shop_pack%d")
    static let stdsetArr: [String] = construct(pattern: "stdset%d")
    static let standard_editionArr: [String] = construct(pattern: "standard_edition%d")
    static let enhancedstaArr: [String] = construct(pattern: "Enhancedsta%d")
    static let stdsealArr: [String] = construct(pattern: "stdseal%d")
    static let stdsealtypeArr: [String] = construct(pattern: "stdsealtype%d")
    static let frontstaArr: [String] = construct(pattern: "frontsta%d")
    static let soul_SpectralArr: [String] = construct(pattern: "soul_Spectral%d")
    static let soul_PlanetArr: [String] = construct(pattern: "soul_Planet%d")
    static let soul_TarotArr: [String] = construct(pattern: "soul_Tarot%d")
    static let cdtArr: [String] = construct(pattern: "cdt%d")
    static let VoucherArr: [String] = construct(pattern: "Voucher%d")
    static let TagArr: [String] = construct(pattern: "Tag%d")
    
    private static func construct(pattern: String) -> [String] {
        var arr: [String] = []
        for ante in 0..<31 {
            arr.append(String(format: pattern, ante))
        }
        return arr
    }
}

