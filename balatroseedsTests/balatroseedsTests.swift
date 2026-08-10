//
//  balatroseedsTests.swift
//  balatroseedsTests
//
//  Created by Alex on 03/01/25.
//

import Testing
import Foundation
@testable import balatroseeds

struct balatroseedsTests {

    @Test func example() async throws {
        let value = LuaRandom.random(seed: 0.0)
        print("Random: \(value)")
        //assert(value == 0.794206292431241)
    }

    @Test func luaRandom() async throws {
        print(LuaRandom.random(seed:0.0409823001603))
        print(LuaRandom.random(seed:0.0409823001604))
    }

    @Test func testPseudohash() async throws {
        print(Util.pseudohash("hello"))
    }

    @Test func testRound13() async throws {
        print(Util.round13(0.04098230016037929))
    }

    @Test func analyze() async throws {

        let start = DispatchTime.now().uptimeNanoseconds / 1_000_000
        let result = Balatro()
            .performAnalysis(seed: "IGSPUNF")

        let end = DispatchTime.now().uptimeNanoseconds / 1_000_000

        print("\(end - start) ms")

        print(result.toJson())
    }

    @Test func finder() async throws {
        for i in 0..<4000 {
            let _ = Balatro()
                .configureForSpeed(selections: [LegendaryJoker.Perkeo])
                .performAnalysis(seed: "IGSPUNF\(i)")
        }
    }

    @Test func test5Souls(){
        let functions = Balatro()
            .functions(seed: "FHSRBAMA")
        
        let editionRate = 1.0
        
        func getEdition(_ editionPoll : Double) -> Edition {
            var edition: Edition = .NoEdition
            if editionPoll > 0.997 {
                edition = .Negative
            } else if editionPoll > (1 - 0.006 * editionRate) {
                edition = .Polychrome
            } else if editionPoll > (1 - 0.02 * editionRate) {
                edition = .Holographic
            } else if editionPoll > (1 - 0.04 * editionRate) {
                edition = .Foil
            }
            
            return edition;
        }
        
        let arr : [Double] = [
            0.4005101425641775
            ,0.9616695513478333
            ,0.35197137316851257
            ,0.4892931628983397
            ,0.07698332800910612
            ,0.13696781567490057
            ,0.3410048032224575
            ,0.2549455538105436
            ,0.31637046752928866
            ,0.7897410648660232
            ,0.8098151078846378
            ,0.42822104501708536
            ,0.2578892029760034
            ,0.6854283252536773
            ,0.19037753666731416
            ,0.22781576997338826
            ,0.6081648633841479
            ,0.2535131814666858
            ,0.6565805743259698
        ]
        
        for i in 1..<20 {
            let v = functions.random(Functions.editionBufArr[1])
            
            if v != arr[i-1] {
                print("\(v) != \(arr[i-1]) <---- ERROR")
            }else {
                print("\(v) == \(arr[i-1]) \(Functions.editionBufArr[1]) \(getEdition(v))")
            }
            
        }
            
    }

    @Test func analyze2() async throws {

        let start = DispatchTime.now().uptimeNanoseconds / 1_000_000
        let result = Balatro()
            .performAnalysis(seed: "1234")

        let end = DispatchTime.now().uptimeNanoseconds / 1_000_000

        print("\(end - start) ms")

        print(result.toJson())
    }

    // `JokerSelectorView` hands `configureForSpeed` an `[ItemEdition]` (a wrapper class), not the
    // raw `Item`s. Before the fix, `enable(_:)` type-checked the wrapper itself, so `is Voucher`
    // (and every other `is` check) was always false and brute-force search could never find a
    // selected voucher, tag, legendary, or spectral.
    @Test func configureForSpeedUnwrapsItemEdition() async throws {
        let balatro = Balatro()
        _ = balatro.configureForSpeed(selections: [ItemEdition(item: Voucher.Overstock)])
        #expect(balatro.analyzeVoucher)
    }

    @Test func itemSearchFindsInitialsAndMidWordMatches() async throws {
        let htr = ItemSearch.sections(query: "htr", categories: [.rare])
        #expect(htr.first?.items.contains { $0.rawValue == "Hit the Road" } == true)

        let clown = ItemSearch.sections(query: "clown", categories: [.common])
        #expect(clown.first?.items.contains { $0.rawValue == "Chaos the Clown" } == true)
    }

}
