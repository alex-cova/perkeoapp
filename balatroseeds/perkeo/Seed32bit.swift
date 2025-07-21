//
//  Seed32bit.swift
//  balatroseeds
//
//  Created by Alex on 20/07/25.
//

class Seed32bit {
    static var CHARACTERS_ON: [Character] {
        return Array("L7H1VC549TMO83JSKBNER6GPDF2QUIWA")
    }

    static var CHARACTERS_OFF: [Character] {
        return Array("N6F8ETHC4W5M7PQBSRAILDKUXG9ZYOVJ")
    }

    static func isSeedable(_ value: Int) -> Bool {
        let bitCount = value.nonzeroBitCount
        return bitCount == 8 || bitCount == 24
    }

    func generateSeed() -> String {
        return decode(generateIntSeed())
    }

    func generateIntSeed() -> Int {
        let generateOff = Bool.random()
        return generateSeedWithBits(bitCount: generateOff ? 24 : 8, off: generateOff)
    }

    private func generateSeedWithBits(bitCount: Int, off: Bool) -> Int {
        var value = off ? Int(UInt32.max) : 0

        while value.nonzeroBitCount != bitCount {
            let bit = 1 << Int.random(in: 0..<32)
            value = off ? (value & ~bit) : (value | bit)
        }

        return value
    }

    func encode(_ seed: String) -> Int {
        var valueOn = 0
        var valueOff = Int(UInt32.max)
        var hasOffChar = false

        for c in seed {
            if c > "W" { hasOffChar = true }

            for i in 0..<32 {
                if c == Self.CHARACTERS_ON[i] {
                    valueOn |= (1 << i)
                }
                if c == Self.CHARACTERS_OFF[i] {
                    valueOff &= ~(1 << i)
                }
            }
        }

        if hasOffChar {
            return validateAndReturn(valueOff, expectedBits: 24, seed: seed)
        }

        if valueOn.nonzeroBitCount == 8 && seed == decode(valueOn) {
            return valueOn
        }

        return validateAndReturn(valueOff, expectedBits: 24, seed: seed)
    }

    private func validateAndReturn(_ value: Int, expectedBits: Int, seed: String) -> Int {
        guard value.nonzeroBitCount == expectedBits else {
            fatalError("Not a valid 32-bit seed: \(seed)")
        }
        return value
    }

    func decode(_ value: Int) -> String {
        let bitCount = value.nonzeroBitCount
        guard bitCount == 8 || bitCount == 24 else {
            fatalError("Invalid seed bit count: \(value)")
        }

        var result = ""
        let charset = (bitCount == 8) ? Self.CHARACTERS_ON : Self.CHARACTERS_OFF

        for i in 0..<32 where result.count < 8 {
            let bit = (value >> i) & 1
            let expected = (bitCount == 8) ? 1 : 0
            if bit == expected {
                result.append(charset[i])
            }
        }
        
        return result
    }
}
