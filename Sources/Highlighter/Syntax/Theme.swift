//
//  Theme.swift
//  Firefly
//
//  Created by Zachary lineman on 12/24/20.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// A type that stores data about a theme
public struct Theme {
    public enum UIStyle {
        case dark
        case light
    }
    
    public var defaultFontColor: FireflyColor
    public var backgroundColor: FireflyColor
    public var currentLine: FireflyColor
    public var selection: FireflyColor
    public var cursor: FireflyColor
    public var colors: [String: FireflyColor]
    public var font: FireflyFont
    public var style: UIStyle
    public var lineNumber: FireflyColor
    public var lineNumber_Active: FireflyColor
}
