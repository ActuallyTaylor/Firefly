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
    
    /// The gutter width of the textview
    var gutterWidth: CGFloat = 20 {
        didSet {
            #if canImport(UIKit)
            textContainerInset = EdgeInsets(top: 0, left: gutterWidth, bottom: 0, right: 0)
            #endif
        }
    }
    
    #if canImport(AppKit)
    /// The keyboard commands that are recognized by the text view.
    /// These are just a mirror of the same variable in FireflySyntaxView
    internal var keyCommands: [KeyCommand]? = nil
    #endif
    
    /// Returns a CGRect for the cursor position in the text view's coordinates. If no cursor is present, it returns nil.
    /// source: https://stackoverflow.com/a/43167060/3902590
    public func cursorPosition() -> CGRect? {
        #if canImport(UIKit)
        if let selectedRange = self.selectedTextRange {
            // `caretRect` is in the `textView` coordinate space.
            return self.caretRect(for: selectedRange.end)
        } else {
            // No selection and no caret in UITextView.
            return nil
        }
        #elseif canImport(AppKit)
        return boundingRect(forCharacterRange: selectedRange())
        #endif
    }
    
    #if canImport(UIKit)
    /// Get's the current word that the cursor is on
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
    
    #if canImport(AppKit)
    /// Intercepts the key presses of the text view.
    /// Checks if their is a keycommand that can be executed on that event.
    public override func keyDown(with event: NSEvent) {
        var performed = false
        if let keyCommands = keyCommands {
			for command in keyCommands.sorted(by: { lhs, rhs in
				return lhs.modifierFlags.rawValue > rhs.modifierFlags.rawValue
			}) {
				// Check if the key code or the character matches the command
				if event.characters == command.input || event.keyCode == command.code {

					// Verify, in case there is a modifier expectation, that the event modifiers match
					if command.modifierFlags.isEmpty || event.modifierFlags.contains(command.modifierFlags) {
						performed = true
						if command.action() {
							super.keyDown(with: event)
						}

						// Don't try to match lower precedence commands
						// i.e. if Shift+Tab already matched, no need to match a Tab.
						break
					}
				}
            }
        }
        if !performed {
            super.keyDown(with: event)
        }
    }
    
    /// Get's the current word that the cursor is on
    public func currentWord() -> String {
        guard let cursorRange = self.selectedRanges.first?.rangeValue else { return "" }
        guard let lineRange = self.textStorage?.mutableString.lineRange(for: cursorRange) else { return "" }
        
        var lowerBound = cursorRange.lowerBound
        while lowerBound - 1 >= lineRange.lowerBound {
            let sub = self.textStorage!.mutableString.substring(with: NSRange(location: lowerBound - 1, length: 1))
            lowerBound -= 1
            if sub == " " || sub == "\n" || sub == "\t" {
                break
            }
        }
        
        var upperBound = cursorRange.upperBound
        
        while upperBound + 1 <= lineRange.upperBound {
            let sub = self.textStorage!.mutableString.substring(with: NSRange(location: upperBound, length: 1))
            upperBound += 1
            if sub == " " || sub == "\n" || sub == "\t" {
                break
            }
        }
        
        var length = (upperBound - lowerBound)
        length = length.clamped(to: 0..<self.textStorage!.mutableString.length)
        
        let range = NSRange(location: lowerBound, length: length)
        
        var substring = self.textStorage?.mutableString.substring(with: range) ?? ""
        substring = substring.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return substring
    }
    
    /// Get's the current range of the word that the cursor is on
    public func currentWordRange() -> NSRange {
        guard let cursorRange = self.selectedRanges.first?.rangeValue else { return NSRange(location: 0, length: 0) }
        guard let lineRange = self.textStorage?.mutableString.lineRange(for: cursorRange) else { return NSRange(location: 0, length: 0) }
        
        var lowerBound = cursorRange.lowerBound
        while lowerBound - 1 >= lineRange.lowerBound {
            let sub = self.textStorage!.mutableString.substring(with: NSRange(location: lowerBound - 1, length: 1))
            lowerBound -= 1
            if sub == " " || sub == "\n" {
                break
            }
        }
        
        var upperBound = cursorRange.upperBound
        
        while upperBound + 1 <= lineRange.upperBound {
            let sub = self.textStorage!.mutableString.substring(with: NSRange(location: upperBound, length: 1))
            upperBound += 1
            if sub == " " || sub == "\n" {
                if sub == "\n" {
                    upperBound -= 1
                }
                break
            }
        }
        
        var length = (upperBound - lowerBound)
        length = length.clamped(to: 0..<self.textStorage!.mutableString.length)
        
        let range = NSRange(location: lowerBound, length: length)
        
        
        return range
    }
    #endif
}

