//
//  FireflySyntaxView + TextDelegate.swift
//  Refly
//
//  Created by Zachary lineman on 9/28/20.
//

import UIKit

extension FireflySyntaxView {
    
    //MARK: UITextViewDelegate
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let selectedRange = textView.selectedRange
        var insertingText = text
        
        if insertingText == "" && range.length > 0 {
            // Update on backspace
            updateGutterWidth()
        }
        
        if insertingText == "\n" {
            // Update on new line
            let nsText = textView.text as NSString
            var currentLine = nsText.substring(with: nsText.lineRange(for: textView.selectedRange))
            if currentLine.hasSuffix("\n") {
                currentLine.removeLast()
            }
            
            var newLinePrefix = ""
            for char in currentLine {
                let tempSet = CharacterSet(charactersIn: "\(char)")
                if tempSet.isSubset(of: .whitespacesAndNewlines) {
                    newLinePrefix += "\(char)"
                } else {
                    break
                }
            }
            insertingText += newLinePrefix
            textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
            
            updateSelectedRange(NSRange(location: selectedRange.lowerBound + insertingText.count, length: 0))
            textView.setNeedsDisplay()
            guard let tView = textView as? FireflyTextView  else { return false }
            delegate?.didChangeText(tView)
            updateGutterWidth()

            return false
        }
        return true
    }
    
    func updateSelectedRange(_ range: NSRange) {
        textView.selectedRange = range
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        guard let tView = textView as? FireflyTextView  else { return }
        delegate?.didChangeText(tView)
    }
}
