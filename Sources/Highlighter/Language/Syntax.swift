//
//  Languages.swift
//  
//
//  Created by Zachary lineman on 12/24/20.
//

import UIKit

public class Syntax {
    var currentLanguage: String = "default" {
        didSet(value) {
            
        }
    }
    var currentTheme: String = "default" {
        didSet(value) {
            setTheme(to: value)
        }
    }
    var currentFont: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var fontSize: CGFloat = UIFont.systemFontSize
    
    var definitions: [Definition] = []
    var theme: Theme = Theme(defaultFontColor: UIColor.black, backgroundColor: UIColor.white, colors: [:], font: UIFont.systemFont(ofSize: UIFont.systemFontSize))
    
    init(language: String, theme: String, font: String) {
        currentLanguage = language
        currentTheme = theme
        setFont(to: font)
    }
    
    func setLanguage(to name: String) {
        if let language = languages[name] {
            for item in language {
                let type = item.key
                let dict: [String: Any] = item.value as! [String : Any]
                let regex: String = dict["regex"] as? String ?? ""
                let group: Int = dict["group"] as? Int ?? 0
                let relevance: Int = dict["relevance"] as? Int ?? 0
                let options: [NSRegularExpression.Options] = dict["options"] as? [NSRegularExpression.Options] ?? []
                
                definitions.append(Definition(type: type, regex: regex, group: group, relevance: relevance, matches: options))
            }
        }
        definitions.sort { (def1, def2) -> Bool in return def1.relevance > def2.relevance }
        definitions.reverse()
    }
    
    func setTheme(to name: String) {
        if let theme = themes[name] {
            let defaultColor = UIColor(hex: (theme["default"] as? String) ?? "#000000")
            let backgroundColor = UIColor(hex: (theme["background"] as? String) ?? "#000000")
            var colors: [String: UIColor] = [:]
            
            if let cDefs = theme["definitions"] as? [String: String] {
                for item in cDefs {
                    colors.merge([item.key: UIColor(hex: (item.value))]) { (first, _) -> UIColor in return first }
                }
            }

            self.theme = Theme(defaultFontColor: defaultColor, backgroundColor: backgroundColor, colors: colors, font: currentFont)
        }
    }
    
    func setFont(to name: String) {
        if name == "system" {
            currentFont = UIFont.systemFont(ofSize: fontSize)
        } else {
            currentFont = UIFont(name: name, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        }
        setTheme(to: currentTheme)
    }
    
    func getHighlightColor(for type: String) -> UIColor {
        return theme.colors[type] ?? theme.defaultFontColor
    }
}
