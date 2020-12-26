//
//  Range+Encompasses.swift
//  JellyAce
//
//  Created by Zachary lineman on 10/16/20.
//

import Foundation

extension NSRange {
    
    func encompasses(r2: NSRange) -> Bool {
        let r1 = self
        if r1 == r2 { return false }
        if (r1.lowerBound <= r2.lowerBound) && (r1.upperBound >= r2.upperBound) {
            return true
        }
        return false
    }
    
    func overlaps(range: NSRange) -> Bool {
        let r1 = self
        return range.encompasses(r2: r1)
    }
    
    func overlaps(ranges: [NSRange]) -> Bool {
        let r1 = self
        for r in ranges {
            return r.encompasses(r2: r1)
        }
        return false
    }
}

