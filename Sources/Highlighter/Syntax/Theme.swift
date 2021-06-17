//
//  Theme.swift
//  
//
//  Created by Zachary lineman on 12/24/20.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct Theme {
    public enum UIStyle {
        case dark
        case light
    }
    
    // Key: Hex Color
    public var defaultFontColor: Color
    public var backgroundColor: Color
    public var currentLine: Color
    public var selection: Color
    public var cursor: Color
    public var colors: [String: Color]
    public var font: Font
    public var style: UIStyle
    public var lineNumber: Color
    public var lineNumber_Active: Color
}
