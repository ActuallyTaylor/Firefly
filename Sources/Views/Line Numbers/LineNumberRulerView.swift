//
//  LineNumberRulerView.swift
//  Firefly
//
//  Created by Zachary lineman on 6/27/21.
//

#if canImport(AppKit)
import AppKit
import Foundation
import ObjectiveC

var LineNumberViewAssocObjKey: UInt8 = 0

extension FireflyTextView {
    
    /// Returns the current line number view for a text view
    var lineNumberView: LineNumberRulerView {
        get {
            return objc_getAssociatedObject(self, &LineNumberViewAssocObjKey) as! LineNumberRulerView
        }
        set {
            objc_setAssociatedObject(self, &LineNumberViewAssocObjKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Set's up a line number view for the current text view
    func lnv_setUpLineNumberView() {
        if font == nil {
            font = NSFont.systemFont(ofSize: 14)
        }
        
        if let scrollView = enclosingScrollView {
            lineNumberView = LineNumberRulerView(textView: self)
            
            scrollView.verticalRulerView = lineNumberView
            scrollView.hasVerticalRuler = true
            scrollView.rulersVisible = true
        }
        
        postsFrameChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(lnv_framDidChange), name: NSView.frameDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(lnv_textDidChange), name: NSText.didChangeNotification, object: self)
    }
    
    /// Remove's the line number view from the screen.
    func lnv_removeLineNumberView() {
        self.enclosingScrollView?.rulersVisible = false
    }
    
    @objc func lnv_framDidChange(notification: NSNotification) {
        lineNumberView.needsDisplay = true
    }
    
    @objc func lnv_textDidChange(notification: NSNotification) {
        lineNumberView.needsDisplay = true
    }
}

class LineNumberRulerView: NSRulerView {
    
    /// Stores the data needed to correctly color the theme
    var theme: Theme! {
        didSet {
            self.needsDisplay = true
        }
    }
    
    init(textView: FireflyTextView) {
        super.init(scrollView: textView.enclosingScrollView!, orientation: NSRulerView.Orientation.verticalRuler)
        self.theme = (textView.textStorage as? SyntaxAttributedString)?.syntax.theme
        self.clientView = textView

        self.ruleThickness = textView.gutterWidth
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func drawHashMarksAndLabels(in rect: NSRect) {
        // We need to do these checks because sometimes the rect becomes a weird size and Core Graphics crashes.
        if rect.size != CGSize.zero && rect.size.width == self.ruleThickness {
            self.theme.backgroundColor.setFill()
            rect.fill()
        }
        
        if let textView = self.clientView as? FireflyTextView {
            if let layoutManager = textView.layoutManager {
                let relativePoint = self.convert(NSZeroPoint, from: textView)
                let lineNumberAttributes = [NSAttributedString.Key.font: theme.font, NSAttributedString.Key.foregroundColor: theme.defaultFontColor] as [NSAttributedString.Key : Any]
                
                let drawLineNumber = { (lineNumberString:String, y:CGFloat) -> Void in
                    let attString = NSAttributedString(string: lineNumberString, attributes: lineNumberAttributes)
                    let x = (self.ruleThickness - 5) - attString.size().width
                    attString.draw(at: NSPoint(x: x, y: relativePoint.y + y))
                }
                
                let visibleGlyphRange = layoutManager.glyphRange(forBoundingRect: textView.visibleRect, in: textView.textContainer!)
                if visibleGlyphRange.location == -1 {
                    drawLineNumber("1", 0)
                    return
                }
                let firstVisibleGlyphCharacterIndex = layoutManager.characterIndexForGlyph(at: visibleGlyphRange.location)
                
                let newLineRegex = try! NSRegularExpression(pattern: "\n", options: [])
                
                // The line number for the first visible line
                var lineNumber = newLineRegex.numberOfMatches(in: textView.string, options: [], range: NSMakeRange(0, firstVisibleGlyphCharacterIndex)) + 1

                var glyphIndexForStringLine = visibleGlyphRange.location
                
                // Go through each line in the string.
                while glyphIndexForStringLine < NSMaxRange(visibleGlyphRange) {
                    
                    // Range of current line in the string.
                    let characterRangeForStringLine = (textView.string as NSString).lineRange(
                        for: NSMakeRange( layoutManager.characterIndexForGlyph(at: glyphIndexForStringLine), 0 )
                    )
                    let glyphRangeForStringLine = layoutManager.glyphRange(forCharacterRange: characterRangeForStringLine, actualCharacterRange: nil)
                    
                    var glyphIndexForGlyphLine = glyphIndexForStringLine
                    var glyphLineCount = 0
                    
                    while ( glyphIndexForGlyphLine < NSMaxRange(glyphRangeForStringLine) ) {
                        
                        // See if the current line in the string spread across
                        // several lines of glyphs
                        var effectiveRange = NSMakeRange(0, 0)
                        
                        // Range of current "line of glyphs". If a line is wrapped,
                        // then it will have more than one "line of glyphs"
                        let lineRect = layoutManager.lineFragmentRect(forGlyphAt: glyphIndexForGlyphLine, effectiveRange: &effectiveRange, withoutAdditionalLayout: true)
                        
                        if glyphLineCount > 0 {
                            drawLineNumber("•", lineRect.minY)
                        } else {
                            drawLineNumber("\(lineNumber)", lineRect.minY)
                        }
                        
                        // Move to next glyph line
                        glyphLineCount += 1
                        glyphIndexForGlyphLine = NSMaxRange(effectiveRange)
                    }
                    
                    glyphIndexForStringLine = NSMaxRange(glyphRangeForStringLine)
                    lineNumber += 1
                }
                
                // Draw line number for the extra line at the end of the text
                if layoutManager.extraLineFragmentTextContainer != nil {
                    drawLineNumber("\(lineNumber)", layoutManager.extraLineFragmentRect.minY)
                }
            }
        }
    }
}
#endif
