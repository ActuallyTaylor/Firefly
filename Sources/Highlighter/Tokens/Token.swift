//
//  Token.swift
//  
//
//  Created by Zachary lineman on 12/25/20.
//

import Foundation

struct Token: Comparable {
    var range: NSRange
    var type: String
    var isMultiline: Bool
    
    static func == (lhs: Token, rhs: Token) -> Bool {
        return (lhs.range == rhs.range) && (lhs.type == rhs.type) && (lhs.isMultiline == rhs.isMultiline)
    }
    static func < (lhs: Token, rhs: Token) -> Bool {
        return (lhs.range.lowerBound < rhs.range.lowerBound) && (lhs.range.upperBound < rhs.range.upperBound) && (lhs.type < rhs.type)

    }
}
