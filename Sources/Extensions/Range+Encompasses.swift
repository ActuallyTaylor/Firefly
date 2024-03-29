//
//  Range+Encompasses.swift
//  Firefly
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
    
    func touches(r2: NSRange) -> Bool {
        let r1 = self
        return r1.intersection(r2) != nil
        /*
         if r1 == r2 { return true }

         let l1 = r1.lowerBound,
             l2 = r2.lowerBound

         let u1 = r1.upperBound,
             u2 = r2.upperBound


         if l1 <= l2 && l2 <= u1 && u1 <= u2 {
             return true
         }
         if l2 <= l1 && l1 <= u2 && u2 <= u1 {
             return true
         }
         if l2 <= l1 && u1 <= u2 {
             return true
         }
         if l1 <= l2 && u2 <= u1 {
             return true
         }
         return false

         */
    }
    
    func touches(ranges: [NSRange]) -> Bool {
        let r1 = self
        for r in ranges {
            if r1.touches(r2: r) {
                return true
            }
        }
        return false
    }

}

