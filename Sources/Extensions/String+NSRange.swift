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
}
