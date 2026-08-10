//
//  Sprite.swift
//  balatroseeds
//
//  Created by Alex on 25/01/25.
//

import Foundation

class Pos : Decodable,Encodable {
    var x : Int = 0
    var y : Int = 0
}

class Sprite : Decodable, Encodable {
    var name = ""
    var pos : Pos = Pos()
}

class SpriteSheet {
    
    var jokers : [Sprite] = []
    var tarots : [Sprite] = []
    var tags : [Sprite] = []
    var vouchers : [Sprite] = []
    var bosses : [Sprite] = []

    private var jokerByName: [String: Sprite] = [:]
    private var tarotByName: [String: Sprite] = [:]
    private var voucherByName: [String: Sprite] = [:]
    private var tagByName: [String: Sprite] = [:]
    private var bossByName: [String: Sprite] = [:]
        
    public func readBosses() -> [Sprite] {
        if(!bosses.isEmpty){
            return bosses
        }
        
        bosses = loadJSONFromAssets(filename: "bosses", type: [Sprite].self) ?? []
        bossByName = Dictionary(uniqueKeysWithValues: bosses.map { ($0.name, $0) })
        return bosses
    }

    public func boss(named name: String) -> Sprite? {
        _ = readBosses()
        return bossByName[name]
    }
    
    public func readVouchers() -> [Sprite] {
        if(!vouchers.isEmpty){
            return vouchers
        }
        
        vouchers = loadJSONFromAssets(filename: "vouchers", type: [Sprite].self) ?? []
        voucherByName = Dictionary(uniqueKeysWithValues: vouchers.map { ($0.name, $0) })
        return vouchers
    }

    public func voucher(named name: String) -> Sprite? {
        _ = readVouchers()
        return voucherByName[name]
    }
    
    public func readTarots() -> [Sprite] {
        if(!tarots.isEmpty) {
            return tarots
        }
        tarots = loadJSONFromAssets(filename: "tarots", type: [Sprite].self) ?? []
        tarotByName = Dictionary(uniqueKeysWithValues: tarots.map { ($0.name, $0) })
        return tarots
    }

    public func tarot(named name: String) -> Sprite? {
        _ = readTarots()
        return tarotByName[name]
    }
    
    public func readTags() -> [Sprite] {
        if(!tags.isEmpty) {
            return tags
        }
        tags = loadJSONFromAssets(filename: "tags", type: [Sprite].self) ?? []
        tagByName = Dictionary(uniqueKeysWithValues: tags.map { ($0.name, $0) })
        return tags
    }

    public func tag(named name: String) -> Sprite? {
        _ = readTags()
        return tagByName[name]
    }
    
    public func readJokers() -> [Sprite] {
        if(!jokers.isEmpty) {
            return jokers
        }
        jokers = loadJSONFromAssets(filename: "jokers", type: [Sprite].self) ?? []
        jokerByName = Dictionary(uniqueKeysWithValues: jokers.map { ($0.name, $0) })
        return jokers
    }

    public func joker(named name: String) -> Sprite? {
        _ = readJokers()
        return jokerByName[name]
    }
    
    func loadJSONFromAssets<T: Codable>(filename: String, type: T.Type) -> T? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Failed to locate \(filename).json in bundle.")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(T.self, from: data)
            return jsonData
        } catch {
            print("Failed to decode \(filename).json: \(error.localizedDescription)")
            return nil
        }
    }
}
