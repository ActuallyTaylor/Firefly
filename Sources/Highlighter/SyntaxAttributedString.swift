//
//  SyntaxAttributedString.swift
//  Firefly
//
//  Created by Zachary lineman on 12/24/20.
//

import UIKit

open class SyntaxAttributedString : NSTextStorage {
    /// Internal Storage
    let stringStorage = NSTextStorage()
    var cachedTokens: [Token] = []
    
    /// Returns a standard String based on the current one.
    open override var string: String { get { return stringStorage.string } }
    var syntax: Syntax
    var editingRange: NSRange = NSRange(location: 0, length: 0)
    var lastLength: Int = 0
    var maxTokenLength: Int = 30000
    
    public init(syntax: Syntax) {
        self.syntax = syntax
        super.init()
    }
    
    /// Initialize the CodeAttributedString
    public override init() {
        self.syntax = Syntax(language: "default", theme: "basic", font: "system")
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        self.syntax = Syntax(language: "default", theme: "basic", font: "system")
        super.init(coder: coder)
    }
    
    
    /// Called internally everytime the string is modified.
    open override func processEditing() {
        super.processEditing()
        if self.editedMask.contains(.editedCharacters) {
            //            let string = (self.string as NSString)
            //            let range: NSRange = string.paragraphRange(for: editedRange)
            
            //            highlight(range)
        }
    }
    
    /**
     Replaces the characters at the given range with the provided string.
     
     - parameter range: NSRange
     - parameter str:   String
     */
    open override func replaceCharacters(in range: NSRange, with str: String) {
        stringStorage.replaceCharacters(in: range, with: str)
        self.edited(TextStorageEditActions.editedCharacters, range: range, changeInLength: (str as NSString).length - range.length)
    }
    
    /**
     Returns the attributes for the character at a given index.
     
     - parameter location: Int
     - parameter range:    NSRangePointer
     
     - returns: Attributes
     */
    open override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [AttributedStringKey : Any] {
        return stringStorage.attributes(at: location, effectiveRange: range)
    }
    
    /**
     Sets the attributes for the characters in the specified range to the given attributes.
     
     - parameter attrs: [String : AnyObject]
     - parameter range: NSRange
     */
    open override func setAttributes(_ attrs: [AttributedStringKey : Any]?, range: NSRange) {
        stringStorage.setAttributes(attrs, range: range)
        self.edited(TextStorageEditActions.editedAttributes, range: range, changeInLength: 0)
    }
}

//MARK: Highlighting
extension SyntaxAttributedString {
    
    func highlight(_ range: NSRange, cursorRange: NSRange?, secondPass: Bool = false) {
        #if DEBUG
        let start = DispatchTime.now()
        #endif
        var cursorRange = cursorRange
        if cursorRange == nil {
            cursorRange = range
        }
        let range = changeCurrentRange(currRange: range, cursorRange: cursorRange!)
        
        if !(range.location + range.length > string.count) {
            self.beginEditing()
            
            self.setAttributes([NSAttributedString.Key.foregroundColor: syntax.theme.defaultFontColor, NSAttributedString.Key.font: syntax.currentFont], range: range)
            
            for item in syntax.definitions {
                var regex = try? NSRegularExpression(pattern: item.regex)
                if let option = item.matches.first {
                    regex = try? NSRegularExpression(pattern: item.regex, options: option)
                }
                
                regex?.enumerateMatches(in: string, options: .reportProgress, range: range, using: { (result, flags, stop) in
                    if let result = result {
                        let textRange: NSRange = result.range(at: item.group)
                        if notInsideToken(range: textRange) {
                            let color = syntax.getHighlightColor(for: item.type)
                            addToken(range: textRange, type: item.type, multiline: item.multiLine)
                            self.addAttributes([.foregroundColor: color, .font: syntax.currentFont], range: textRange)
                        }
                    }
                })
            }
            
            self.endEditing()
            self.edited(TextStorageEditActions.editedAttributes, range: range, changeInLength: 0)
        }
        
        #if debug
        let end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        debugPrint("Highlighting range: \(range) took \(timeInterval)")
        #endif
    }
    
    func notInsideToken(range: NSRange) -> Bool {
        return !cachedTokens.contains { (token) -> Bool in
            return token.range.encompasses(r2: range)
        }
    }
    
    func addToken(range: NSRange, type: String, multiline: Bool) {
        cachedTokens.append(Token(range: range, type: type, isMultiline: multiline))
    }
    
    func changeCurrentRange(currRange: NSRange, cursorRange: NSRange) -> NSRange {
        var range: NSRange = currRange
        let tokens = cachedTokens.filter { (token) -> Bool in return token.isMultiline }.filter { (token) -> Bool in return token.range.touches(r2: currRange) }
        let lengthDifference = string.count - lastLength

        for token in tokens {
            // When typing a character directly before a multi-line token the system will recognize it as part of the current token. This is because the lowerbound is the same as the upper bound of the newly placed character
            if token.range.touches(r2: cursorRange) {
                if token.range.length <= maxTokenLength {
                    //Upper and lower bounds
                    let tokenLower = token.range.lowerBound
                    let tokenUpper = token.range.upperBound
                    let rangeLower = range.lowerBound
                    let rangeUpper = range.upperBound
                    
                    let multLocation: Int = token.range.location
                    
                    let origLocation: Int = range.location
                    let origLength: Int = range.length
                    
                    var newLocation: Int = range.location
                    var newLength: Int = range.length
                    
                    if (tokenLower < rangeLower) && (tokenUpper > rangeUpper) {
                        debugPrint("Lower & Upper off screen")
                        let locationDifference = origLocation - multLocation
                        let leDifference = lengthDifference + (tokenUpper - rangeUpper)
                        newLength = (origLength + locationDifference + leDifference)
                        newLocation = multLocation
                    } else if tokenLower < rangeLower {
                        debugPrint("Lower end off screen")
                        let locationDifference = origLocation - multLocation
                        newLength = origLength + locationDifference
                        newLocation = multLocation
                    } else if tokenUpper > rangeUpper {
                        debugPrint("Upper end off screen")
                        newLength = tokenUpper + lengthDifference
                    }
                    
                    if newLength + newLocation > string.count {
                        debugPrint("Is Greater")
                        newLength = string.count - newLocation
                    }
                    
                    let newRange = NSRange(location: newLocation, length: newLength)
                    range = newRange
                }
            }
            /*
             else {
 //                print("Highlighting \(token.type) == \(token.range) == \(token.isMultiline)")
                 var tokenLower = token.range.lowerBound
                 var tokenUpper = token.range.upperBound
                 var cursorLower = cursorRange.lowerBound
                 var cursorUpper = cursorRange.upperBound

                 //TODO: Finish this lol
                 let origLocation: Int = range.location
 //                let origLength: Int = range.length

                 var newLocation: Int = range.location
                 var newLength: Int = range.length
                 
                 if cursorLower > tokenUpper {
                     // Token off top of screen
                     debugPrint("Token Physically Above Cursor")
                     newLocation = tokenUpper
                     newLength = range.upperBound - tokenUpper
                 } else if tokenLower > cursorLower {
                     // Token off bottom of screen
                     debugPrint("Token Physically Below Cursor")
                     adjustBelowRange(&token, &tokenLower, &tokenUpper, &cursorLower, cursorRange, &cursorUpper, origLocation, &newLength)
                 } else {
                     if cursorUpper == tokenLower {
                         debugPrint("Token Physically Below Cursor")
                         adjustBelowRange(&token, &tokenLower, &tokenUpper, &cursorLower, cursorRange, &cursorUpper, origLocation, &newLength)
                     } else if tokenUpper == cursorLower {
                         debugPrint("Token Physically Above Cursor")
                         newLocation = tokenUpper
                         newLength = range.upperBound - tokenUpper
                     } else {
                         adjustBelowRange(&token, &tokenLower, &tokenUpper, &cursorLower, cursorRange, &cursorUpper, origLocation, &newLength)
                     }
                 }
                 
                 let newRange = NSRange(location: newLocation, length: newLength)
                 range = newRange
             }
             }
             */
        }
        
        lastLength = string.count
        invalidateTokens(in: range)
        return range
    }
    
    func adjustBelowRange(_ token: inout Token, _ tokenLower: inout Int, _ tokenUpper: inout Int, _ cursorLower: inout Int, _ cursorRange: NSRange, _ cursorUpper: inout Int, _ origLocation: Int, _ newLength: inout Int) {
        if let index = cachedTokens.firstIndex(of: token) {
            if lastLength < string.count {
                let difference = string.count - lastLength
                cachedTokens[index].range = NSRange(location: token.range.location + difference, length: token.range.length)
                token.range = NSRange(location: token.range.location + difference, length: token.range.length)
            } else if lastLength > string.count {
                let difference = lastLength - string.count
                cachedTokens[index].range = NSRange(location: token.range.location - difference, length: token.range.length)
                token.range = NSRange(location: token.range.location - difference, length: token.range.length)
            }
            tokenLower = token.range.lowerBound
            tokenUpper = token.range.upperBound
            cursorLower = cursorRange.lowerBound
            cursorUpper = cursorRange.upperBound
        }
        let spaceBetweenCursorAndToken: Int = tokenLower - cursorUpper
        let startToCursorEnd: Int = cursorUpper - origLocation
        newLength = startToCursorEnd + spaceBetweenCursorAndToken
    }
    
    func isEditingInMultiline() -> (Bool, Token?) {
        let tokens = getMultilineTokens(in: editingRange)
        let firstToken: Token? = tokens.first
        return (!tokens.isEmpty, firstToken)
    }
    
    func getMultilineTokens(in range: NSRange) -> [Token] {
        let multilineTokens = cachedTokens.filter { (token) -> Bool in
            return range.overlaps(range: token.range) && token.isMultiline
        }
        return multilineTokens
    }
    
    func invalidateTokens(in range: NSRange) {
        cachedTokens.removeAll { (token) -> Bool in
            return range.touchesAdjusted(r2: token.range)
        }
    }
    
    func resetView() {
        cachedTokens.removeAll()
        self.setAttributes([NSAttributedString.Key.foregroundColor: syntax.theme.defaultFontColor, NSAttributedString.Key.font: syntax.currentFont], range: NSRange(location: 0, length: string.utf16.count))
    }
}
