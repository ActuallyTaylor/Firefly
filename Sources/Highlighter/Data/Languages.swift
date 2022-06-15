//
//  Data.swift
//  Firefly
//
//  Created by Zachary lineman on 12/24/20.
//

import Foundation
//TODO: if( is matched as a function not a keyword. Figure out a system to match if as a keyword not a function
var languages: [String: [String: Any]] = [
    "default": defaultLanguage,
    "jelly": jellyLanguage,
    "swift": swiftLanguage
]
public var fireflyLanguages: [String: [String: Any]] {
    get {
        languages
    }
    set {
        languages = newValue
    }
}

let defaultLanguage: [String: Any] = [
    "display_name": "Generic",
    "string": [
        "regex": #"(?<!\\)".*?(?<!\\)""#,
        "group": 0,
        "relevance": 3,
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
        "regex": "(?<!:)\\/\\/.*?(\n|$)", // The regex used for highlighting
        "group": 0, // The regex group that should be highlighted
        "relevance": 5, // The relevance over other tokens
        "options": [], // Regular expression options
        "multiline": false // If the token is multiline
    ],
    "multi_comment": [
        "regex": "/\\*.*?\\*/", // The regex used for highlighting
        "group": 0, // The regex group that should be highlighted
        "relevance": 5, // The relevance over other tokens
        "options": [NSRegularExpression.Options.dotMatchesLineSeparators],  // Regular expression options
        "multiline": true // If the token is multiline
    ],
]

let jellyLanguage: [String: Any] = [
    "display_name": "Jelly",
    "function": [
        "regex": "([a-zA-Z_0-9\"\\[\\]\\+-]+)\\(.*?\\)",//\\. -Removed
        "group": 1,
        "relevance": 0,
        "options": [],
        "multiline": false
    ],
    "keyword": [
        "regex": "(#[a-zA-Z_0-9\"\\.\\[\\]\\+-]+|\\b(return|true|false|while|macro|func|if|else|menu|get|var|list|dictionary|repeat|nil|repeatEach|Get|import)\\b)",
        "group": 0,
        "relevance": 2,
        "options": [],
        "multiline": false
    ],
    "identifier": [
        "regex": "\\.as|\\.key|\\.get",
        "group": 0,
        "relevance": 1,
        "options": [],
        "multiline": false
    ],
    "string": [
        "regex": #"(?<!\\)".*?(?<!\\)""#,
        "group": 0,
        "relevance": 6,
        "options": [],
        "multiline": false
    ],
    "mult_string": [
        "regex": "\"\"\"(.*?)\"\"\"",
        "group": 0,
        "relevance": 6,
        "options": [NSRegularExpression.Options.dotMatchesLineSeparators],
        "multiline": true
    ],
    "comment": [
        "regex": "(?<!:)\\/\\/.*?(\n|$)",
        "group": 0,
        "relevance": 4,
        "options": [],
        "multiline": false
    ],
    "multi_comment": [
        "regex": "/\\*.*?\\*/",
        "group": 0,
        "relevance": 7,
        "options": [NSRegularExpression.Options.dotMatchesLineSeparators],
        "multiline": true
    ]
]

let swiftLanguage: [String: Any] = [
    "display_name": "Swift",
    "identifier": [
        "regex": "(\\.[A-Za-z_]+\\w*)|((NS|UI)[A-Z][a-zA-Z]+)|((println|print)(?=\\())|(Any|Array|AutoreleasingUnsafePointer|BidirectionalReverseView|Bit|Bool|CFunctionPointer|COpaquePointer|CVaListPointer|Character|CollectionOfOne|ConstUnsafePointer|ContiguousArray|Data|Dictionary|DictionaryGenerator|DictionaryIndex|Double|EmptyCollection|EmptyGenerator|EnumerateGenerator|FilterCollectionView|FilterCollectionViewIndex|FilterGenerator|FilterSequenceView|Float|Float80|FloatingPointClassification|GeneratorOf|GeneratorOfOne|GeneratorSequence|HeapBuffer|HeapBuffer|HeapBufferStorage|HeapBufferStorageBase|ImplicitlyUnwrappedOptional|IndexingGenerator|Int|Int16|Int32|Int64|Int8|IntEncoder|LazyBidirectionalCollection|LazyForwardCollection|LazyRandomAccessCollection|LazySequence|Less|MapCollectionView|MapSequenceGenerator|MapSequenceView|MirrorDisposition|ObjectIdentifier|OnHeap|Optional|PermutationGenerator|QuickLookObject|RandomAccessReverseView|Range|RangeGenerator|RawByte|Repeat|ReverseBidirectionalIndex|Printable|ReverseRandomAccessIndex|SequenceOf|SinkOf|Slice|StaticString|StrideThrough|StrideThroughGenerator|StrideTo|StrideToGenerator|String|Index|UTF8View|Index|UnicodeScalarView|IndexType|GeneratorType|UTF16View|UInt|UInt16|UInt32|UInt64|UInt8|UTF16|UTF32|UTF8|UnicodeDecodingResult|UnicodeScalar|Unmanaged|UnsafeArray|UnsafeArrayGenerator|UnsafeMutableArray|UnsafePointer|VaListBuilder|Header|Zip2|ZipGenerator2)",
        "group": 0,
        "relevance": 1,
        "options": [],
        "multiline": false
    ],
    "keyword": [
        "regex": "\\b(as|associatedtype|break|case|catch|class|continue|convenience|default|defer|deinit|else|enum|extension|fallthrough|false|fileprivate|final|for|func|get|guard|if|import|in|init|inout|internal|is|lazy|let|mutating|nil|nonmutating|open|operator|override|private|protocol|public|repeat|required|rethrows|return|required|self|set|some|static|struct|subscript|super|switch|throw|throws|true|try|typealias|unowned|var|weak|where|while)\\b",
        "group": 0,
        "relevance": 1,
        "options": [],
        "multiline": false
    ],
    "numbers": [
        "regex": "(?<=(\\s|\\[|,|:))([-]*\\d|\\.|_)+",
        "group": 0,
        "relevance": 0,
        "options": [],
        "multiline": false
    ],
    "string": [
        "regex": #"(?<!\\)".*?(?<!\\)""#,
        "group": 0,
        "relevance": 3,
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
        "regex": "(?<!:)\\/\\/.*?(\n|$)",
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
