//
//  FireflyDelegate.swift
//  Firefly
//
//  Created by Zachary lineman on 9/29/20.
//  Copyright © 2020 Zachary Lineman. All rights reserved.
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public protocol FireflyDelegate: AnyObject {

    func didChangeText(_ syntaxTextView: FireflyTextView)

    func didChangeSelectedRange(_ syntaxTextView: FireflyTextView, selectedRange: NSRange)

    func textViewDidBeginEditing(_ syntaxTextView: FireflyTextView)
    
    func didClickLink(_ link: String)

}

// Provide default empty implementations of methods that are optional.
public extension FireflyDelegate {
    func didChangeText(_ syntaxTextView: FireflyTextView) { }

    func didChangeSelectedRange(_ syntaxTextView: FireflyTextView, selectedRange: NSRange) { }

    func textViewDidBeginEditing(_ syntaxTextView: FireflyTextView) { }
    
    func didClickLink(_ link: String) { }
}
