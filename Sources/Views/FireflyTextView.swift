//
//  FireflyTextView.swift
//  Refly
//
//  Created by Zachary lineman on 9/28/20.
//

import UIKit

public class FireflyTextView: UITextView {
    var gutterWidth: CGFloat = 20 {
        didSet {
            textContainerInset = UIEdgeInsets(top: 0, left: gutterWidth, bottom: 0, right: 0)
        }
    }
}
