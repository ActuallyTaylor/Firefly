//
//  String+Range.swift
//  Firefly
//
//  Created by Zachary lineman on 10/15/20.
//

import Foundation

extension String {
    func nsRange(fromRange range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    init<T: StringProtocol>(fromRange range: NSRange, in fullString: T) {
        let start: String.Index = fullString.index(fullString.startIndex, offsetBy: range.location)
        let end: String.Index = fullString.index(start, offsetBy: range.length)
        self = String(fullString[start..<end])
    }
}
