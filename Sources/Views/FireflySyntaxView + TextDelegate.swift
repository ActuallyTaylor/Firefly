//
//  FireflySyntaxView + TextDelegate.swift
//  Refly
//
//  Created by Zachary lineman on 9/28/20.
//

import UIKit

extension FireflySyntaxView: UITextViewDelegate {
    
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
        
        let vRange = getVisibleRange()
        if vRange.encompasses(r2: range) {
            shouldHighlightOnChange = true
        } else {
            print("Not encompassed")
            highlightAll = true
        }
        
        return true
    }
    
    func updateSelectedRange(_ range: NSRange) {
        textView.selectedRange = range
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        guard let tView = textView as? FireflyTextView  else { return }
        if shouldHighlightOnChange {
            shouldHighlightOnChange = false
            textStorage.editingRange = tView.selectedRange
            textStorage.highlight(getVisibleRange())
        } else if highlightAll {
            highlightAll = false
            textStorage.highlight(NSRange(location: 0, length: textStorage.string.count))
        }
        delegate?.didChangeText(tView)
    }
    
    func getVisibleRange() -> NSRange {
        let topLeft = CGPoint(x: textView.bounds.minX, y: textView.bounds.minY)
        let bottomRight = CGPoint(x: textView.bounds.maxX, y: textView.bounds.maxY)
        guard let topLeftTextPosition = textView.closestPosition(to: topLeft),
            let bottomRightTextPosition = textView.closestPosition(to: bottomRight)
            else {
                return NSRange(location: 0, length: 0)
        }
        let charOffset = textView.offset(from: textView.beginningOfDocument, to: topLeftTextPosition)
        let length = textView.offset(from: topLeftTextPosition, to: bottomRightTextPosition)
        let visibleRange = NSRange(location: charOffset, length: length)
        return visibleRange
    }
}
