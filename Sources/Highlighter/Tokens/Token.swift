//
//  Token.swift
//  Firefly
//
//  Created by Zachary lineman on 12/25/20.
//

import Foundation

/// A  type  that stores the data of tokens
/// Tokens represent a range of text, with some extra values
///     **Range** - The range of text
///     **Type** - The type of the token
///     **Is Multiline** - Whether or not the token takes up multiple lines
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
