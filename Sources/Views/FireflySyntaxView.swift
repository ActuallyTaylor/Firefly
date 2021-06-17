//
//  FireflySyntaxView.swift
//  Firefly
//
//  Created by Zachary lineman on 9/27/20.
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public class FireflySyntaxView: FireflyView {
    
    ///The highlighting language
    @IBInspectable
    internal var language: String = "default"
    
    @IBInspectable
    internal var theme: String = "Basic"
    
    /// The name of the highlighters font
    @IBInspectable
    internal var fontName: String = "system"
    
    /// If set, sets the text views text to the given text. If gotten gets the text views text.
    @IBInspectable
    public var text: String {
        get {
            return textView.text
        }
        set(nText) {
            textView.text = nText
            textStorage.highlight(NSRange(location: 0, length: textStorage.string.utf16.count), cursorRange: nil)
            if dynamicGutterWidth {
                updateGutterWidth()
            }
            textView.selectedRange = NSRange(location: 0, length: 0)
        }
    }
    
    /// The minimum / standard gutter width. Becomes the minimum if dynamicGutterWidth is true otherwise it is the standard gutterWidth
    @IBInspectable
    internal var gutterWidth: CGFloat = 20
    
    /// If set the view will use a dynamic gutter width
    @IBInspectable
    internal var dynamicGutterWidth: Bool = true
    
    /// The views offset from the top of the keyboard
    @IBInspectable
    internal var keyboardOffset: CGFloat = 20
    
    /// Set too true if the view should be offset when the keyboard opens and closes.
    @IBInspectable
    internal var shouldOffsetKeyboard: Bool = false
    
    @IBInspectable
    internal var maxTokenLength: Int = 30000
    
    @IBInspectable
    internal var placeholdersAllowed: Bool = false

    @IBInspectable
    internal var linkPlaceholders: Bool = false
    
    @IBInspectable
    public var showLineNumbers: Bool = true

    @IBInspectable
    public var textSize: CGFloat = 14.0
    
    // Determines if the view should switch to the alternative theme when dark mode is enabled
    @IBInspectable
    public var switchToAltOnDarkmode: Bool = false

    
    /// The delegate that allows for you to get access the UITextViewDelegate from outside this class !
    /// !!DO NOT CHANGE textViews Delegate directly!!!
    public var delegate: FireflyDelegate? {
        didSet {
            delegate?.didChangeText(textView)
        }
    }
    
    public var textView: FireflyTextView!
    
    internal var lastCompleted: String = ""
    
    // A list of the most recent character's entered. First is the oldest, last is the newest
    public var characterBuffer: [String] = []
    
    public var style: Theme.UIStyle {
        get {
            return textStorage.syntax.theme.style
        }
    }
    
//    public var theme: String {
//        get {
//            if switchToAltOnDarkmode && inDarkmode {
//                return darkTheme
//            } else {
//                return lightTheme
//            }
//        }
//        set {
//            if switchToAltOnDarkmode && inDarkmode {
//                darkTheme = newValue
//            } else {
//                lightTheme = newValue
//            }
//        }
//    }
    
    internal var textStorage = SyntaxAttributedString(syntax: Syntax(language: "default", theme: "Basic", font: "system"))
    
    internal var layoutManager = LineNumberLayoutManager()
    
    internal var shouldHighlightOnChange: Bool = false
    
    internal var highlightAll: Bool = false
    
    internal var updateGutterNow: Bool = false
    
    #if canImport(UIKit)
    internal var inDarkmode: Bool = UITraitCollection.current.userInterfaceStyle == .dark
    #elseif canImport(AppKit)
    internal var inDarkmode: Bool = false
    #endif
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    var textsto = NSTextStorage()
    /// Sets up the basic parts of the view
    private func setup() {
        //Setup the Text storage and layout managers and actually add the textView to the screen.
        layoutManager.textStorage = textStorage
        textStorage.addLayoutManager(layoutManager)

        //This caused a ton of issues. Has to be the greatest finite magnitude so that the text container is big enough. Not setting to greatest finite magnitude would cause issues with text selection.
        let containerSize = CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude)
        let textContainer = NSTextContainer(size: containerSize)
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.widthTracksTextView = true
        
        #if os(iOS)
        textContainer.heightTracksTextView = true
        #endif

        layoutManager.addTextContainer(textContainer)
        let tFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        textView = FireflyTextView(frame: tFrame, textContainer: textContainer)
        textView.text = ""
        textView.isEditable = true
        textView.isSelectable = true

        self.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // Sets default values for the text view to make it more like an editor.
        #if canImport(UIKit)
        textView.isScrollEnabled = true
        textView.autocapitalizationType = .none
        textView.keyboardType = .default
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.smartQuotesType = .no
        textView.smartInsertDeleteType = .no
        
        if self.textStorage.syntax.theme.style == .dark {
            textView.keyboardAppearance = .dark
        } else {
            textView.keyboardAppearance = .light
        }
        setupNotifs()
        #elseif canImport(AppKit)
        inDarkmode = self.isDarkMode()
        textView.isAutomaticQuoteSubstitutionEnabled = false
        #endif
        
        textView.delegate = self
    }
    
    #if canImport(UIKit)
    /// Sets up keyboard movement notifications
    func setupNotifs() {
        if shouldOffsetKeyboard {
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
    }
    
    /// This detects keyboards height and adjusts the view to account for the keyboard in the way.
    @objc func adjustForKeyboard(notification: Notification) {
        if shouldOffsetKeyboard {
            guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            
            let keyboardScreenEndFrame = keyboardValue.cgRectValue
            let keyboardViewEndFrame = self.convert(keyboardScreenEndFrame, from: self.window)
            
            if notification.name == UIResponder.keyboardWillHideNotification {
                textView.contentInset = .zero
            } else {
                let top = textView.contentInset.top; let left = textView.contentInset.left; let right = textView.contentInset.right
                textView.contentInset = UIEdgeInsets(top: top, left: left, bottom: keyboardViewEndFrame.height + keyboardOffset, right: right)
            }
            textView.scrollIndicatorInsets = textView.contentInset
            
            let selectedRange = textView.selectedRange
            textView.scrollRangeToVisible(selectedRange)
        }
    }
    #endif
    /// Force highlights the current range
    public func forceHighlight() {
        textStorage.highlight(getVisibleRange(), cursorRange: textView.selectedRange)
    }
    
    /// Reset Highlighting
    public func resetHighlighting() {
        textStorage.resetView()
    }
    
    /// Just updates the views appearance
    private func updateAppearance(highlight: Bool = true) {
        #if canImport(UIKit)
        UIView.animate(withDuration: 0.2) { [self] in
            textView.backgroundColor = textStorage.syntax.theme.backgroundColor
            textView.tintColor = textStorage.syntax.theme.cursor
            if highlight {
                textStorage.highlight(NSRange(location: 0, length: textStorage.string.utf16.count), cursorRange: nil)
            }
            if textStorage.syntax.theme.style == .dark {
                textView.keyboardAppearance = .dark
            } else {
                textView.keyboardAppearance = .light
            }
        }
        #elseif canImport(AppKit)
        textView.backgroundColor = textStorage.syntax.theme.backgroundColor
        textView.insertionPointColor = textStorage.syntax.theme.cursor
        if highlight {
            textStorage.highlight(NSRange(location: 0, length: textStorage.string.utf16.count), cursorRange: nil)
        }
        #endif
    }
    
   /// Returns the current theme so you can get colors from that
    public func getCurrentTheme() -> Theme {
        return textStorage.syntax.theme
    }
    
    /// Returns the given theme so you can retreive colors from it
    static public func getTheme(name: String) -> Theme? {
        if let theme = themes[name] {
            let defaultColor = Color(hex: (theme["default"] as? String) ?? "#000000")
            let backgroundColor = Color(hex: (theme["background"] as? String) ?? "#000000")
            
            let currentLineColor = Color(hex: (theme["currentLine"] as? String) ?? "#000000")
            let selectionColor = Color(hex: (theme["selection"] as? String) ?? "#000000")
            let cursorColor = Color(hex: (theme["cursor"] as? String) ?? "#000000")
            
            let styleRaw = theme["style"] as? String
            let style: Theme.UIStyle = styleRaw == "light" ? .light : .dark

            let lineNumber = Color(hex: (theme["lineNumber"] as? String) ?? "#000000")
            let lineNumber_Active = Color(hex: (theme["lineNumber-Active"] as? String) ?? "#000000")

            var colors: [String: Color] = [:]
            
            if let cDefs = theme["definitions"] as? [String: String] {
                for item in cDefs {
                    colors.merge([item.key: Color(hex: (item.value))]) { (first, _) -> Color in return first }
                }
            }
            
            return Theme(defaultFontColor: defaultColor, backgroundColor: backgroundColor, currentLine: currentLineColor, selection: selectionColor, cursor: cursorColor, colors: colors, font: Font.systemFont(ofSize: Font.systemFontSize), style: style, lineNumber: lineNumber, lineNumber_Active: lineNumber_Active)
        }
        return nil
     }
    
    /// Retuns the name of every available theme
    static public func availableThemes() -> [String] {
        var arr: [String] = []
        for item in themes {
            arr.append(item.key)
        }
        return arr
    }
    
    /// Retuns the name of every available theme
    static public func availableLanguages() -> [String] {
        var arr: [String] = []
        for item in languages {
            arr.append(item.key)
        }
        return arr
    }
    
    /// Used to setup the entire firefly view
    public func setup(theme: String, language: String, font: String, offsetKeyboard: Bool, keyboardOffset: CGFloat, dynamicGutter: Bool, gutterWidth: CGFloat, placeholdersAllowed: Bool, linkPlaceholders: Bool, lineNumbers: Bool, fontSize: CGFloat) {
        textStorage.syntax.setLanguage(to: language)
        
//        self.setSwitchOnDarkmode(bool: switchToAlt)
        
        self.fontName = font
        
        textStorage.syntax.fontSize = fontSize
        
        textStorage.syntax.setFont(to: font)
        
        self.setShouldOffsetKeyboard(bool: offsetKeyboard)

        self.keyboardOffset = keyboardOffset
        
        self.setDynamicGutter(bool: dynamicGutter)
        
        self.setGutterWidth(width: gutterWidth)

        self.setPlaceholdersAllowed(bool: placeholdersAllowed)
        
        self.setLinkPlaceholders(bool: linkPlaceholders)

        self.setTheme(name: theme)
        self.language = language
        
        self.setLineNumbers(bool: lineNumbers)
    }
    
    /// Sets the theme of the view. Supply with a theme name
    public func setTheme(name: String, alt: Bool = false, highlight: Bool = true) {
        theme = name
        textStorage.syntax.setTheme(to: name)
        layoutManager.theme = textStorage.syntax.theme
        updateAppearance(highlight: highlight)
    }
    
    /// Sets the language that is highlighted
    public func setSwitchOnDarkmode(bool: Bool) {
        switchToAltOnDarkmode = bool
        updateAppearance()
    }

    
    /// Sets the language that is highlighted
    public func setLanguage(nLanguage: String) {
        language = nLanguage
        textStorage.syntax.setLanguage(to: nLanguage)
        updateAppearance()
    }
    
    /// Sets the font of the highlighter. Should be set to a font name, or "system" for the system.
    public func setFont(font: String) {
        fontName = font
        textStorage.syntax.setFont(to: font)
        updateAppearance()
    }
    
    /// Sets the gutter width.
    public func setShouldOffsetKeyboard(bool: Bool) {
        self.shouldOffsetKeyboard = bool
        #if canImport(UIkit)
        setupNotifs()
        #endif
    }
    
    /// Sets the gutter width.
    public func setGutterWidth(width: CGFloat) {
        self.gutterWidth = width
        textView.gutterWidth = gutterWidth
        layoutManager.gutterWidth = gutterWidth
    }
    
    /// Sets dynamicGutterWidth
    public func setDynamicGutter(bool: Bool) {
        self.dynamicGutterWidth = bool
        updateGutterWidth()
    }
    
    /// Sets the Keyboard Offset
    public func setKeyboardOffset(offset: CGFloat) {
        self.keyboardOffset = offset
    }
    
    /// Sets the max token length
    public func setMaxTokenLength(length: Int) {
        self.maxTokenLength = length
        textStorage.maxTokenLength = length
    }
    
    /// Sets placeholders allowed
    public func setPlaceholdersAllowed(bool: Bool) {
        self.placeholdersAllowed = bool
        textStorage.placeholdersAllowed = bool
    }
    
    /// Tells the view if it links should also be links
    public func setLinkPlaceholders(bool: Bool) {
        self.linkPlaceholders = bool
        textStorage.linkPlaceholders = bool
    }
    
    /// Set line numbers
    public func setLineNumbers(bool: Bool) {
        showLineNumbers = bool
        layoutManager.showLineNumbers = bool
        if bool {
            setGutterWidth(width: gutterWidth)
        } else {
            setGutterWidth(width: 0)
        }
        #if canImport(UIKit)
        textView.setNeedsDisplay()
        #elseif canImport(AppKit)
        textView.setNeedsDisplay(textView.bounds)
        #endif
    }
    
    /// Detects the proper width needed for the gutter.  Can be turned off by setting dynamicGutterWidth to false
    func updateGutterWidth() {
        if showLineNumbers {
            let components = text.components(separatedBy: .newlines)
            let count = components.count
            let maxNumberOfDigits = "\(count)".count
            
            let leftInset: CGFloat = 4.0
            let rightInset: CGFloat = 4.0
            let charWidth: CGFloat = 10.0
            let newWidth = CGFloat(maxNumberOfDigits) * charWidth + leftInset + rightInset
            
            if newWidth != gutterWidth {
                self.setGutterWidth(width: newWidth)
                #if canImport(UIKit)
                textView.setNeedsDisplay()
                #elseif canImport(AppKit)
                textView.setNeedsDisplay(textView.bounds)
                #endif
            }
        }
    }
    
    /// Print's all available fonts
    static func getAllFontsInPackage() {
        #if canImport(UIKit)
        Font.familyNames.forEach({ familyName in
            print("**** " + familyName + " ****")
            Font.fontNames(forFamilyName: familyName).forEach { fontName in
                print(fontName)
            }
            print("===================================")
        })
        #endif
    }
}
