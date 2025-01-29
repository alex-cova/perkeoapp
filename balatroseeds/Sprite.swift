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
    
    func readJokers() -> [Sprite] {
        loadJSONFromAssets(filename: "jokers.json", type: [Sprite].self) ?? []
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
