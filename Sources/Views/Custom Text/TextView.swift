//
//  TextView.swift
//  Firefly
//
//  Created by Zachary lineman on 3/1/21.
//

import UIKit

public class TextView: UIScrollView {
    
    //    internal var textStorage = SyntaxAttributedString(syntax: Syntax(language: "default", theme: "Basic", font: "system"))
    //    internal var layoutManager = LineNumberLayoutManager()
    //    internal var textContainer = NSTextContainer()
    var syntax = Syntax(language: "jelly", theme: "Xcode Light", font: "system")
    var text: String = ""

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        let path = CGMutablePath()
        path.addRect(bounds)

        var definitions: [Definition] = []
        if let language = languages["jelly"] {
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

        let nsString = NSMutableAttributedString(string: "hello()\nworld()")
        let totalRange = NSRange(location: 0, length: nsString.string.count)
        nsString.setAttributes([NSAttributedString.Key.foregroundColor: syntax.theme.defaultFontColor, NSAttributedString.Key.font: syntax.theme.font], range: totalRange)
        
        for item in definitions {
            var regex = try? NSRegularExpression(pattern: item.regex)
            if let option = item.matches.first {
                regex = try? NSRegularExpression(pattern: item.regex, options: option)
            }
            if let matches = regex?.matches(in: nsString.string, options: [], range: totalRange) {
                for aMatch in matches {
                    let color = syntax.theme.colors[item.type] ?? syntax.theme.defaultFontColor
                    nsString.addAttributes([NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: syntax.theme.font], range: aMatch.range(at: item.group))
                }
            }
        }

//        let attrString = NSMutableAttributedString(string: "helloWorld()")
//        attrString.setAttributes([.foregroundColor: UIColor.red], range: NSRange(location: 0, length: attrString.length))
        
        let framesetter = CTFramesetterCreateWithAttributedString(nsString as CFAttributedString)
        
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, nsString.length), path, nil)

        CTFrameDraw(frame, context)
    }

}

//extension TextView: UITextInput {
//
//}
