//
//  Play.swift
//  balatroseeds
//
//  Created by Alex on 19/01/25.
//
import Foundation

class Run : Encodable{
    let seed : String
    let antes : [Ante]
    
    init(seed: String, antes: [Ante]) {
        self.seed = seed
        self.antes = antes
    }
    
    func toJson() -> String {
        do {
            return try String(data: JSONEncoder().encode(self),encoding: .utf8)!
        }catch {
            print(error)
        }
        
        return "Failed"
    }
    
    func contains(_ item : Item) -> Bool {
        for ante in antes {
            if ante.contains(item){
                return true
            }
        }
        
        return false
    }
    
    func count(_ item : Item) -> Int? {
        var count = 0
        
        for ante in antes {
            if ante.contains(item){
                count += 1
            }
        }
        
        if count == 0 {
            return nil
        }
        
        return count
    }
    
    
    func jokers() -> [JokerCount] {
        var jokerList : [String:JokerCount] = [:]
        
        for ante in antes {
            for joker in ante.jokers() {
                if jokerList[joker.rawValue] != nil {
                    jokerList[joker.rawValue]!.count += 1
                    if joker.edition != .NoEdition {
                        jokerList[joker.rawValue]!.edition = joker.edition
                    }
                }else {
                    jokerList[joker.rawValue] = JokerCount(joker: joker, count: 1, edition: joker.edition)
                }
            }
        }
        
        return jokerList.values.sorted {$0.count > $1.count || $0.joker is LegendaryJoker }
    }
    
    func tags() -> [Tag] {
        var tags : Set<Tag> = []
        
        for ante in antes {
            tags.formUnion(ante.tags)
        }
        
        return Array(tags)
    }
    
    func vouchers() -> [Voucher] {
        var vouchers : Set<Voucher> = []
        
        for ante in antes {
            vouchers.insert(ante.voucher)
        }
        
        return Array(vouchers)
    }
    
    func spectrals() -> [Spectral] {
        var spectrals : Set<Spectral> = []
        
        for ante in antes {
            for pack in ante.packs {
                if pack.kind == .Spectral {
                    for option in pack.options {
                        if let spec = option.item as? Spectral {
                            spectrals.insert(spec)
                        }
                    }
                }
            }
        }
        
        return Array(spectrals)
    }

}

struct JokerCount : Identifiable {
    var id: String {joker.rawValue}
    let joker : Item
    var count : Int
    var edition : Edition = .NoEdition
}


class Ante : Encodable, Identifiable {
    
    var id : Int {ante}
    let ante : Int
    let functions : Functions
    var shopQueue : [SearchableItem] = []
    var shop : Set<String> = []
    var tags : Set<Tag> = []
    var boss : Boss = .Amber_Acorn
    var packs : [Pack] = []
    var voucher : Voucher = .Nacho_Tong
    var legendaries : [JokerData]?
    
    init(ante : Int, functions : Functions){
        self.ante = ante
        self.functions = functions
    }
    
    enum CodingKeys: String, CodingKey {
        case ante
        case shopQueue
        case tags
        case boss
        case packs
        case voucher
    }
    
    func jokers() -> [EditionItem] {
        var jokerList : [EditionItem] =  []
        
        _ = hasLegendary(LegendaryJoker.Perkeo)
        
        legendaries?.forEach {
            jokerList.append($0.asEditionItem())
        }
        
        for pack in packs {
            if(pack.kind == .Buffoon){
                pack.options.forEach {
                    jokerList.append($0)
                }
            }
        }
        
        for i in shopQueue {
            if(i.item is CommonJoker || i.item is CommonJoker100){
                continue
            }
            
            if(i.item is UnCommonJoker || i.item is UnCommonJoker100 || i.item is UnCommonJoker101C){
                continue
            }
            
            if(i.item is Joker){
                jokerList.append(i.asEditionItem())
            }
        }
        
        return jokerList
    }
    
    func addToQueue(value : ShopItem, sticker : Edition?){
        shop.insert(value.item.rawValue)
        shopQueue.append(SearchableItem(item: value.item, sticker))
    }
    
    func addPack(pack : Pack, options: [EditionItem]){
        pack.options = options
        packs.append(pack)
    }
    
    func hasLegendary(_ joker : LegendaryJoker) -> Bool {
        if let legendaries = legendaries {
            return legendaries.contains {
                $0.joker.rawValue == joker.rawValue
            }
        }else {
            legendaries = []
            
            for pack in packs {
                if pack.kind == .Buffoon || pack.kind == .Standard || pack.kind == .Celestial {
                    continue
                }
                
                for option in pack.options {
                    if option.item is LegendaryJoker {
                        legendaries!.append(JokerData(option.item, "Legendary", option.edition, JokerStickers()))
                    }
                }
            }
            
            return legendaries!.contains {
                $0.joker.rawValue == joker.rawValue
            }
        }
    }
    
    
//    func nextLegendary() -> JokerData? {
//        let jokerData = functions.nextJoker("sou",joker1Arr:  Functions.joker1SouArr,
//                                    joker2Arr: Functions.joker2SouArr,
//                                    joker3Arr: Functions.joker3SouArr,
//                                    joker4Arr: Functions.joker4SouArr,
//                                    rarityArr: Functions.raritySouArr, editionArr: Functions.editionShoArr,  ante, true)
//        
//        if legendaries == nil {
//            legendaries = []
//        }
//        
//        legendaries?.append(jokerData)
//        functions.lock(jokerData.joker)
//        
//        return jokerData
//    }
    
    func contains(_ item : Item) -> Bool {
        if let legendary = item as? LegendaryJoker {
            return hasLegendary(legendary)
        }
        
        if let voucher = item as? Voucher {
            if voucher == self.voucher {
                return true
            }
        }
        
        if let tag = item as? Tag {
            return tags.contains(where: { $0 == tag })
        }
        
        if shop.contains(item.rawValue) {
            return true
        }
        
        if hasInPack(item) {
            return true
        }
        
        return false
    }
    
    func hasInPack(_ item : Item) -> Bool {
        if let legendary = item as? LegendaryJoker {
            return hasLegendary(legendary)
        }
        
        for pack in packs {
            if(pack.containsOption(item.rawValue)){
                return true
            }
        }
        
        return false
    }
    
    func countInPack(_ item : Item) -> Int {
        var count = 0
        
        for pack in packs {
            for option in pack.options {
                if(option.item.rawValue == item.rawValue){
                    count += 1
                }
            }
        }
        
        return count
    }
    
}

class SearchableItem : Encodable, Identifiable {
    let item : Item
    let edition : Edition?
    
    init(item: Item, _ edition: Edition?) {
        self.item = item
        self.edition = edition
    }
    
    enum CodingKeys: String, CodingKey {
        case item
        case edition
    }
    
    func asEditionItem() -> EditionItem {
        return EditionItem(edition: edition ?? .NoEdition, item)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(item.rawValue, forKey: .item)
        if let edition = edition {
            try container.encode(edition.rawValue, forKey: .edition)
        }
    }
}
