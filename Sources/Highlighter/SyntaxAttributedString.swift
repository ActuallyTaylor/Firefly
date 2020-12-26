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
    
    public init(syntax: Syntax) {
        self.syntax = syntax
        super.init()
    }

    /// Initialize the CodeAttributedString
    public override init() {
        self.syntax = Syntax(language: "default", theme: "default", font: "system")
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        self.syntax = Syntax(language: "default", theme: "default", font: "system")
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
                        let color = syntax.getHighlightColor(for: item.type)
                        self.setAttributes([.foregroundColor: color, .font: syntax.currentFont], range: textRange)
                    }
                }
            }
//        }

        
        #if DEBUG
        self.endEditing()
        self.edited(TextStorageEditActions.editedAttributes, range: range, changeInLength: 0)

        let end = DispatchTime.now()

        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        debugPrint("Highlighting range: \(range) took \(timeInterval)")
        #endif
    }
}
