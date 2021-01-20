//
//  GlyphHandler.swift
//  Jellycore
//
//  Created by Zachary lineman on 10/27/20.
//

import UIKit

/// A simple markdown parsera
public class Markdown {

    public static func createAttributedString(input: String, themeName: String, fontName: String, themeTColor: Bool = false, shouldTint: Bool = false) -> (string: NSMutableAttributedString, background: UIColor) {
        let fontSize: CGFloat = UIFont.systemFontSize

        var currentFont = UIFont.systemFont(ofSize: fontSize)
        if fontName == "system" {
            currentFont = UIFont.systemFont(ofSize: fontSize)
        } else {
            currentFont = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        }

        var theme: Theme?
        if let nTheme = themes[themeName] {
            let defaultColor = UIColor(hex: (nTheme["default"] as? String) ?? "#000000")
            let backgroundColor = UIColor(hex: (nTheme["background"] as? String) ?? "#000000")
            let currentLineColor = UIColor(hex: (nTheme["currentLine"] as? String) ?? "#000000")
            let selectionColor = UIColor(hex: (nTheme["selection"] as? String) ?? "#000000")
            let cursorColor = UIColor(hex: (nTheme["cursor"] as? String) ?? "#000000")
            let styleRaw = nTheme["style"] as? String
            let style: Theme.UIStyle = styleRaw == "light" ? .light : .dark
            
            var colors: [String: UIColor] = [:]
            
            if let cDefs = nTheme["definitions"] as? [String: String] {
                for item in cDefs {
                    colors.merge([item.key: UIColor(hex: (item.value))]) { (first, _) -> UIColor in return first }
                }
            }
            
            theme = Theme(defaultFontColor: defaultColor, backgroundColor: backgroundColor, currentLine: currentLineColor, selection: selectionColor, cursor: cursorColor, colors: colors, font: currentFont, style: style)
        }
        var tColor = UIColor.label
        if themeTColor {
            tColor = theme?.defaultFontColor ?? UIColor.label
        }
        let regularFont = UIFont.systemFont(ofSize: fontSize)
        let attributedString = NSMutableAttributedString(string: input, attributes: [NSAttributedString.Key.font: regularFont, NSAttributedString.Key.foregroundColor: tColor])

        //MARK: Detect Bold
        let boldFont = UIFont.boldSystemFont(ofSize: fontSize)
        
        let boldRegex = try? NSRegularExpression(pattern: "(\\*\\*|__)(.*?)(\\*\\*|__)", options: [])
        if let matches = boldRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.string.utf16.count)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 2), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        let italicFont = UIFont.italicSystemFont(ofSize: fontSize)
        let italicRegex = try? NSRegularExpression(pattern: "(_|\\*)(.*?)(_|\\*)", options: [])
        if let matches = italicRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.string.utf16.count)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 2), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: italicFont, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        let strikethroughRegex = try? NSRegularExpression(pattern: "~~(.*?)~~", options: [])
        if let matches = strikethroughRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.string.utf16.count)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                let nString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: italicFont, NSAttributedString.Key.strikethroughColor : UIColor.label, NSAttributedString.Key.strikethroughStyle : 2, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        let imageBulletRegex = try? NSRegularExpression(pattern: "(\\t)*(\\*)\\[.*?\\]\\((.*?)\\)", options: [])
        if let matches = imageBulletRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.string.utf16.count)) {
            
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range, in: attributedString.string) else { break }
                var text: String = String(attributedString.string[tRange])
                text.insert("\t", at: text.startIndex)
                
                let attachment = NSTextAttachment()
                guard let gRange = Range(aMatch.range(at: 3), in: attributedString.string) else { break }
                let glyphNumb = attributedString.string[gRange]
                
                attachment.image = UIImage(named: "\(glyphNumb).png")
                attachment.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
                if shouldTint {
                    attachment.image = attachment.image?.withTintColor(tColor)
                }
                
                let image = NSAttributedString(attachment: attachment)
                let replacement = NSMutableAttributedString(string: text)
                replacement.replaceCharacters(in: replacement.string.nsRange(fromRange: replacement.string.range(of: "*")!), with: image)
                attributedString.replaceCharacters(in: aMatch.range, with: replacement)
            }
        }
        
        let imageRegex = try? NSRegularExpression(pattern: "\\!\\[.*?\\]\\((.*?)\\)", options: [])
        if let matches = imageRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.string.utf16.count)) {
            for aMatch in matches.reversed() {
                let attachment = NSTextAttachment()
                guard let gRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let glyphNumb = attributedString.string[gRange]
                
                attachment.image = UIImage(named: "\(glyphNumb).png")
                attachment.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
                
                let replacement = NSAttributedString(attachment: attachment)
                attributedString.replaceCharacters(in: aMatch.range, with: replacement)

            }
        }
        
        let linkRegex = try? NSRegularExpression(pattern: "\\[(.*?)\\]\\((.*?)\\)", options: [])
        if let matches = linkRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.string.utf16.count)) {
            for aMatch in matches.reversed() {
                guard let textRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let linkName: String = String(attributedString.string[textRange])
                guard let linkRange = Range(aMatch.range(at: 2), in: attributedString.string) else { break }
                let link: String = String(attributedString.string[linkRange])
                if let url = URL(string: link) {
                    let linkString = NSAttributedString(string: linkName, attributes: [NSAttributedString.Key.link: url, NSAttributedString.Key.font: regularFont])
                    attributedString.replaceCharacters(in: aMatch.range, with: linkString)
                }
            }
        }
        
        let bulletRegex = try? NSRegularExpression(pattern: "(\\t)*(\\*) ", options: [])
        if let matches = bulletRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.string.utf16.count)) {
            let tabArray: [String] = ["•"]
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range, in: attributedString.string) else { break }
                var text: String = String(attributedString.string[tRange])
                let count = text.prefix(while: {$0 == "\t"}).count
                let tab: String = tabArray[count, default: "•"]
                text.insert("\t", at: text.startIndex)

                text = text.replacingOccurrences(of: "*", with: tab)
                
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: regularFont, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        let numberRegex = try? NSRegularExpression(pattern: "(\\d+\\.)(.*)", options: [])
        if let matches = numberRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.string.utf16.count)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range, in: attributedString.string) else { break }
                var text: String = String(attributedString.string[tRange])
                text.insert("\t", at: text.startIndex)
                
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: regularFont, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        let header3Font = UIFont.systemFont(ofSize: fontSize * 1.7)
        let header3Regex = try? NSRegularExpression(pattern: "### (.*?\n)", options: [])
        if let matches = header3Regex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.string.utf16.count)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: header3Font, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        let header2Font = UIFont.systemFont(ofSize: fontSize * 2.2)
        let header2Regex = try? NSRegularExpression(pattern: "## (.*?\n)", options: [])
        if let matches = header2Regex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.string.utf16.count)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: header2Font, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }

        
        let header1Font = UIFont.systemFont(ofSize: fontSize * 3.2)
        let header1Regex = try? NSRegularExpression(pattern: "# (.*?\n)", options: [])
        if let matches = header1Regex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.string.utf16.count)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: header1Font, NSAttributedString.Key.foregroundColor: UIColor.label])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        if let theme = theme {
            let codeRegex = try? NSRegularExpression(pattern: "(\t)*?(\\`\\`\\`|\\`)(.*?)(\\`\\`\\`|\\`)", options: [.dotMatchesLineSeparators])
            if let matches = codeRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.string.utf16.count)) {
                for aMatch in matches.reversed() {
                    guard let tRange = Range(aMatch.range(at: 3), in: attributedString.string) else { break }
                    let text: String = String(attributedString.string[tRange])
                    let attrString: NSAttributedString = NSAttributedString(string: text)

                    let nString = Syntax.highlightAttributedString(string: attrString, theme: theme, language: "jelly")
                    nString.append(NSAttributedString(string: "\n"))
                    nString.addAttributes([.backgroundColor: theme.backgroundColor], range: NSRange(location: 0, length: nString.string.count))
                    attributedString.replaceCharacters(in: aMatch.range, with: nString)
                }
            }
        }

        return (attributedString, theme?.backgroundColor ?? UIColor.systemBackground)
    }
}
