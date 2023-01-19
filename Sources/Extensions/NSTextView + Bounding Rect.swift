//
//  NSTextView + Bounding Rect.swift
//  Firefly
//
//  Created by Zachary Lineman on 6/30/21.
//

#if targetEnvironment(macCatalyst)
#elseif canImport(AppKit)
import AppKit

extension NSTextView {
    func boundingRect(forCharacterRange range: NSRange) -> CGRect? {

        let attributedText = attributedString()

        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()

        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0.0

        layoutManager.addTextContainer(textContainer)

        var glyphRange = NSRange()

        // Convert the range for glyphs.
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)

        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
}

#endif
