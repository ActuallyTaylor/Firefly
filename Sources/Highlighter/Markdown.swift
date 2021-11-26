//
//  GlyphHandler.swift
//  Firefly
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
    
    /// Creates an attributed string of Markdown formatted text
    /// - Parameters:
    ///   - input: The input that should be formatted
    ///   - themeName: The theme used for formatting
    ///   - fontName: The font used for formatting
    ///   - language: The language used for formatting code blocks
    ///   - themeTColor: The tint color of images
    ///   - shouldTint: If images should be tinted
    ///   - fontSize: The font size of the formatted text
    /// - Returns: An NSMutableString which contains the Markdown Formatted string & and the background color that was used when processing.
    public static func createAttributedString(input: String, themeName: String, fontName: String, language: String, themeTColor: Bool = false, shouldTint: Bool = false, fontSize: CGFloat = FireflyFont.systemFontSize) -> (string: NSMutableAttributedString, background: FireflyColor) {
        let fontSize: CGFloat = fontSize

        var currentFont = FireflyFont.systemFont(ofSize: fontSize)
        if fontName == "system" {
            currentFont = FireflyFont.systemFont(ofSize: fontSize)
        } else {
            currentFont = FireflyFont(name: fontName, size: fontSize) ?? FireflyFont.systemFont(ofSize: fontSize)
        }

        var theme: Theme?
        if let nTheme = themes[themeName] {
            let defaultColor = FireflyColor(hex: (nTheme["default"] as? String) ?? "#000000")
            let backgroundColor = FireflyColor(hex: (nTheme["background"] as? String) ?? "#000000")
            let currentLineColor = FireflyColor(hex: (nTheme["currentLine"] as? String) ?? "#000000")
            let selectionColor = FireflyColor(hex: (nTheme["selection"] as? String) ?? "#000000")
            let cursorColor = FireflyColor(hex: (nTheme["cursor"] as? String) ?? "#000000")
            
            let styleRaw = nTheme["style"] as? String
            let style: Theme.UIStyle = styleRaw == "light" ? .light : .dark
            
            let lineNumber = FireflyColor(hex: (nTheme["lineNumber"] as? String) ?? "#000000")
            let lineNumber_Active = FireflyColor(hex: (nTheme["lineNumber-Active"] as? String) ?? "#000000")

            var colors: [String: FireflyColor] = [:]
            
            if let cDefs = nTheme["definitions"] as? [String: String] {
                for item in cDefs {
                    colors.merge([item.key: FireflyColor(hex: (item.value))]) { (first, _) -> FireflyColor in return first }
                }
            }
            
            theme = Theme(defaultFontColor: defaultColor, backgroundColor: backgroundColor, currentLine: currentLineColor, selection: selectionColor, cursor: cursorColor, colors: colors, font: currentFont, style: style, lineNumber: lineNumber, lineNumber_Active: lineNumber_Active)
        }
        var tColor = FireflyColor.label
        if themeTColor {
            tColor = theme?.defaultFontColor ?? FireflyColor.label
        }
        let regularFont = FireflyFont.systemFont(ofSize: fontSize)
        let attributedString = NSMutableAttributedString(string: input, attributes: [NSAttributedString.Key.font: regularFont, NSAttributedString.Key.foregroundColor: tColor])

        //MARK: Detect Bold
        let boldFont = FireflyFont.boldSystemFont(ofSize: fontSize)
        
        let boldRegex = try? NSRegularExpression(pattern: "(\\*\\*|__)(.*?)(\\*\\*|__)", options: [])
        if let matches = boldRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 2), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        let italicFont = FireflyFont.italicSystemFont(ofSize: fontSize)
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
                let nString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: italicFont, NSAttributedString.Key.strikethroughColor : FireflyColor.label, NSAttributedString.Key.strikethroughStyle : 2, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        let imageBulletRegex = try? NSRegularExpression(pattern: "\\t*\\*\\[.*?\\]\\((.*?)\\)", options: [])
        if let matches = imageBulletRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range, in: attributedString.string) else { break }
                var text: String = String(attributedString.string[tRange])
                text.insert("\t", at: text.startIndex)
                
                let attachment = NSTextAttachment()
                guard let gRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let glyphNumb = attributedString.string[gRange]
                
                attachment.image = FireflyImage(named: "\(glyphNumb).png")
                attachment.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
                #if canImport(UIKit)
                if shouldTint {
                    attachment.image = attachment.image?.withTintColor(tColor)
                }
                #endif

                let image = NSAttributedString(attachment: attachment)
                attributedString.replaceCharacters(in: aMatch.range(at: 0), with: image)
            }
        }
        
        let imageRegex = try? NSRegularExpression(pattern: "\\!\\[.*?\\]\\((.*?)\\)", options: [])
        if let matches = imageRegex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            for aMatch in matches.reversed() {
                let attachment = NSTextAttachment()
                guard let gRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let glyphNumb = attributedString.string[gRange]
                
                attachment.image = FireflyImage(named: "\(glyphNumb).png")
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
        
        let header4Font = FireflyFont.systemFont(ofSize: fontSize * 1.4)
        let header4Regex = try? NSRegularExpression(pattern: "#### (.*?\n)", options: [])
        if let matches = header4Regex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: header4Font, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }

        let header3Font = FireflyFont.systemFont(ofSize: fontSize * 1.7)
        let header3Regex = try? NSRegularExpression(pattern: "### (.*?\n)", options: [])
        if let matches = header3Regex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: header3Font, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }
        
        let header2Font = FireflyFont.systemFont(ofSize: fontSize * 2.2)
        let header2Regex = try? NSRegularExpression(pattern: "## (.*?\n)", options: [])
        if let matches = header2Regex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: header2Font, NSAttributedString.Key.foregroundColor: tColor])
                attributedString.replaceCharacters(in: aMatch.range, with: nString)
            }
        }

        
        let header1Font = FireflyFont.systemFont(ofSize: fontSize * 3.2)
        let header1Regex = try? NSRegularExpression(pattern: "# (.*?\n)", options: [])
        if let matches = header1Regex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) {
            for aMatch in matches.reversed() {
                guard let tRange = Range(aMatch.range(at: 1), in: attributedString.string) else { break }
                let text: String = String(attributedString.string[tRange])
                
                let nString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: header1Font, NSAttributedString.Key.foregroundColor: FireflyColor.label])
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

                    let nString = Syntax.highlightAttributedString(string: attrString, theme: theme, language: language)
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

                    let nString = Syntax.highlightAttributedString(string: attrString, theme: theme, language: language)
                    nString.addAttributes([.backgroundColor: theme.backgroundColor], range: NSRange(location: 0, length: nString.string.count))
                    attributedString.replaceCharacters(in: aMatch.range, with: nString)
                }
            }
        }

        //|\\` |\\`

        return (attributedString, theme?.backgroundColor ?? FireflyColor.systemBackground)
    }
}
