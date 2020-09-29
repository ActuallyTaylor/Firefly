//
//  Paragraphs.swift
//  SavannaKit
//
//  Created by Louis D'hauwe on 17/02/2018.
//  Copyright © 2018 Silver Fox. All rights reserved.
//

import Foundation
import UIKit

struct Paragraph {
    
    var rect: CGRect
    let number: Int
    
    var string: String {
        return "\(number)"
    }
    
    func attributedString(for style: LineNumbersStyle) -> NSAttributedString {
        let attr = NSMutableAttributedString(string: string)
        let range = NSMakeRange(0, attr.length)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .foregroundColor : style.textColor
        ]
        
        attr.addAttributes(attributes, range: range)
        
        return attr
    }
    
    func drawSize(for style: LineNumbersStyle) -> CGSize {
        return attributedString(for: style).size()
    }
    
}

extension UITextView {
    
    func paragraphRectForRange(range: NSRange) -> CGRect {
        
        var nsRange = range
        
        let layoutManager: NSLayoutManager
        let textContainer: NSTextContainer
        layoutManager = self.layoutManager
        textContainer = self.textContainer
        
        nsRange = layoutManager.glyphRange(forCharacterRange: nsRange, actualCharacterRange: nil)
        
        var sectionRect = layoutManager.boundingRect(forGlyphRange: nsRange, in: textContainer)
        
        // FIXME: don't use this hack
        // This gets triggered for the final paragraph in a textview if the next line is empty (so the last paragraph ends with a newline)
        if sectionRect.origin.x == 0 {
            sectionRect.size.height -= 22
        }
        
        sectionRect.origin.x = 0
        
        return sectionRect
    }
    
}

func generateParagraphs(for textView: FireflyTextView, flipRects: Bool = false) -> [Paragraph] {
    
    let range = NSRange(location: 0, length: (textView.text as NSString).length)
    
    var paragraphs = [Paragraph]()
    var i = 0
    
    (textView.text as NSString).enumerateSubstrings(in: range, options: [.byParagraphs]) { (paragraphContent, paragraphRange, enclosingRange, stop) in
        
        i += 1
        
        let rect = textView.paragraphRectForRange(range: paragraphRange)
        
        let paragraph = Paragraph(rect: rect, number: i)
        paragraphs.append(paragraph)
        
    }
    
    if textView.text.isEmpty || textView.text.hasSuffix("\n") {
        
        var rect: CGRect
        let gutterWidth = textView.textContainerInset.left
        
        let lineHeight: CGFloat = 18
        
        if let last = paragraphs.last {
            // FIXME: don't use hardcoded "2" as line spacing
            rect = CGRect(x: 0, y: last.rect.origin.y + last.rect.height + 2, width: gutterWidth, height: last.rect.height)
        } else {
            rect = CGRect(x: 0, y: 0, width: gutterWidth, height: lineHeight)
        }
        
        i += 1
        let endParagraph = Paragraph(rect: rect, number: i)
        paragraphs.append(endParagraph)
        
    }
    
    if flipRects {
        paragraphs = paragraphs.map { (p) -> Paragraph in
            var p = p
            p.rect.origin.y = textView.bounds.height - p.rect.height - p.rect.origin.y
            
            return p
        }
    }
    return paragraphs
}

func offsetParagraphs(_ paragraphs: [Paragraph], for textView: FireflyTextView, yOffset: CGFloat = 0) -> [Paragraph] {
    
    var paragraphs = paragraphs
    paragraphs = paragraphs.map { (p) -> Paragraph in
        var p = p
        p.rect.origin.y += yOffset
        return p
    }
    
    return paragraphs
}

func drawLineNumbers(_ paragraphs: [Paragraph], in rect: CGRect, for textView: FireflyTextView) {
    guard let style = textView.theme.lineNumbersStyle else { return }
    
    for paragraph in paragraphs {
        guard paragraph.rect.intersects(rect) else { continue }

        let attr = paragraph.attributedString(for: style)
        var drawRect = paragraph.rect
        let gutterWidth = textView.gutterWidth
        let drawSize = attr.size()
        drawRect.origin.x = gutterWidth - drawSize.width - 4
        drawRect.size.width = drawSize.width
        drawRect.size.height = drawSize.height
        
        attr.draw(in: drawRect)
    }
    
}
