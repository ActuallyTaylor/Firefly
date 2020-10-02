//
//  FireflyTextView.swift
//  Refly
//
//  Created by Zachary lineman on 9/28/20.
//

import UIKit

//MARK: String Extensions
extension String {
    func nsRange(fromRange range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}

class FireflyTextView: UITextView {
    var theme: Theme = Theme(themeString: "xcode-light") {
        didSet(theme) {
//            updateNumbers()
        }
    }
    
    var gutterWidth: CGFloat {
        set(value) { textContainerInset = UIEdgeInsets(top: 0, left: value, bottom: 0, right: 0) }
        get { return textContainerInset.left }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

//    override func draw(_ rect: CGRect) {
//        let gutterRect = CGRect(x: 0, y: rect.minY, width: gutterWidth, height: rect.height)
//        let path = UIBezierPath(rect: gutterRect)
//        theme.gutterStyle.backgroundColor.setFill()
//        path.fill()
//        updateNumbers()
//        
//        super.draw(rect)
//    }
//    
//    //MARK: Line numbers
//    public func updateNumbers() {
//        let components = self.text.components(separatedBy: .newlines)
//        let count = components.count
//        var offset: CGFloat = 0
//        
//        for x in 0..<count {
//            let str = attributedString(for: "\(x)")
//            let drawSize = str.size()
//            let range: NSRange = NSString(string: text).range(of: components[x])
//            let rect = self.paragraphRectForRange(range: range)
//            var drawRect = CGRect(x: 0, y: offset, width: drawSize.width, height: drawSize.height)
//            offset += rect.height
//
//            drawRect.origin.x = gutterWidth - drawSize.width - 4
//            drawRect.size.width = drawSize.width
//            drawRect.size.height = drawSize.height
//            
//            str.draw(in: drawRect)
//        }
//    }
//    
//    func attributedString(for string: String) -> NSAttributedString {
//        let attr = NSMutableAttributedString(string: string)
//        let range = NSMakeRange(0, attr.length)
//        
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: theme.mainFont!,
//            .foregroundColor : theme.fontColor!
//        ]
//        
//        attr.addAttributes(attributes, range: range)
//        return attr
//    }
}
