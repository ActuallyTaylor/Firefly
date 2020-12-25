//
//  Definition.swift
//  
//
//  Created by Zachary lineman on 12/24/20.
//

import UIKit

struct Definition {
    var type: String
    var regex: String
    var group: Int
    var relevance: Int
    var matches: [NSRegularExpression.Options]
}

