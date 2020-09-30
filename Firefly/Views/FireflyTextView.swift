//
//  FireflyTextView.swift
//  Refly
//
//  Created by Zachary lineman on 9/28/20.
//

import UIKit

//MARK: String Extensions
extension String {
    func nsRange(fromRange range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}

class FireflyTextView: UITextView {
    var gutterWidth: CGFloat {
        set(value) { textContainerInset = UIEdgeInsets(top: 0, left: value, bottom: 0, right: 0) }
        get { return textContainerInset.left }
    }
}
