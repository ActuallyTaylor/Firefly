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
    var cursorPositionChange: ((_ cursorPosition: CGRect?) -> Void)? { get }

    func didChangeText(_ syntaxTextView: FireflyTextView)

    func didChangeSelectedRange(_ syntaxTextView: FireflyTextView, selectedRange: NSRange)

    func textViewDidBeginEditing(_ syntaxTextView: FireflyTextView)
    
    func didClickLink(_ link: String)

    #if canImport(UIKit)
     var implementKeyCommands: (
         keyCommands: (_ selector: Selector) -> [KeyCommand]?,
         receiver: (_ sender: KeyCommand) -> Void
     )? { get }
    #endif
}

// Provide default empty implementations of methods that are optional.
public extension FireflyDelegate {
//    var cursorPositionChange: ((_ cursorPosition: CGRect?) -> Void)? { nil }

    func didChangeText(_ syntaxTextView: FireflyTextView) { }

    func didChangeSelectedRange(_ syntaxTextView: FireflyTextView, selectedRange: NSRange) { }

    func textViewDidBeginEditing(_ syntaxTextView: FireflyTextView) { }
    
    func didClickLink(_ link: String) { }
    
    #if canImport(UIKit)
    var implementUIKeyCommands: (keyCommands: (Selector) -> [KeyCommand]?, receiver: (KeyCommand) -> Void)? { nil }
    #endif
}
