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
        let vRange = getVisibleRange()
        if vRange.encompasses(r2: range) { shouldHighlightOnChange = true } else { highlightAll = true }
        
        let selectedRange = textView.selectedRange
        var insertingText = text
        
        if placeholdersAllowed {
            //There is a bug here that when a multi-line string that is larger than the visible area is present, it will be partially highlighted because the ranges get messed up.
            let inside = textStorage.insidePlaceholder(cursorRange: selectedRange)
            if inside.0 {
                if let token = inside.1 {
                    let fullRange = NSRange(location: 0, length: self.text.utf16.count)
                    if token.range.upperBound < fullRange.upperBound {
                        textStorage.removeAttribute(.font, range: token.range)
                        textStorage.removeAttribute(.foregroundColor, range: token.range)
                        textStorage.removeAttribute(.editorPlaceholder, range: token.range)
                        
                        textStorage.addAttributes([.font: textStorage.syntax.currentFont, .foregroundColor: textStorage.syntax.theme.defaultFontColor], range: token.range)
                        textStorage.replaceCharacters(in: token.range, with: text)
                        textStorage.cachedTokens.removeAll { (token) -> Bool in return token == token }
                        updateSelectedRange(NSRange(location: token.range.location + text.count, length: 0))
                        textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
                        
                        return false
                    } else {
                        //Oops they ended up in the middle of a token so just delete what they have and rehighlight the view
                        forceHighlight()
                    }
                }
            }
        }
        
        // Check for a backspace
        if let char = text.cString(using: String.Encoding.utf16) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                // Update on backspace
                updateGutterNow = true
                return true
            }
        }
        
        // Check to see if a newline was pasted in
        if insertingText.contains("\n") {
            updateGutterNow = true
        }

        let nsText = textView.text as NSString
        var currentLine = nsText.substring(with: nsText.lineRange(for: textView.selectedRange))
        if currentLine.hasSuffix("\n") {
            currentLine.removeLast()
        }
        let newlineInsert: String = getNewlineInsert(currentLine)
        guard let tView = textView as? FireflyTextView  else { return false }

        
        if let lastInTextChar = insertingText.last {
            characterBuffer.insert("\(lastInTextChar)", at: 0)

            if characterBuffer[1, default: ""] + characterBuffer[0, default: ""] == "/*" {
                lastCompleted = "/*"
            } else if characterBuffer[1, default: ""] == "\"" && characterBuffer[0, default: ""] != "\""  && characterBuffer[2, default: ""] != "\"" {
                insertingText += "\""
                
                textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                updateSelectedRange(NSRange(location: selectedRange.lowerBound + 1, length: 0))
                textView.setNeedsDisplay()

                shouldHighlightOnChange = false
                textStorage.editingRange = selectedRange
                textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
                
                delegate?.didChangeText(tView)
                
                return false
            } else if characterBuffer[1, default: ""] == "(" && characterBuffer[0, default: ""] != ")" {
                insertingText += ")"
                
                textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                updateSelectedRange(NSRange(location: selectedRange.lowerBound + 1, length: 0))
                textView.setNeedsDisplay()

                shouldHighlightOnChange = false
                textStorage.editingRange = selectedRange
                textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
                
                delegate?.didChangeText(tView)
                
                return false
            } else if characterBuffer[1, default: ""] == "{" && characterBuffer[0, default: ""] != "}" {
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
                
                shouldHighlightOnChange = false
                textStorage.editingRange = selectedRange
                textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
                
                delegate?.didChangeText(tView)
                
                return false
            }
        }
        
        // Update on new line
        if insertingText == "\n" {
            //Check to see if we need to finish any autocompletion
            if lastCompleted != "" {
                if lastCompleted == "/*" {
                    lastCompleted = ""
                    insertingText += "\t\(newlineInsert)\n\(newlineInsert)*/"
                    
                    textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                    updateSelectedRange(NSRange(location: selectedRange.lowerBound + 2 + newlineInsert.count, length: 0))
                    textView.setNeedsDisplay()
                    shouldHighlightOnChange = false
                    textStorage.editingRange = selectedRange
                    textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
                    
                    delegate?.didChangeText(tView)
                    
                    characterBuffer.removeAll()
                    return false
                }
            } else {
                insertingText += newlineInsert
                textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                
                updateSelectedRange(NSRange(location: selectedRange.lowerBound + insertingText.count, length: 0))
                textView.setNeedsDisplay()
                updateGutterWidth()
                shouldHighlightOnChange = false
                textStorage.editingRange = selectedRange
                textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
                
                delegate?.didChangeText(tView)

                characterBuffer.removeAll()
                return false
            }
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
        if updateGutterNow {
            updateGutterWidth()
        }
        if shouldHighlightOnChange {
            shouldHighlightOnChange = false
            textStorage.editingRange = tView.selectedRange
            textStorage.highlight(getVisibleRange(), cursorRange: tView.selectedRange)
        } else if highlightAll {
            highlightAll = false
            textStorage.highlight(NSRange(location: 0, length: textStorage.string.utf16.count), cursorRange: nil)
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
