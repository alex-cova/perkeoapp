//
//  SeedModel.swift
//  balatroseeds
//
//  Created by Alex on 26/01/25.
//

import Foundation
import SwiftData

@Model
final class SeedModel {
    var timestamp: Date
    var seed : String
    var title : String?
    var level : JokerType?
    var score : Int?
    
    init(timestamp: Date, seed : String, title : String? = nil, level : JokerType? = nil, score : Int? = nil) {
        self.timestamp = timestamp
        self.seed = seed
        self.title = title
        self.level = level
        self.score = score
    }
}
