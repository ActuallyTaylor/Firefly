//
//  FireflyTextView.swift
//  Firefly
//
//  Created by Zachary lineman on 9/28/20.
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public class FireflyTextView: TextView {
    var gutterWidth: CGFloat = 20 {
        didSet {
            #if canImport(UIKit)
            textContainerInset = EdgeInsets(top: 0, left: gutterWidth, bottom: 0, right: 0)
            #elseif canImport(AppKit)
            textContainerInset = NSSize(width: gutterWidth, height: 0)
            #endif
        }
    }
    
    #if canImport(UIKit)
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
    #endif
}
