//
//  Util.swift
//  balatroseeds
//
//  Created by Alex on 03/01/25.
//

import Foundation

extension String {
    func charAt(_ i : Int) -> Character {
        let index = self.index(self.startIndex, offsetBy: i)
        return self[index]
    }
    
    func equals(_ another : String) -> Bool {
        self == another
    }
    
    func substring(_ start: Int) -> String {
        return String(self[self.startIndex..<self.index(self.startIndex, offsetBy: start)])
    }
}

extension Set where Element == String {
    static func of(_ elements : String...) -> Set<String>{
        return Set(elements)
    }
}

class Util {
    
    static let inv_prec : Double = pow(10, 13)
    static let two_inv_prec : Double = pow(2, 13)
    static let five_inv_prec : Double = pow(5, 13)
    
    static func fract(_ n : Double) -> Double {
        n - floor(n)
    }
    
    static func round13(_ x : Double) -> Double {
        let tentative = floor(x * inv_prec) / inv_prec
        let truncated = ((x * two_inv_prec).truncatingRemainder(dividingBy: 1.0)) * five_inv_prec
                
        if(tentative != x && tentative != nextafter(x, 1) && truncated.truncatingRemainder(dividingBy: 1.0) >= 0.5) {
            return (floor(x * inv_prec) + 1) / inv_prec
        }
        
        return tentative
    }
    
    static func pseudohash(_ s : String) -> Double {
        var num : Double = 1
        
        for i in (0..<s.count).reversed() {
            let index = s.index(s.startIndex, offsetBy: i)
            let character = s[index]
            let r = Double(character.asciiValue!)
            num = fract(1.1239285023 / num * r * 3.141592653589793 + 3.141592653589793 * Double(i + 1))
        }
        
        if(num.isNaN) {
            return Double.nan
        }
        
        return num
    }
}
