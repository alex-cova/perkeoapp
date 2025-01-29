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
            .performAnalysis(seed: "8Q47WV6K")
        
        let end = DispatchTime.now().uptimeNanoseconds / 1_000_000
        
        print("\(end - start) ms")
            
        print(result.toJson())
    }
    
    @Test func analyze2() async throws {
        
        let start = DispatchTime.now().uptimeNanoseconds / 1_000_000
        let result = Balatro()
            .performAnalysis(seed: "1234")
        
        let end = DispatchTime.now().uptimeNanoseconds / 1_000_000
        
        print("\(end - start) ms")
            
        print(result.toJson())
    }

}
