//
//  TypeExtensions.swift
//  JellyAce
//
//  Created by Zachary lineman on 9/20/20.
//

import UIKit

//MARK: UIColor Extensions
extension UIColor {
    //MARK: Create a UIColor from a hex string
    public convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    //MARK: Get a hex string from a UIColor
    var hexString: String {
        let cgColorInRGB = cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil)!
        let colorRef = cgColorInRGB.components
        let red = colorRef?[0] ?? 0
        let green = colorRef?[1] ?? 0
        let blue = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : green) ?? 0
        let alpha = cgColor.alpha

        var color = String(
            format: "%02lX%02lX%02lX",
            lroundf(Float(red * 255)),
            lroundf(Float(green * 255)),
            lroundf(Float(blue * 255))
        )

        if alpha < 1 {
            color += String(format: "%02lX", lroundf(Float(alpha * 255)))
        }
        return color
    }
}

//MARK: String Extensions
extension String {
    func nsRange(fromRange range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}
