//
//  GlyphHandler.swift
//  Jellycore
//
//  Created by Zachary lineman on 10/27/20.
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

/// A simple markdown parser
public class Markdown {

    public static func createAttributedString(input: String, themeName: String, fontName: String, themeTColor: Bool = false, shouldTint: Bool = false, fontSize: CGFloat = Font.systemFontSize) -> (string: NSMutableAttributedString, background: Color) {
        let fontSize: CGFloat = fontSize

        var currentFont = Font.systemFont(ofSize: fontSize)
        if fontName == "system" {
            currentFont = Font.systemFont(ofSize: fontSize)
        } else {
            currentFont = Font(name: fontName, size: fontSize) ?? Font.systemFont(ofSize: fontSize)
        }

        var theme: Theme?
        if let nTheme = themes[themeName] {
            let defaultColor = Color(hex: (nTheme["default"] as? String) ?? "#000000")
            let backgroundColor = Color(hex: (nTheme["background"] as? String) ?? "#000000")
            let currentLineColor = Color(hex: (nTheme["currentLine"] as? String) ?? "#000000")
            let selectionColor = Color(hex: (nTheme["selection"] as? String) ?? "#000000")
            let cursorColor = Color(hex: (nTheme["cursor"] as? String) ?? "#000000")
            
            let styleRaw = nTheme["style"] as? String
            let style: Theme.UIStyle = styleRaw == "light" ? .light : .dark
            
            let lineNumber = Color(hex: (nTheme["lineNumber"] as? String) ?? "#000000")
            let lineNumber_Active = Color(hex: (nTheme["lineNumber-Active"] as? String) ?? "#000000")

            var colors: [String: Color] = [:]
            
            if let cDefs = nTheme["definitions"] as? [String: String] {
                for item in cDefs {
                    colors.merge([item.key: Color(hex: (item.value))]) { (first, _) -> Color in return first }
                }
            }
            
            theme = Theme(defaultFontColor: defaultColor, backgroundColor: backgroundColor, currentLine: currentLineColor, selection: selectionColor, cursor: cursorColor, colors: colors, font: currentFont, style: style, lineNumber: lineNumber, lineNumber_Active: lineNumber_Active)
        }
        var tColor = Color.label
        if themeTColor {
            tColor = theme?.defaultFontColor ?? Color.label
        }
        let regularFont = Font.systemFont(ofSize: fontSize)
        let attributedString = NSMutableAttributedString(string: input, attributes: [NSAttributedString.Key.font: regularFont, NSAttributedString.Key.foregroundColor: tColor])

        //MARK: Detect Bold
        let boldFont = Font.boldSystemFont(ofSize: fontSize)
        
        let boldRegex = try? NSRegularExpression(pattern: "(\\*\\*|__)(.*?)(\\*\\*|__)", options: [])
        if let matches = boldRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 2), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        let italicFont = Font.italicSystemFont(ofSize: fontSize)
        let italicRegex = try? NSRegularExpression(pattern: "(_|\\*)(.*?)(_|\\*)", options: [])
        if let matches = italicRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 2), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: italicFont, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        let strikethroughRegex = try? NSRegularExpression(pattern: "~~(.*?)~~", options: [])
        if let matches = strikethroughRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                let nString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: italicFont, NSAttributedString.Key.strikethroughColor : Color.label, NSAttributedString.Key.strikethroughStyle : 2, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        let imageBulletRegex = try? NSRegularExpression(pattern: "(\\t)*(\\*)\\[.*?\\]\\((.*?)\\)", options: [])
        if let matches = imageBulletRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range, in: attributedString.string) else { break }
                var text: String = String(attributedString.string[tRange])
                text.insert("\t", at: text.startIndex)
                
                let attachment = NSTextAttachment()
                guard let gRange = Range(aMatch.range(at: 3), in: attributedString.string) else { break }
                let glyphNumb = attributedString.string[gRange]
                
                attachment.image = Image(named: "\(glyphNumb).png")
                attachment.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
                #if canImport(UIKit)
                if shouldTint {
                    attachment.image = attachment.image?.withTintColor(tColor)
                }
                #endif

                let image = NSAttributedString(attachment: attachment)
                let replacement = NSMutableAttributedString(string: text)
                replacement.replaceCharacters(in: replacement.string.nsRange(fromRange: replacement.string.range(of: "*")!), with: image)
                attributedString.replaceCharacters(in: aMatch.range, with: replacement)
            }
        }
        
        let imageRegex = try? NSRegularExpression(pattern: "\\!\\[.*?\\]\\((.*?)\\)", options: [])
        if let matches = imageRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            for aMatch in matches.reversed() {
                let attachment = NSTextAttachment()
                guard let gRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let glyphNumb = attributedString.string[gRange]
                
                attachment.image = Image(named: "\(glyphNumb).png")
                attachment.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
                
                let replacement = NSAttributedString(attachment: attachment)
                attributedString.replaceCharacters(in: aMatch.range, with: replacement)

            }
        }
        
        let linkRegex = try? NSRegularExpression(pattern: "\\[(.*?)\\]\\((.*?)\\)", options: [])
        if let matches = linkRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
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
        if let matches = bulletRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
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
        if let matches = numberRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range, in: attributedString.string) else { break }
                var text: String = String(attributedString.string[tRange])
                text.insert("\t", at: text.startIndex)
                
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: regularFont, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        let header3Font = Font.systemFont(ofSize: fontSize * 1.7)
        let header3Regex = try? NSRegularExpression(pattern: "### (.*?\n)", options: [])
        if let matches = header3Regex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: header3Font, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        let header2Font = Font.systemFont(ofSize: fontSize * 2.2)
        let header2Regex = try? NSRegularExpression(pattern: "## (.*?\n)", options: [])
        if let matches = header2Regex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: header2Font, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }

        
        let header1Font = Font.systemFont(ofSize: fontSize * 3.2)
        let header1Regex = try? NSRegularExpression(pattern: "# (.*?\n)", options: [])
        if let matches = header1Regex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: header1Font, NSAttributedString.Key.foregroundColor: Color.label])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        if let theme = theme {
            let codeRegex = try? NSRegularExpression(pattern: "(\t)*?(\\`\\`\\`)(.*?)(\\`\\`\\`)", options: [.dotMatchesLineSeparators])
            if let matches = codeRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
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
        
        if let theme = theme {
            let codeRegex = try? NSRegularExpression(pattern: "(\\`)(.*?)(\\`)", options: [.dotMatchesLineSeparators])
            if let matches = codeRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
                for aMatch in matches.reversed() {
                    guard let tRange = Range(aMatch.range(at: 2), in: attributedString.string) else { break }
                    let text: String = String(attributedString.string[tRange])
                    let attrString: NSAttributedString = NSAttributedString(string: text)

                    let nString = Syntax.highlightAttributedString(string: attrString, theme: theme, language: "jelly")
                    nString.addAttributes([.backgroundColor: theme.backgroundColor], range: NSRange(location: 0, length: nString.string.count))
                    attributedString.replaceCharacters(in: aMatch.range, with: nString)
                }
            }
        }

        //|\\` |\\`

        return (attributedString, theme?.backgroundColor ?? Color.systemBackground)
    }
}
