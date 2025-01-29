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
    
    public func readBosses() -> [Sprite] {
        if(!bosses.isEmpty){
            return bosses
        }
        
        bosses = loadJSONFromAssets(filename: "bosses", type: [Sprite].self) ?? []
        return bosses
    }
    
    public func readVouchers() -> [Sprite] {
        if(!vouchers.isEmpty){
            return vouchers
        }
        
        vouchers = loadJSONFromAssets(filename: "vouchers", type: [Sprite].self) ?? []
        return vouchers
    }
    
    public func readTarots() -> [Sprite] {
        if(!tarots.isEmpty) {
            return tarots
        }
        tarots = loadJSONFromAssets(filename: "tarots", type: [Sprite].self) ?? []
        return tarots
    }
    
    public func readTags() -> [Sprite] {
        if(!tags.isEmpty) {
            return tags
        }
        tags = loadJSONFromAssets(filename: "tags", type: [Sprite].self) ?? []
        return tags
    }
    
    public func readJokers() -> [Sprite] {
        if(!jokers.isEmpty) {
            return jokers
        }
        jokers = loadJSONFromAssets(filename: "jokers", type: [Sprite].self) ?? []
        return jokers
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
