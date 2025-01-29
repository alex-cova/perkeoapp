//
//  LuaRandom.swift
//  balatroseeds
//
//  Created by Alex on 03/01/25.
//

class DoubleLong {
    private var bits : UInt64
    
    init(bits: Double) {
        self.bits = UInt64(bits)
    }
    
    init(_ bits: UInt64){
        self.bits = bits
    }
    
    func asDouble() -> Double {
        return Double(bitPattern: bits)
    }
    
    func setLong(_ l: UInt64) {
        bits = l
    }
    
    func setDouble(_ d : Double) {
        bits = d.bitPattern
    }
    
    func getLong() -> UInt64 {
        return bits
    }
}

class LuaRandom {
    
    static let MAX_UINT64 = UInt64.max
    
    private static func _randInt(_ s: Double) -> UInt64 {
        var state : UInt64
        var  randint : UInt64  = 0
        var seed = s
        
        var r : UInt64 = 0x11090601
        
        var m : UInt64 = 1 << (r & 255)
        r >>= 8
        seed = seed * 3.14159265358979323846
        seed = seed + 2.7182818284590452354
        
        var u = DoubleLong(bits: seed)
        
        if (u.getLong() < m) {
            u.setLong(u.getLong() + m)
        }
        
        state = u.getLong()
        
        for i in 0..<11 {
            state = (((state << 31) ^ state) >> 45) ^ ((state & (MAX_UINT64 << 1)) << 18)
        }
        
        randint ^= state
        
        //State[1]
        m = 1 << (r & 255)
        r >>= 8
        seed = seed * 3.14159265358979323846
        seed = seed + 2.7182818284590452354
        
        u = DoubleLong(bits: seed)
        
        if (u.getLong() < m) {
            u.setLong(u.getLong() + m)
        }
        
        state = u.getLong()
        
        for i in 0..<11 {
            state = (((state << 19) ^ state) >> 30) ^ ((state & (MAX_UINT64 << 6)) << 28)
        }
        
        randint ^= state
        
        //State[2]
        m = 1 << (r & 255)
        r >>= 8
        seed = seed * 3.14159265358979323846
        seed = seed + 2.7182818284590452354
        
        u =  DoubleLong(bits: seed)
        
        if (u.getLong() < m) {
            u.setLong(u.getLong() + m)
        }
        
        state = u.getLong()
        
        
        for i in 0..<11 {
            state = (((state << 24) ^ state) >> 48) ^ ((state & (MAX_UINT64 << 9)) << 7)
        }
        
        randint ^= state
        
        //state 3
        m = 1 << (r & 255)
        r >>= 8
        seed = seed * 3.14159265358979323846
        seed = seed + 2.7182818284590452354
        
        u =  DoubleLong(bits: seed)
        
        if (u.getLong() < m) {
            u.setLong(u.getLong() + m)
        }
        
        state = u.getLong()
        
        for i in 0..<11 {
            state = (((state << 21) ^ state) >> 39) ^ ((state & (MAX_UINT64 << 17)) << 8)
        }
        
        randint ^= state
        
        return randint
    }
    
    private static func randdblmem(_ seed: Double) -> UInt64 {
        (_randInt(seed) & 4503599627370495) | 4607182418800017408
    }
    
    static func random(seed: Double) -> Double {
        let u = DoubleLong(randdblmem(seed))
        return u.asDouble() - 1.0
    }
    
    static func randint(seed: Double, _ min : Int,_ max : Int) -> Int {
        return Int(LuaRandom.random(seed: seed) * Double(max - min + 1)) + min
    }
}
