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
    
    func highlight(_ range: NSRange, secondPass: Bool = false) {
        #if DEBUG
        let start = DispatchTime.now()
        #endif
        let range = changeCurrentRange(currRange: range)
        
        if !(range.location + range.length > string.count) {
            self.beginEditing()
            self.setAttributes([.foregroundColor: syntax.theme.defaultFontColor, .font: syntax.currentFont], range: range)
            
    // Commented out because it causes a nasty flash
    //        Dispatch.background { [self] in
            for item in syntax.definitions {
                var regex = try? NSRegularExpression(pattern: item.regex)
                if let option = item.matches.first {
                    regex = try? NSRegularExpression(pattern: item.regex, options: option)
                }//NSRange(location: 0, length: string.utf16.count)
                if let matches = regex?.matches(in: string, options: [], range: range) {
                    for aMatch in matches {
                        let textRange: NSRange = aMatch.range(at: item.group)
                        if notInsideToken(range: textRange) {
                            let color = syntax.getHighlightColor(for: item.type)
                            addToken(range: textRange, type: item.type, multiline: item.multiLine)
                            self.setAttributes([.foregroundColor: color, .font: syntax.currentFont], range: textRange)
                        }
                    }
                }
            }
        }
//        }
        
        self.endEditing()
        self.edited(TextStorageEditActions.editedAttributes, range: range, changeInLength: 0)
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
    
    func changeCurrentRange(currRange: NSRange) -> NSRange {
        var range: NSRange = currRange
        let tokens = cachedTokens.filter { (token) -> Bool in return token.isMultiline }.filter { (token) -> Bool in return token.range.touches(r2: range) }
        let lengthDifference = string.count - lastLength
//        guard let stringRange = Range(range, in: string) else { return currRange }
//        print(string[stringRange])

        
        for token in tokens {
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
                debugPrint("Lower off screen")
                let locationDifference = origLocation - multLocation
                newLength = origLength + locationDifference
                newLocation = multLocation
            } else if tokenUpper > rangeUpper {
                debugPrint("Upper screen")
                newLength = tokenUpper + lengthDifference
            }

            if newLength + newLocation > string.count {
                debugPrint("Is Greater")
                newLength = string.count - newLocation
            }
            
            let newRange = NSRange(location: newLocation, length: newLength)
            range = newRange
        }
        
        lastLength = string.count
        invalidateTokens(in: range)
        return range
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
            return range.encompasses(r2: token.range)
        }
    }
}
