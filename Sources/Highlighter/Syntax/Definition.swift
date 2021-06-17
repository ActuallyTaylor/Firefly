//
//  Definition.swift
//  
//
//  Created by Zachary lineman on 12/24/20.
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

struct Definition {
    var type: String
    var regex: String
    var group: Int
    var relevance: Int
    var matches: [NSRegularExpression.Options]
    var multiLine: Bool
}

