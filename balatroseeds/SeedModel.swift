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
    
    init(timestamp: Date, seed : String) {
        self.timestamp = timestamp
        self.seed = seed
    }
}
