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

    var options: [Item] = []

    static let CHARACTERS = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    static func generateRandomString() -> String {
        var result = ""

        for _ in 0..<7 {
            let index = Int.random(in: 0..<CHARACTERS.count)
            result = result + String(CHARACTERS.charAt(index))
        }
        return result
    }

    func indexOf(_ value: String) -> Int {
        for i in 0..<options.count {
            if options[i].rawValue == value {
                return i
            }
        }
        return -1
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
    var analyzeBuffon = true
    var maxDepth = 8
    var startingAnte = 1
    var version : Version = .v_101f
    var deck = Deck.RED_DECK
    var stake = Stake.White_Stake
    var showman = false
    
    func performAnalysis(seed: String) -> Run {
        var cards: [Int] = Array(repeating: 50, count: maxDepth)
        cards[0] = 15
        return performAnalysis(maxDepth, cards, deck, stake, version, seed)
    }


    func performAnalysis(
        _ maxDepth: Int, _ cardsPerAnte: [Int], _ deck: Deck, _ stake: Stake, _ version: Version,
        _ seed: String
    ) -> Run {
        let inst = Functions(seed, maxDepth)

        inst.setParams(InstanceParams(deck, stake, showman, 1, version))
        inst.initLocks(1, false, true)
        inst.firstLock()

        for option in options {
            inst.lock(option)
        }

        inst.setDeck(deck)
        var antes: [Ante] = []

        for a in startingAnte...maxDepth {
            let play = Ante(ante: a, functions: inst)
            antes.append(play)
            inst.initUnlocks(a, false)

            if analyzeBoss {
                play.boss = inst.nextBoss(a)
            }

            if analyzeVoucher {
                let voucher = inst.nextVoucher(a)
                play.voucher = voucher

                inst.lock(voucher)

                // Unlock next level voucher
                for i in stride(from: 0, to: Functions.VOUCHERS.count, by: 2) {
                    if Functions.VOUCHERS[i] == voucher {
                        // Only unlock it if it's unlockable
                        if !options.contains(where: { $0.rawValue == Functions.VOUCHERS[i + 1].rawValue}) {
                            inst.unlock(Functions.VOUCHERS[i + 1])
                        }
                    }
                }
            }

            if analyzeTags {
                play.tags.insert(inst.nextTag(a))
                play.tags.insert(inst.nextTag(a))
            }

            if analyzeShop {
                for _ in stride(from: 1, to: cardsPerAnte[a - 1], by: 1) {
                    var sticker: Edition?

                    let item = inst.nextShopItem(a)

                    if item.type == .Joker {
                        if item.jokerData.stickers.eternal {
                            sticker = .Eternal
                        }
                        if item.jokerData.stickers.perishable {
                            sticker = .Perishable
                        }
                        if item.jokerData.stickers.rental {
                            sticker = .Rental
                        }
                        if item.jokerData.edition != .NoEdition {
                            sticker = item.jokerData.edition
                        }
                    }

                    play.addToQueue(value: item, sticker: sticker)
                }
            }

            let numPacks = (a == 1) ? 4 : 6

            for _ in (1...numPacks) {
                let pack = inst.nextPack(a)
                let packInfo = inst.packInfo(pack)
                var options: [EditionItem] = []

                switch pack.kind {
                case .Celestial:
                    if !analyzeCelestial {
                        continue
                    }

                    let cards = inst.nextCelestialPack(packInfo.size, a)
                    for c in 0..<packInfo.size {
                        options.append(EditionItem(cards[c]))
                    }
                case .Arcana:
                    if !analyzeArcana {
                        continue
                    }

                    let cards = inst.nextArcanaPack(packInfo.size, a)
                    
                    for c in cards {
                        if c is EditionItem {
                            options.append(c as! EditionItem)
                            continue
                        }
                        
                        options.append(EditionItem(c))
                    }
                case .Spectral:
                    if !analyzeSpectralss {
                        continue
                    }

                    let cards = inst.nextSpectralPack(packInfo.size, a)
                    
                    for c in cards {
                        if c is EditionItem {
                            options.append(c as! EditionItem)
                            continue
                        }
                        
                        options.append(EditionItem(c))
                    }
                case .Buffoon:
                    if !analyzeBuffon {
                        continue
                    }

                    let cards = inst.nextBuffoonPack(packInfo.size, a)

                    for c in 0..<packInfo.size {
                        let joker = cards[c]
                        let edition = Balatro.getEdition(joker)

                        options.append(EditionItem(edition: edition, joker.joker))

                    }

                case .Standard:
                    if !analyzeStandard {
                        continue
                    }

                    let cards = inst.nextStandardPack(packInfo.size, a)
                    for c in 0..<packInfo.size {
                        let card = cards[c]
                        options.append(EditionItem(card))
                    }
                }

                play.addPack(pack: packInfo, options: options)
            }
        }

        return Run(seed: seed, antes: antes)
    }

    static func getEdition(_ joker: JokerData) -> Edition {
        var edition: Edition? = nil

        if joker.stickers.eternal {
            edition = Edition.Eternal
        }
        if joker.stickers.perishable {
            edition = Edition.Perishable
        }
        if joker.stickers.rental {
            edition = Edition.Rental
        }

        if joker.edition != Edition.NoEdition {
            edition = joker.edition
        }

        return edition ?? .NoEdition
    }
    
    func configureForSpeed(selections: [Item]) -> Balatro {
        analyzeBoss = false
        analyzeStandard = false
        analyzeTags = false
        analyzeSpectralss = false
        analyzeArcana = false
        analyzeBuffon = false

        for selection in selections {
            if selection is LegendaryJoker {
                analyzeArcana = true
                analyzeSpectralss = true
                break
            }

            if selection is Tarot {
                analyzeArcana = true
            }

            if selection is Planet {
                analyzeCelestial = true
            }

            if selection is Tag {
                analyzeTags = true
            }

            if selection is Boss {
                analyzeBoss = true
            }

            if selection is Joker {
                analyzeBuffon = true
            }

            if selection is Voucher {
                analyzeVoucher = true
            }

            if selection is Cards {
                analyzeStandard = true
            }

            if selection is Spectral {
                analyzeCelestial = true
            }
        }

        return self
    }
}
