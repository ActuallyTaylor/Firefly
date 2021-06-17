//
//  TypeAlias.swift
//  Firefly
//
//  Created by Zachary lineman on 6/15/21.
//

import SwiftUI

#if canImport(AppKit)
import AppKit

public typealias FireflyView = NSView
public typealias Color = NSColor
public typealias Font = NSFont
public typealias Image = NSImage
public typealias TextView = NSTextView
public typealias BezierPath = NSBezierPath
public typealias ScrollView = NSScrollView
public typealias Screen = NSScreen
public typealias Window = NSWindow
public typealias EdgeInsets = NSEdgeInsets
//public typealias TextPosition =
public typealias TextViewDelegate = NSTextViewDelegate

public typealias ViewRepresentable = NSViewRepresentable

#elseif canImport(UIKit)
import UIKit

public typealias FireflyView = UIView
public typealias Color = UIColor
public typealias Font = UIFont
public typealias Image = UIImage
public typealias TextView = UITextView
public typealias BezierPath = UIBezierPath
public typealias ScrollView = UIScrollView
public typealias Screen = UIScreen
public typealias Window = UIWindow
public typealias EdgeInsets = UIEdgeInsets
//public typealias TextRange = UITextPosi
public typealias TextViewDelegate = UITextViewDelegate

public typealias ViewRepresentable = UIViewRepresentable

#endif

#if canImport(AppKit)
extension NSColor {
    static var label: NSColor {
        return NSColor.labelColor
    }
    
    static var systemBackground: NSColor {
        return NSColor.textBackgroundColor
    }
}

extension NSTextView {
    var text: String {
        get {
            return self.string
        }
        set {
            self.string = newValue
        }
    }
}

extension NSFont {
    //TODO: Implement This
    static func italicSystemFont(ofSize fontSize: CGFloat) -> NSFont {
        return NSFont.systemFont(ofSize: fontSize)
    }
}

extension NSView {
    func isDarkMode() -> Bool {
        return self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }
}
#endif
