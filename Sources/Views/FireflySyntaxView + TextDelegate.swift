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
        let maxSize = CGSize(width: 10000, height: 30000)
        let textRect = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font : self.textStorage.syntax.currentFont], context: nil)
        print(textRect)
        textView.frame = CGRect(origin: textView.frame.origin, size: CGSize(width: textRect.width, height: textRect.height))

        let vRange = getVisibleRange()
        if vRange.encompasses(r2: range) { shouldHighlightOnChange = true } else { highlightAll = true }
        
        let selectedRange = textView.selectedRange
        var insertingText = text
        
        if insertingText == "" && range.length > 0 {
            // Updater on backspace
            updateGutterWidth()
        }

        if placeholdersAllowed {
            //There is a bug here that when a multi-line string that is larger than the visible area is present, it will be partially highlighted because the ranges get messed up.
            let inside = textStorage.insidePlaceholder(cursorRange: selectedRange)
            if inside.0 {
                if let token = inside.1 {
                    textStorage.removeAttribute(.font, range: token.range)
                    textStorage.removeAttribute(.foregroundColor, range: token.range)
                    textStorage.removeAttribute(.editorPlaceholder, range: token.range)
                    
                    textStorage.addAttributes([.font: textStorage.syntax.currentFont, .foregroundColor: textStorage.syntax.theme.defaultFontColor], range: token.range)
                    textStorage.replaceCharacters(in: token.range, with: text)
                    textStorage.cachedTokens.removeAll { (token) -> Bool in return token == token }
                    updateSelectedRange(NSRange(location: token.range.location + text.count, length: 0))
                    textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)

                    return false
                }
            }
        }

        let nsText = textView.text as NSString
        var currentLine = nsText.substring(with: nsText.lineRange(for: textView.selectedRange))
        if currentLine.hasSuffix("\n") {
            currentLine.removeLast()
        }
        let newlineInsert: String = getNewlineInsert(currentLine)
        
        if let lastChar = lastChar {
            let lastString: String = String(lastChar) + insertingText
            if lastString == "/*" {
                insertingText += "\n\t\(newlineInsert)\n\(newlineInsert)*/"

                textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                updateSelectedRange(NSRange(location: selectedRange.lowerBound + 3 + newlineInsert.count, length: 0))
                textView.setNeedsDisplay()
                self.lastChar = insertingText.last
                shouldHighlightOnChange = false
                textStorage.editingRange = selectedRange
                textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
                
                guard let tView = textView as? FireflyTextView  else { return false }
                delegate?.didChangeText(tView)

                return false
            } else if lastChar == "\"" && text != "\"" {
                insertingText += "\""
                
                textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                updateSelectedRange(NSRange(location: selectedRange.lowerBound + 1, length: 0))
                textView.setNeedsDisplay()
                self.lastChar = text.last
                shouldHighlightOnChange = false
                textStorage.editingRange = selectedRange
                textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
                
                guard let tView = textView as? FireflyTextView  else { return false }
                delegate?.didChangeText(tView)

                return false
            } else if lastChar == "{" && text != "}" {
                //Maybe change it so after you hit enter it adds the }
                // Update on new line
                if text == "\n" {
                    insertingText += "\t\(newlineInsert)\n\(newlineInsert)}"
                    textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                    updateSelectedRange(NSRange(location: selectedRange.lowerBound + 2 + newlineInsert.count, length: 0))
                } else {
                    insertingText += "}"
                    textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                    updateSelectedRange(NSRange(location: selectedRange.lowerBound + 1, length: 0))
                }
                
                textView.setNeedsDisplay()
                self.lastChar = text.last
                shouldHighlightOnChange = false
                textStorage.editingRange = selectedRange
                textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
                
                guard let tView = textView as? FireflyTextView  else { return false }
                delegate?.didChangeText(tView)

                return false
            } else if lastChar == "(" && text != ")" {
                insertingText += ")"
                
                textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                updateSelectedRange(NSRange(location: selectedRange.lowerBound + 1, length: 0))
                textView.setNeedsDisplay()
                self.lastChar = text.last
                shouldHighlightOnChange = false
                textStorage.editingRange = selectedRange
                textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
                
                guard let tView = textView as? FireflyTextView  else { return false }
                delegate?.didChangeText(tView)

                return false
            }
        }
        
        lastChar = insertingText.last
        if insertingText == "\n" {
            // Update on new line
            insertingText += newlineInsert
            textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
            
            updateSelectedRange(NSRange(location: selectedRange.lowerBound + insertingText.count, length: 0))
            textView.setNeedsDisplay()
            updateGutterWidth()
            shouldHighlightOnChange = false
            textStorage.editingRange = selectedRange
            textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
            
            guard let tView = textView as? FireflyTextView  else { return false }
            delegate?.didChangeText(tView)

            return false
        }

        return true
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        delegate?.didClickLink(URL.absoluteString)
        return false
    }
    
    func getNewlineInsert(_ currentLine: String) -> String {
        var newLinePrefix = ""
        for char in currentLine {
            let tempSet = CharacterSet(charactersIn: "\(char)")
            if tempSet.isSubset(of: .whitespacesAndNewlines) {
                newLinePrefix += "\(char)"
            } else {
                break
            }
        }
        return newLinePrefix
    }
    
//    public func textViewDidChangeSelection(_ textView: UITextView) {
//        textStorage.updatePlaceholders(cursorRange: textView.selectedRange)
//    }

    func updateSelectedRange(_ range: NSRange) {
        if range.location + range.length <= text.utf16.count {
            textView.selectedRange = range
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        guard let tView = textView as? FireflyTextView  else { return }
        if shouldHighlightOnChange {
            shouldHighlightOnChange = false
            textStorage.editingRange = tView.selectedRange
            textStorage.highlight(getVisibleRange(), cursorRange: tView.selectedRange)
        } else if highlightAll {
            highlightAll = false
            textStorage.highlight(NSRange(location: 0, length: textStorage.string.count), cursorRange: nil)
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
