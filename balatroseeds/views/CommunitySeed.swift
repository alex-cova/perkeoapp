//
//  CommunitySeed.swift
//  balatroseeds
//
//  Created by Alex on 09/08/26.
//

import Foundation

struct CommunitySeed: Identifiable, Hashable {
    let id: UUID
    let value: String

    static func generateBatch(count: Int = 80) -> [CommunitySeed] {
        (0..<count).map { _ in
            CommunitySeed(id: UUID(), value: Balatro.generateRandomString())
        }
    }
}
