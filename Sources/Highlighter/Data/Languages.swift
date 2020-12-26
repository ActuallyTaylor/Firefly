//
//  Data.swift
//  Firefly
//
//  Created by Zachary lineman on 12/24/20.
//

import Foundation
//TODO: if( is matched as a function not a keyword. Figure out a system to match if as a keyword not a function
let languages: [String: [String: Any]] = [
    "default": [:],
    "jelly": jellyLanguage
]

let jellyLanguage: [String: Any] = [
    "function": [
        "regex": "([a-zA-Z_0-9\"\\.\\[\\]\\+-]+)\\(",
        "group": 1,
        "relevance": 0,
        "options": [],
        "multiline": false
    ],
    "string": [
        "regex": "\"(.*?)\"",
        "group": 0,
        "relevance": 3,
        "options": [],
        "multiline": false
    ],
    "keyword": [
        "regex": "(#[a-zA-Z_0-9 \"\\.\\[\\]\\+-]+)|(if|else|menu|get|var|list|dictionary|repeat|nil|repeatEach|Get|import)",
        "group": 0,
        "relevance": 2,
        "options": [],
        "multiline": false
    ],
    "literal": [
        "regex": "\\.as|\\.key|\\.get",
        "group": 0,
        "relevance": 1,
        "options": [],
        "multiline": false
    ],
    "mult_string": [
        "regex": "\"\"\"(.*?)\"\"\"",
        "group": 0,
        "relevance": 4,
        "options": [NSRegularExpression.Options.dotMatchesLineSeparators],
        "multiline": true
    ],
    "comment": [
        "regex": "//.*?(\\n|$)",
        "group": 0,
        "relevance": 5,
        "options": [],
        "multiline": false
    ],
    "multi_comment": [
        "regex": "/\\*.*?\\*/",
        "group": 0,
        "relevance": 5,
        "options": [NSRegularExpression.Options.dotMatchesLineSeparators],
        "multiline": true
    ],
]
