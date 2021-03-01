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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //1
    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        let path = CGMutablePath()
        path.addRect(bounds)

        let attrString = Syntax.highlightAttributedString(string: NSAttributedString(string: "helloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\nhelloWorld()\n"), theme: syntax.theme, language: "system")
//        let attrString = NSMutableAttributedString(string: "helloWorld()")
//        attrString.setAttributes([.foregroundColor: UIColor.red], range: NSRange(location: 0, length: attrString.length))
        
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)

        CTFrameDraw(frame, context)
    }

}
