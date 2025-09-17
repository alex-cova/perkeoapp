//
//  Intents.swift
//  balatroseeds
//
//  Created by Alejandro Covarrubias on 09/09/25.
//

import AppIntents
import UIKit

struct CopyRandomStringIntent: AppIntent {

    static var title: LocalizedStringResource = "Random Seed"
        static var description =
            IntentDescription("Generates a seed and copies it to the clipboard.")

        func perform() async throws -> some IntentResult & ProvidesDialog {
            let randomString = Balatro.generateRandomString()
            UIPasteboard.general.string = randomString
            return .result(dialog: "Copied random seed: \(randomString)")
        }
}

struct MyShortcuts: AppShortcutsProvider {
    //static var appShortcuts: [AppShortcut]
    
    static var appShortcuts: [AppShortcut] {
            AppShortcut(
                intent: CopyRandomStringIntent(),
                phrases: [
                    "Copy random seed in \(.applicationName)",
                    "Generate random seed in \(.applicationName)"
                ],
                shortTitle: "Random Seed",
                systemImageName: "doc.on.clipboard"
            )
    }
    
}
