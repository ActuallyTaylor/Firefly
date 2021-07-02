//
//  Languages.swift
//  Firefly
//
//  Created by Zachary lineman on 12/24/20.
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

/// A syntax type that defines how a SyntaxAttributedString should highlight different types of tokens
public class Syntax {
    /// The current language of the syntax
    var currentLanguage: String = "default" {
        didSet {
            setLanguage(to: currentLanguage)
        }
    }
    
    /// The current theme name of the syntax
    var currentTheme: String = "Basic" {
        didSet {
            setTheme(to: currentTheme)
        }
    }
    
    /// The current font of the syntax
    var currentFont: FireflyFont = FireflyFont.systemFont(ofSize: FireflyFont.systemFontSize)
    
    /// The current font size of the syntax
    var fontSize: CGFloat = FireflyFont.systemFontSize
    
    /// An array that holds all of the generated definitions
    var definitions: [Definition] = []
    
    /// The current theme of the view
    public var theme: Theme = Theme(defaultFontColor: FireflyColor.black, backgroundColor: FireflyColor.white, currentLine: FireflyColor.clear, selection: FireflyColor.blue, cursor: FireflyColor.blue, colors: [:], font: FireflyFont.systemFont(ofSize: FireflyFont.systemFontSize), style: .light, lineNumber: FireflyColor.white, lineNumber_Active: FireflyColor.white)
    
    
    /// A syntax type that defines how a SyntaxAttributedString should highlight different types of tokens
    /// - Parameters:
    ///   - language: Language name
    ///   - theme: Theme name
    ///   - font: Font name
    public init(language: String, theme: String, font: String) {
        currentLanguage = language
        currentTheme = theme
        setFont(to: font)
    }
    
    /// Changes the current language & updates the definitions
    /// - Parameter name: Name of the language
    func setLanguage(to name: String) {
        if let language = languages[name.lowercased()] {
            for item in language {
                let type = item.key
                let dict: [String: Any] = item.value as! [String : Any]
                let regex: String = dict["regex"] as? String ?? ""
                let group: Int = dict["group"] as? Int ?? 0
                let relevance: Int = dict["relevance"] as? Int ?? 0
                let options: [NSRegularExpression.Options] = dict["options"] as? [NSRegularExpression.Options] ?? []
                let multi: Bool = dict["multiline"] as? Bool ?? false

                definitions.append(Definition(type: type, regex: regex, group: group, relevance: relevance, matches: options, multiLine: multi))
            }
        }
        var editorPlaceholderPattern = "(<#)([^\"\\n]*?)"
        editorPlaceholderPattern += "(#>)"

        definitions.sort { (def1, def2) -> Bool in return def1.relevance > def2.relevance }
        definitions.insert(Definition(type: "placeholder", regex: editorPlaceholderPattern, group: 0, relevance: 10, matches: [], multiLine: false), at: 0)
        definitions.reverse()
        
    }
    
    /// Changes the current theme
    /// - Parameter name: The name of the theme
    func setTheme(to name: String) {
        if let theme = themes[name] {
            let defaultColor = FireflyColor(hex: (theme["default"] as? String) ?? "#000000")
            let backgroundColor = FireflyColor(hex: (theme["background"] as? String) ?? "#000000")
            
            let currentLineColor = FireflyColor(hex: (theme["currentLine"] as? String) ?? "#000000")
            let selectionColor = FireflyColor(hex: (theme["selection"] as? String) ?? "#000000")
            let cursorColor = FireflyColor(hex: (theme["cursor"] as? String) ?? "#000000")
            
            let lineNumber = FireflyColor(hex: (theme["lineNumber"] as? String) ?? "#000000")
            let lineNumber_Active = FireflyColor(hex: (theme["lineNumber-Active"] as? String) ?? "#000000")

            let styleRaw = theme["style"] as? String
            let style: Theme.UIStyle = styleRaw == "light" ? .light : .dark

            var colors: [String: FireflyColor] = [:]
            
            if let cDefs = theme["definitions"] as? [String: String] {
                for item in cDefs {
                    colors.merge([item.key: FireflyColor(hex: (item.value))]) { (first, _) -> FireflyColor in return first }
                }
            }
            
            self.theme = Theme(defaultFontColor: defaultColor, backgroundColor: backgroundColor, currentLine: currentLineColor, selection: selectionColor, cursor: cursorColor, colors: colors, font: currentFont, style: style, lineNumber: lineNumber, lineNumber_Active: lineNumber_Active)
        }
    }
    
    /// Changes the current font of the syntax
    /// - Parameter name: The name of the font
    func setFont(to name: String) {
        if name == "system" {
            currentFont = FireflyFont.systemFont(ofSize: fontSize)
        } else {
            currentFont = FireflyFont(name: name, size: fontSize) ?? FireflyFont.systemFont(ofSize: fontSize)
        }
        setTheme(to: currentTheme)
    }
    
    
    /// Retrieves the highlighting color for a certain type
    /// - Parameter type: The type that needs to be highlighted
    /// - Returns: The UIColor or NSColor of the type
    func getHighlightColor(for type: String) -> FireflyColor {
        return theme.colors[type] ?? theme.defaultFontColor
    }
    
    
    /// A static function that can be used to highlight an NSAttributedString with the given theme & language
    /// - Parameters:
    ///   - string: The NSAttributedString that should be highlighted
    ///   - theme: The name of theme to highlight with
    ///   - language: The name of the language to highlight with
    /// - Returns: An NSMutableAttributedString that has been highlighted
    public static func highlightAttributedString(string: NSAttributedString, theme: Theme, language: String) -> NSMutableAttributedString {
        var definitions: [Definition] = []
        if let language = languages[language] {
            for item in language {
                let type = item.key
                let dict: [String: Any] = item.value as! [String : Any]
                let regex: String = dict["regex"] as? String ?? ""
                let group: Int = dict["group"] as? Int ?? 0
                let relevance: Int = dict["relevance"] as? Int ?? 0
                let options: [NSRegularExpression.Options] = dict["options"] as? [NSRegularExpression.Options] ?? []
                let multi: Bool = dict["multiline"] as? Bool ?? false

                definitions.append(Definition(type: type, regex: regex, group: group, relevance: relevance, matches: options, multiLine: multi))
            }
        }
        
        definitions.sort { (def1, def2) -> Bool in return def1.relevance > def2.relevance }
        definitions.reverse()

        let nsString = NSMutableAttributedString(attributedString: string)
        let totalRange = NSRange(location: 0, length: nsString.string.count)
        nsString.setAttributes([NSAttributedString.Key.foregroundColor: theme.defaultFontColor, NSAttributedString.Key.font: theme.font], range: totalRange)
        
        for item in definitions {
            var regex = try? NSRegularExpression(pattern: item.regex)
            if let option = item.matches.first {
                regex = try? NSRegularExpression(pattern: item.regex, options: option)
            }
            if let matches = regex?.matches(in: nsString.string, options: [], range: totalRange) {
                for aMatch in matches {
                    let color = theme.colors[item.type] ?? theme.defaultFontColor
                    nsString.addAttributes([NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: theme.font], range: aMatch.range(at: item.group))
                }
            }
        }

        return nsString
    }
}
