//
//  LineNumberLayoutManager.swift
//  SavannaKit iOS
//
//  Created by Louis D'hauwe on 04/05/2018.
//  Copyright © 2018 Silver Fox. All rights reserved.
//
// Currently unused in SavannaKit, but might be a better way of drawing the line numbers.
// Converted from https://github.com/alldritt/TextKit_LineNumbers

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

class LineNumberLayoutManager: NSLayoutManager {
    
    var lastParaLocation = 0
    var lastParaNumber = 0
    var theme: Theme?
    var gutterWidth: CGFloat = 0
    var showLineNumbers: Bool = true
    
    func _paraNumber(for charRange: NSRange) -> Int {
        //  NSString does not provide a means of efficiently determining the paragraph number of a range of text.  This code
        //  attempts to optimize what would normally be a series linear searches by keeping track of the last paragraph number
        //  found and uses that as the starting point for next paragraph number search.  This works (mostly) because we
        //  are generally asked for continuous increasing sequences of paragraph numbers.  Also, this code is called in the
        //  course of drawing a page-full of text, and so even when moving back, the number of paragraphs to search for is
        //  relatively low, even in really long bodies of text.
        //
        //  This all falls down when the user edits the text, and can potentially invalidate the cached paragraph number which
        //  causes a (potentially lengthy) search from the beginning of the string.
        if charRange.location == lastParaLocation {
            return lastParaNumber
        } else if charRange.location < lastParaLocation {
            //  We need to look backwards from the last known paragraph for the new paragraph range.  This generally happens
            //  when the text in the UITextView scrolls downward, revealing paragraphs before/above the ones previously drawn.
            let s = textStorage?.string
            var paraNumber: Int = lastParaNumber
            (s as NSString?)?.enumerateSubstrings(in: NSRange(location: Int(charRange.location), length: Int(lastParaLocation - charRange.location)), options: [.byParagraphs, .substringNotRequired, .reverse], using: {(_ substring: String?, _ substringRange: NSRange, _ enclosingRange: NSRange, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
                if enclosingRange.location <= charRange.location {
                    stop?.pointee = true
                }
                paraNumber -= 1
            })
            lastParaLocation = charRange.location
            lastParaNumber = paraNumber
            return paraNumber
        } else {
            //  We need to look forward from the last known paragraph for the new paragraph range.  This generally happens
            //  when the text in the UITextView scrolls upwards, revealing paragraphs that follow the ones previously drawn.
            let s = textStorage?.string
            var paraNumber: Int = lastParaNumber
            (s as NSString?)?.enumerateSubstrings(in: NSRange(location: lastParaLocation, length: Int(charRange.location - lastParaLocation)), options: [.byParagraphs, .substringNotRequired], using: {(_ substring: String?, _ substringRange: NSRange, _ enclosingRange: NSRange, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
                if enclosingRange.location >= charRange.location {
                    stop?.pointee = true
                }
                paraNumber += 1
            })
            lastParaLocation = charRange.location
            lastParaNumber = paraNumber
            return paraNumber
        }
    }
    
    override func glyphRange(forBoundingRect bounds: CGRect, in container: NSTextContainer) -> NSRange {
        var range = super.glyphRange(forBoundingRect: bounds, in: container)
        if range.length == 0 && bounds.intersects(self.extraLineFragmentRect) {
            range = NSMakeRange(textStorage!.length - 1, 1)
        }
        return range
    }
    
    #if canImport(UIKit)
    override func processEditing(for textStorage: NSTextStorage, edited editMask: NSTextStorage.EditActions, range newCharRange: NSRange, changeInLength delta: Int, invalidatedRange invalidatedCharRange: NSRange) {
        super.processEditing(for: textStorage, edited: editMask, range: newCharRange, changeInLength: delta, invalidatedRange: invalidatedCharRange)
        if invalidatedCharRange.location < lastParaLocation {
            //  When the backing store is edited ahead the cached paragraph location, invalidate the cache and force a complete
            //  recalculation.  We cannot be much smarter than this because we don't know how many paragraphs have been deleted
            //  since the text has already been removed from the backing store.
            lastParaLocation = 0
            lastParaNumber = 0
        }
    }

    #elseif canImport(AppKit)
    override func processEditing(for textStorage: NSTextStorage, edited editMask: NSTextStorageEditActions, range newCharRange: NSRange, changeInLength delta: Int, invalidatedRange invalidatedCharRange: NSRange) {
        super.processEditing(for: textStorage, edited: editMask, range: newCharRange, changeInLength: delta, invalidatedRange: invalidatedCharRange)
        if invalidatedCharRange.location < lastParaLocation {
            //  When the backing store is edited ahead the cached paragraph location, invalidate the cache and force a complete
            //  recalculation.  We cannot be much smarter than this because we don't know how many paragraphs have been deleted
            //  since the text has already been removed from the backing store.
            lastParaLocation = 0
            lastParaNumber = 0
        }
    }
    #endif
    
    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawBackground(forGlyphRange: glyphsToShow, at: origin)
        //  Draw line numbers.  Note that the background for line number gutter is drawn by the LineNumberTextView class.
        if showLineNumbers  {
            var foregroundColor = theme?.defaultFontColor.withAlphaComponent(0.8) ?? Color.black.withAlphaComponent(0.8)
            if let lineNumberColor = theme?.lineNumber {
                if lineNumberColor != Color(displayP3Red: 0, green: 0, blue: 0, alpha: 1) {
                    foregroundColor = lineNumberColor
                }
            }
            let attributes: [NSAttributedString.Key: Any] = [
                .font: theme?.font ?? Font.systemFont(ofSize: Font.systemFontSize),
                .foregroundColor : foregroundColor,
            ]
            
            var gutterRect: CGRect = .zero
            var paraNumber: Int = 0
            
            enumerateLineFragments(forGlyphRange: glyphsToShow, using: {(_ rect: CGRect, _ usedRect: CGRect, _ textContainer: NSTextContainer?, _ glyphRange: NSRange, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
                
                let charRange: NSRange = self.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
                let paraRange: NSRange? = (self.textStorage?.string as NSString?)?.paragraphRange(for: charRange)
                
                //Only draw line numbers for the paragraph's first line fragment. Subsequent fragments are wrapped portions of the paragraph and don't get the line number.
                if charRange.location == paraRange?.location {
                    gutterRect = CGRect(x: 0 - self.gutterWidth, y: rect.origin.y, width: self.gutterWidth, height: rect.size.height).offsetBy(dx: origin.x, dy: origin.y)
                    paraNumber = self._paraNumber(for: charRange)
                    let ln = "\(Int(UInt(paraNumber)) + 1)"
                    let size: CGSize = ln.size(withAttributes: attributes)
                    let attr = NSAttributedString(string: ln, attributes: attributes)
                    attr.draw(in: gutterRect.offsetBy(dx: gutterRect.width - 4 - size.width, dy: 0))
                } else {
                    gutterRect = CGRect(x: 0 - self.gutterWidth, y: rect.origin.y, width: self.gutterWidth, height: rect.size.height).offsetBy(dx: origin.x, dy: origin.y)
                    let ln = "•"
                    let size: CGSize = ln.size(withAttributes: attributes)
                    let attr = NSAttributedString(string: ln, attributes: attributes)
                    attr.draw(in: gutterRect.offsetBy(dx: gutterRect.width - 4 - size.width, dy: 0))
                }
            })
            
            // Deal with the special case of an empty last line where enumerateLineFragmentsForGlyphRange has no line
            // fragments to draw.
            // if NSMaxRange(glyphsToShow) > numberOfGlyphs {
            if self.textStorage!.string.isEmpty || self.textStorage!.string.hasSuffix("\n") {
                let ln = "\(Int(UInt(paraNumber)) + 2)"
                let size: CGSize = ln.size(withAttributes: attributes)
                gutterRect = gutterRect.offsetBy(dx: 0.0, dy: gutterRect.height)
                ln.draw(in: gutterRect.offsetBy(dx: gutterRect.width - 4 - size.width, dy: 0), withAttributes: attributes)
            }
        }
    }
    
    override func drawUnderline(forGlyphRange glyphRange: NSRange, underlineType underlineVal: NSUnderlineStyle, baselineOffset: CGFloat, lineFragmentRect lineRect: CGRect, lineFragmentGlyphRange lineGlyphRange: NSRange, containerOrigin: CGPoint) {
        
        super.drawUnderline(forGlyphRange: glyphRange, underlineType: NSUnderlineStyle(rawValue: 0x00), baselineOffset: baselineOffset, lineFragmentRect: lineRect, lineFragmentGlyphRange: lineGlyphRange, containerOrigin: containerOrigin)
        let firstPosition  = location(forGlyphAt: glyphRange.location).x

        let lastPosition: CGFloat

        if NSMaxRange(glyphRange) < NSMaxRange(lineGlyphRange) { lastPosition = location(forGlyphAt: NSMaxRange(glyphRange)).x
        } else {
            lastPosition = lineFragmentUsedRect( forGlyphAt: NSMaxRange(glyphRange) - 1, effectiveRange: nil).size.width
        }

        var lineRect = lineRect
        let height = lineRect.size.height * 3.5 / 4.0 // replace your under line height
        lineRect.origin.x += firstPosition
        lineRect.size.width = lastPosition - firstPosition
        lineRect.size.height = height

        lineRect.origin.x += containerOrigin.x
        lineRect.origin.y += containerOrigin.y + 1.5

        lineRect = lineRect.integral.insetBy(dx: 0.5, dy: 0.5)

//        let path = UIBezierPath(rect: lineRect)
        #if canImport(UIKit)
        let path = BezierPath(roundedRect: lineRect, cornerRadius: 3)
        #elseif canImport(AppKit)
        let path = BezierPath(roundedRect: lineRect, xRadius: 3, yRadius: 3)
        #endif
        path.fill()
        
    }
}


/*
 Removed because when the placeholder would get split by the device needing to go to a new line the rect would not be correct. It now works off the underline of the text.
  
override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
    var placeholders = [(CGRect, EditorPlaceholderState)]()
    let range = characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil)
    guard let context = UIGraphicsGetCurrentContext() else {  return }
    
    textStorage?.enumerateAttribute(.editorPlaceholder, in: range, options: [], using: { (value, range, stop) in
        if let state = value as? EditorPlaceholderState {
            let glyphRange = self.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
            let container = self.textContainer(forGlyphAt: glyphRange.location, effectiveRange: nil)
            
            let rect = self.boundingRect(forGlyphRange: glyphRange, in: container ?? NSTextContainer())
            
            placeholders.append((rect, state))
        }
    })
    
    context.saveGState()
    context.translateBy(x: origin.x, y: origin.y)
    
    for (rect, state) in placeholders {
        var color: Color = Color.systemBlue
        
        switch state {
        case .active:
            color = color.withAlphaComponent(0.8)
        case .inactive:
            color = Color.darkGray.withAlphaComponent(0.8)
        }
        
        color.setFill()
        
        let radius: CGFloat = 4.0
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        
        path.fill()
    }
    
    context.restoreGState()
    super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
}
*/

