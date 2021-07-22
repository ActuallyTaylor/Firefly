//
//  FireflySyntaxView + TextDelegate.swift
//  Firefly
//
//  Created by Zachary lineman on 9/28/20.
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension FireflySyntaxView: TextViewDelegate {
    
    //MARK: NSTextViewDelegate
    public func textView(_ textView: TextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        return shouldChangeText(textView: textView, shouldChangeTextIn: affectedCharRange, replacementText: replacementString ?? "")
    }
    
    //MARK: UITextViewDelegate
    public func textView(_ textView: TextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return shouldChangeText(textView: textView, shouldChangeTextIn: range, replacementText: text)
    }
    
    /// Used in both iOS and macOS to determine if the text should change
    func shouldChangeText(textView: TextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let vRange = getVisibleRange()
        if vRange.encompasses(r2: range) { shouldHighlightOnChange = true } else { highlightAll = true }
        
        let selectedRange = textView.selectedRange
        var insertingText = text
        
        self.textStorage.beginEditing()
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

                        self.textStorage.endEditing()
                        updateSelectedRange(NSRange(location: token.range.location + text.utf16.count, length: 0))
                        textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)

                        #if canImport(AppKit)
                        textView.didChangeText()
                        #endif

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
                self.textStorage.endEditing()
                return true
            }
        }
        
        // Check to see if a newline was pasted in
        if insertingText.contains("\n") {
            updateGutterNow = true
        }
        
        let nsText = textView.text as NSString
        var currentLine = nsText.substring(with: nsText.lineRange(for: selectedRange))
        if currentLine.hasSuffix("\n") {
            currentLine.removeLast()
        }
        
        let newlineInsert: String = getNewlineInsert(currentLine)
        guard let tView = textView as? FireflyTextView  else { self.textStorage.endEditing(); return false }
        
        if let lastInTextChar = insertingText.last {
            characterBuffer.insert("\(lastInTextChar)", at: 0)
            
            if characterBuffer[1, default: ""] + characterBuffer[0, default: ""] == "/*" {
                lastCompleted = "/*"
            } else if characterBuffer[1, default: ""] == "\"" && characterBuffer[0, default: ""] != "\""  && characterBuffer[2, default: ""] != "\"" {
                insertingText += "\""
                
                #if canImport(UIKit)
                textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                
                self.textStorage.endEditing()
                updateSelectedRange(NSRange(location: selectedRange.lowerBound + 1, length: 0))
                textView.setNeedsDisplay()
                #elseif canImport(AppKit)
                textView.textStorage!.replaceCharacters(in: selectedRange, with: insertingText)
                
                self.textStorage.endEditing()
                updateSelectedRange(NSRange(location: selectedRange.lowerBound + 1, length: 0))
                textView.setNeedsDisplay(textView.bounds)
                textView.didChangeText()
                #endif
                
                shouldHighlightOnChange = false
                textStorage.editingRange = selectedRange
                textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
                
                delegate?.didChangeText(tView)
                
                return false
            } else if characterBuffer[1, default: ""] == "(" && characterBuffer[0, default: ""] != ")" {
                insertingText += ")"
                
                #if canImport(UIKit)
                textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                
                self.textStorage.endEditing()
                updateSelectedRange(NSRange(location: selectedRange.lowerBound + 1, length: 0))
                textView.setNeedsDisplay()
                #elseif canImport(AppKit)
                textView.textStorage?.replaceCharacters(in: selectedRange, with: insertingText)
                
                self.textStorage.endEditing()
                updateSelectedRange(NSRange(location: range.lowerBound + 1, length: 0))
                textView.setNeedsDisplay(textView.bounds)
                textView.didChangeText()
                #endif
                
                shouldHighlightOnChange = false
                textStorage.editingRange = selectedRange
                textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
                
                delegate?.didChangeText(tView)
                
                return false
            } else if characterBuffer[1, default: ""] == "{" && characterBuffer[0, default: ""] != "}" {
                // Update on new line
                if text == "\n" {
                    insertingText += "\t\(newlineInsert)\n\(newlineInsert)}"
                    #if canImport(UIKit)
                    textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                    
                    self.textStorage.endEditing()
                    updateSelectedRange(NSRange(location: selectedRange.lowerBound + 2 + newlineInsert.count, length: 0))
                    textView.setNeedsDisplay()
                    #elseif canImport(AppKit)
                    textView.textStorage!.replaceCharacters(in: selectedRange, with: insertingText)
                    
                    self.textStorage.endEditing()
                    updateSelectedRange(NSRange(location: selectedRange.lowerBound + 2 + newlineInsert.count, length: 0))
                    textView.setNeedsDisplay(textView.bounds)
                    textView.didChangeText()
                    #endif
                } else {
                    insertingText += "}"
                    #if canImport(UIKit)
                    textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                    
                    self.textStorage.endEditing()
                    updateSelectedRange(NSRange(location: selectedRange.lowerBound + 1, length: 0))
                    textView.setNeedsDisplay()
                    #elseif canImport(AppKit)
                    textView.textStorage!.replaceCharacters(in: selectedRange, with: insertingText)
                    
                    self.textStorage.endEditing()
                    updateSelectedRange(NSRange(location: selectedRange.lowerBound + 1, length: 0))
                    textView.setNeedsDisplay(textView.bounds)
                    textView.didChangeText()
                    #endif
                }
                
                shouldHighlightOnChange = false
                textStorage.editingRange = selectedRange
                self.textStorage.endEditing()
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
                    
                    #if canImport(UIKit)
                    textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                    
                    self.textStorage.endEditing()
                    updateSelectedRange(NSRange(location: selectedRange.lowerBound + 2 + newlineInsert.count, length: 0))
                    textView.setNeedsDisplay()
                    #elseif canImport(AppKit)
                    textView.textStorage!.replaceCharacters(in: selectedRange, with: insertingText)
                    
                    self.textStorage.endEditing()
                    updateSelectedRange(NSRange(location: selectedRange.lowerBound + 2 + newlineInsert.count, length: 0))
                    textView.setNeedsDisplay(textView.bounds)
                    textView.didChangeText()
                    #endif
                    
                    shouldHighlightOnChange = false
                    textStorage.editingRange = selectedRange
                    textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
                    
                    delegate?.didChangeText(tView)
                    
                    characterBuffer.removeAll()
                    return false
                }
            } else {
                insertingText.removeFirst()
                insertingText += newlineInsert
                #if canImport(UIKit)
                textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                
                self.textStorage.endEditing()
                updateSelectedRange(NSRange(location: selectedRange.lowerBound + insertingText.count, length: 0))
                textView.setNeedsDisplay()
                #elseif canImport(AppKit)
                textView.textStorage!.replaceCharacters(in: selectedRange, with: insertingText)
                
                self.textStorage.endEditing()
                updateSelectedRange(NSRange(location: selectedRange.lowerBound + insertingText.count, length: 0))
                textView.setNeedsDisplay(textView.bounds)
                textView.didChangeText()
                
                #endif
                
                updateGutterWidth()
                shouldHighlightOnChange = false
                textStorage.editingRange = selectedRange
                textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
                
                delegate?.didChangeText(tView)
                
                characterBuffer.removeAll()
                return true
            }
        } else {
            if lastCompleted != "" && insertingText != "*" {
                if lastCompleted == "/*" {
                    lastCompleted = ""
                    insertingText += "*/"
                    
                    #if canImport(UIKit)
                    textView.textStorage.replaceCharacters(in: selectedRange, with: insertingText)
                    
                    self.textStorage.endEditing()
                    updateSelectedRange(NSRange(location: selectedRange.lowerBound + 1, length: 0))
                    textView.setNeedsDisplay()
                    #elseif canImport(AppKit)
                    textView.textStorage!.replaceCharacters(in: selectedRange, with: insertingText)
                    
                    self.textStorage.endEditing()
                    updateSelectedRange(NSRange(location: selectedRange.lowerBound + 1, length: 0))
                    textView.setNeedsDisplay(textView.bounds)
                    textView.didChangeText()
                    #endif
                    
                    shouldHighlightOnChange = false
                    textStorage.editingRange = selectedRange
                    textStorage.highlight(getVisibleRange(), cursorRange: selectedRange)
                    
                    delegate?.didChangeText(tView)
                    
                    characterBuffer.removeAll()
                    return false
                }
            }
        }
        
        self.textStorage.endEditing()
        return true
    }
    
    /// Updates the cursor position when the view scrolls
    public func scrollViewDidScroll(_ scrollView: FireflyScrollView) {
        updateCursorPosition()
    }
    
    #if canImport(UIKit)
    /// Intercepts clicking on a link
    public func textView(_ textView: TextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        delegate?.didClickLink(URL.absoluteString)
        return false
    }
    #elseif canImport(AppKit)
    /// Intercepts clicking on a link
    public func textView(_ textView: TextView, clickedOnLink link: Any, at charIndex: Int) -> Bool {
        if let link = link as? URL {
            delegate?.didClickLink(link.absoluteString)
            return false
        } else {
            return true
        }
    }
    #endif
    
    #if canImport(UIKit)
    /// Calls back to the delegate when the editor begins editing
    public func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing(self.textView)
    }
    
    /// Handles highlighting the correct amount of the view when text changes
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
    
    /// Calls back to delegate & updates cursor position
    public func textViewDidChangeSelection(_ textView: UITextView) {
        updateCursorPosition()
        delegate?.didChangeSelectedRange(self.textView, selectedRange: self.textView.selectedRange)
    }
    
    /// Override the key commands recognized by the view
    public override var keyCommands: [KeyCommand]? {
        delegate?.implementKeyCommands?.keyCommands(#selector(handleKeyCommand))
    }
    
    /// Calls back to the delegate when any key command is triggered
    @objc func handleKeyCommand(sender: KeyCommand) {
        delegate?.implementKeyCommands?.receiver(sender)
    }
    
    #endif
    
    #if canImport(AppKit)
    /// Calls back to the delegate when the editor begins editing
    public func textDidBeginEditing(_ notification: Notification) {
        delegate?.textViewDidBeginEditing(self.textView)
    }
    
    /// Calls back to delegate & updates cursor position
    public func textViewDidChangeSelection(_ notification: Notification) {
        updateCursorPosition()
        delegate?.didChangeSelectedRange(textView, selectedRange: textView.selectedRange())
    }
    
    /// Handles highlighting the correct amount of the view when text changes
    public func textDidChange(_ notification: Notification) {
        if updateGutterNow {
            updateGutterWidth()
        }
        if shouldHighlightOnChange {
            shouldHighlightOnChange = false
            textStorage.editingRange = textView.selectedRange
            textStorage.highlight(getVisibleRange(), cursorRange: textView.selectedRange)
        } else if highlightAll {
            highlightAll = false
            textStorage.highlight(NSRange(location: 0, length: textStorage.string.utf16.count), cursorRange: nil)
        }
        delegate?.didChangeText(textView)
    }
    #endif
}

//MARK: Supporting Functions
extension FireflySyntaxView {
    /// Get's the amount of whitespace that needs to be added to the begging of a line.
    /// Used when hitting enter
    /// - Parameter currentLine: The current line of text
    /// - Returns: Returns the constructed insert of whitespace
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
    
    /// Updates the position of the cursor  in the delegate
    private func updateCursorPosition() {
        if let cursorPositionChange = self.delegate?.cursorPositionChange {
            if let pos = self.textView.cursorPosition() {
                cursorPositionChange(self.textView.convert(pos, to: self.textView.superview))
            } else {
                cursorPositionChange(nil)
            }
        }
    }
    
    
    /// Updates the selected range of text
    /// - Parameter range: The new range of selected text
    func updateSelectedRange(_ range: NSRange) {
        if range.location + range.length <= text.utf16.count {
            #if canImport(UIKit)
            textView.selectedRange = range
            #elseif canImport(AppKit)
            textView.setSelectedRange(range)
            #endif
        }
    }
    
    #if canImport(AppKit)
    /// Get's the visible NSRange of text
    /// - Returns: The visible text represented as it's NSRange
    func getVisibleRange() -> NSRange {
        #warning("Needs to be fixed for macOS")
        let visibleRange = NSRange(location: 0, length: textView.text.utf16.count)
        return visibleRange
    }
    #endif
    
    #if canImport(UIKit)
    /// Get's the visible NSRange of text
    /// - Returns: The visible text represented as it's NSRange
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
    #endif
}
