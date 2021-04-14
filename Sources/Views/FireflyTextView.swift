//
//  FireflyTextView.swift
//  Refly
//
//  Created by Zachary lineman on 9/28/20.
//

import UIKit

public class FireflyTextView: UITextView {
    var gutterWidth: CGFloat = 20 {
        didSet {
            textContainerInset = UIEdgeInsets(top: 0, left: gutterWidth, bottom: 0, right: 0)
        }
    }
    
    /// Returns a CGRect for the cursor position in the text view's coordinates. If no cursor is present, it returns nil.
    /// source: https://stackoverflow.com/a/43167060/3902590
    public func cursorPosition() -> CGRect? {
        if let selectedRange = self.selectedTextRange
        {
            // `caretRect` is in the `textView` coordinate space.
            return self.caretRect(for: selectedRange.end)
        } else {
            // No selection and no caret in UITextView.
            return nil
        }
    }
    
    public func currentWord() -> String {
        guard let cursorRange = self.selectedTextRange else { return "" }
        func getRange(from position: UITextPosition, offset: Int) -> UITextRange? {
            guard let newPosition = self.position(from: position, offset: offset) else { return nil }
            return self.textRange(from: newPosition, to: position)
        }
        
        var wordStartPosition: UITextPosition = self.beginningOfDocument
        var wordEndPosition: UITextPosition = self.endOfDocument
        
        var position = cursorRange.start
        
        while let range = getRange(from: position, offset: -1), let text = self.text(in: range) {
            if text == " " || text == "\n" {
                wordStartPosition = range.end
                break
            }
            position = range.start
        }
        
        position = cursorRange.start
        
        while let range = getRange(from: position, offset: 1), let text = self.text(in: range) {
            if text == " " || text == "\n" {
                wordEndPosition = range.start
                break
            }
            position = range.end
        }
        
        guard let wordRange = self.textRange(from: wordStartPosition, to: wordEndPosition) else { return "" }
        
        return self.text(in: wordRange) ?? ""
    }
}
