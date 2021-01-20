//
//  Theme.swift
//  
//
//  Created by Zachary lineman on 12/24/20.
//

import UIKit

public struct Theme {
    public enum UIStyle {
        case dark
        case light
    }
    
    // Key: Hex Color
    public var defaultFontColor: UIColor
    public var backgroundColor: UIColor
    public var currentLine: UIColor
    public var selection: UIColor
    public var cursor: UIColor
    public var colors: [String: UIColor]
    public var font: UIFont
    public var style: UIStyle
}
