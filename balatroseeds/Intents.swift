//
//  Intents.swift
//  balatroseeds
//
//  Created by Alejandro Covarrubias on 09/09/25.
//

import AppIntents
import UIKit

struct CopyRandomStringIntent: AppIntent {
    static var title: LocalizedStringResource = "Copy Random Seed"
    static var description =
        IntentDescription("Generates a seed and copies it to the clipboard.")

    func perform() async throws -> some IntentResult {
        let randomString = Balatro.generateRandomString()
        UIPasteboard.general.string = randomString
        return .result(dialog: "Copied random seed: \(randomString)")
    }   
}
