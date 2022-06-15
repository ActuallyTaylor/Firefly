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
    
    /// A closure called whenever the text contents is modified.
    private var notifyWillChangeClosure: ((_ oldText: String, _ location: Int, _ newText: String) -> Void)? = nil
    
    /// The highlighting language
    @IBInspectable
    public internal(set) var language: String = "default"
    
    @IBInspectable
    public internal(set) var theme: String = "Basic"
    
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
            textStorage.cachedTokens.removeAll()
            textStorage.highlight(NSRange(location: 0, length: textStorage.string.utf16.count), cursorRange: nil)
            if dynamicGutterWidth {
                updateGutterWidth()
            }
            textView.selectedRange = NSRange(location: 0, length: 0)
        }
    }
    
    /// Safely replace a section of text in the editor.
    public func replace(range: NSRange, to newText: String, updateHighlighting: Bool = true) {
        #if canImport(UIKit)
        self.textStorage.beginEditing()
        textView.textStorage.replaceCharacters(in: range, with: newText)
        self.textStorage.endEditing()
        if updateHighlighting {
            textView.setNeedsDisplay()
        }
        #elseif canImport(AppKit)
        self.textStorage.beginEditing()
        textView.textStorage!.replaceCharacters(in: range, with: newText)
        self.textStorage.endEditing()
        if updateHighlighting {
            textView.setNeedsDisplay(textView.bounds)
        }
        #endif
    }
    
    /// The minimum / standard gutter width. Becomes the minimum if dynamicGutterWidth is true otherwise it is the standard gutterWidth
    @IBInspectable
    public internal(set) var gutterWidth: CGFloat = 20
    
    /// If set the editor will use a dynamic gutter width
    @IBInspectable
    public internal(set) var dynamicGutterWidth: Bool = true
    
    /// The editor's offset from the top of the keyboard
    @IBInspectable
    internal var keyboardOffset: CGFloat = 20
    
    /// Set too true if the editor should be offset when the keyboard opens and closes.
    @IBInspectable
    internal var shouldOffsetKeyboard: Bool = false
    
    /// The maximum token length for syntax highlighting
    @IBInspectable
    internal var maxTokenLength: Int = 30000
    
    /// If place holders should be rendered when text is wrapped by <#
    /// and #>
    @IBInspectable
    internal var placeholdersAllowed: Bool = false

    /// If placeholders should activate the text view's click link function
    @IBInspectable
    internal var linkPlaceholders: Bool = false
    
    /// If the editor should show
    @IBInspectable
    public var showLineNumbers: Bool = true

    /// The font size for the editor
    @IBInspectable
    public var textSize: CGFloat = 14.0
        
    #if canImport(AppKit)
    /// Determines if the editor is allowed to scroll horizontally.
    @IBInspectable
    public var wrapLines: Bool = true
    
    /// The key commands that are recognized by the editor
    var keyCommands: [KeyCommand]? = nil {
        didSet {
            textView.keyCommands = keyCommands
        }
    }
    #endif
    
    internal var lastCompleted: String = ""
    
    /// A list of the most recent character's entered. First is the oldest, last is the newest
    public var characterBuffer: [String] = []
    
    /// The current theme of the editor.
    /// Can be either `dark` or `light`
    public var style: Theme.UIStyle {
        get {
            return textStorage.syntax.theme.style
        }
    }
    
    /// Tells the editor whether or not it should update on the next time text changes
    internal var shouldHighlightOnChange: Bool = false
    
    /// Tells the editor if it should highlight the entire text
    internal var highlightAll: Bool = false
    
    /// Tells the editor if it needs to update the gutter width on the next update cycle.
    internal var updateGutterNow: Bool = false

    #if canImport(UIKit)
    /// Tells the editor whether or not it is in dark mode
    internal var inDarkmode: Bool = UITraitCollection.current.userInterfaceStyle == .dark
    #elseif canImport(AppKit)
    /// Tells the editor whether or not it is in dark mode
    internal var inDarkmode: Bool = false
    #endif

    /// The delegate that allows for you to get access the UITextViewDelegate from outside this class !
    /// !!DO NOT CHANGE textView's Delegate directly!!!
    public var delegate: FireflyDelegate? {
        didSet {
            delegate?.didChangeText(textView)
        }
    }
    
    /// This is the editor
    public var textView: FireflyTextView!
    
    #if canImport(AppKit)
    /// Used to allow the editor to scroll on macOS
    public var scrollView: FireflyScrollView!
    #endif
        
    /// This is what does the highlighting. It handles all the text storage
    internal var textStorage = SyntaxAttributedString(syntax: Syntax(language: "default", theme: "Basic", font: "system"))
    
    /// Handles how the editor is laid out.
    /// On iOS it handles the line numbers + placeholders
    /// On macOS it handles the placeholders
    internal var layoutManager = LineNumberLayoutManager()
    
    internal var textContainer: NSTextContainer!
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /// Sets up the basic parts of the view
    private func setup() {
        //Setup the Text storage and layout managers and actually add the textView to the screen.
        layoutManager.textStorage = textStorage
        textStorage.addLayoutManager(layoutManager)

        //This caused a ton of issues. Has to be the greatest finite magnitude so that the text container is big enough. Not setting too greatest finite magnitude would cause issues with text selection.
        let containerSize = CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude)
        textContainer = NSTextContainer(size: containerSize)
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.widthTracksTextView = true
        
        layoutManager.addTextContainer(textContainer)
        
        let tFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        textView = FireflyTextView(frame: tFrame, textContainer: textContainer)

        #if canImport(UIKit)
        // Setup a UITextView for UIKit
        textView.text = ""
        textView.isEditable = true
        textView.isSelectable = true

        self.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

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
        // Setup a NSTextView for AppKit
        scrollView = FireflyTextView.scrollableTextView()
        scrollView.documentView = textView
        
        textView.text = ""
        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true
        
        self.addSubview(scrollView)
        
        let contentSize = scrollView.contentSize
        
        if wrapLines {
            textContainer.containerSize = CGSize(width: contentSize.width, height: CGFloat.greatestFiniteMagnitude)
            textContainer.widthTracksTextView = true
        } else {
            textContainer.containerSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            textContainer.widthTracksTextView = false
        }
        
        textView.minSize = CGSize(width: 0, height: 0)
        textView.maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = wrapLines

        textView.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        if wrapLines {
            textView.autoresizingMask = [.width]
        } else {
            textView.autoresizingMask = [.width, .height]
        }
        
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = wrapLines
        scrollView.documentView = textView
        scrollView.contentView.postsBoundsChangedNotifications = true

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        if showLineNumbers {
            textView.lnv_setUpLineNumberView()
        }
        
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
    /// - Parameter notification: The notification that comes from changing the frame of the keyboard
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
    /// - Parameter highlight: Should the editor highlight on this appearance update
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
        
        var attributes = textView.selectedTextAttributes
        attributes.merge([NSAttributedString.Key.backgroundColor: textStorage.syntax.theme.selection]) { _, new in
            new
        }
        textView.selectedTextAttributes = attributes
        
        if highlight {
            textStorage.highlight(NSRange(location: 0, length: textStorage.string.utf16.count), cursorRange: nil)
        }
        #endif
    }
    
   /// Returns the current theme so you can get colors from that
    public func getCurrentTheme() -> Theme {
        return textStorage.syntax.theme
    }
    
    #if canImport(UIKit)
    /// Used to setup the entire firefly view on iOS, iPadOS, etc
    /// - Parameters:
    ///   - theme: Name of the theme
    ///   - language: Name of the language
    ///   - font: Name of the font
    ///   - offsetKeyboard: If the editor should offset for the keyboard
    ///   - keyboardOffset: Value of the keyboard offset
    ///   - dynamicGutter: If the editor should use a dynamic gutter
    ///   - gutterWidth: The width of the gutter
    ///   - placeholdersAllowed: If the placeholders are allowed
    ///   - linkPlaceholders: If link placeholders are allowed
    ///   - lineNumbers: If line numbers should be shown or not
    ///   - fontSize: The font size of the editor
    ///   - isReadOnly: If the view is read only
    public func setup(theme: String, language: String, font: String, offsetKeyboard: Bool, keyboardOffset: CGFloat, dynamicGutter: Bool, gutterWidth: CGFloat, placeholdersAllowed: Bool, linkPlaceholders: Bool, lineNumbers: Bool, fontSize: CGFloat, isEditable: Bool) {
        self.setLanguage(language: language)

        self.fontName = font
        self.setFontSize(size: fontSize)

        self.setShouldOffsetKeyboard(enabled: offsetKeyboard)

        self.keyboardOffset = keyboardOffset
        
        self.setDynamicGutter(enabled: dynamicGutter)
        
        self.setGutterWidth(width: gutterWidth)
        
        self.setLineNumbers(visible: lineNumbers)
        
        self.setPlaceholdersAllowed(allowed: placeholdersAllowed)
        
        self.setLinkPlaceholders(enabled: linkPlaceholders)

        self.setTheme(name: theme)
        
        self.setIsEditable(isEditable: isEditable)
    
        self.language = language
    }
    #elseif canImport(AppKit)
    /// Used to setup the entire firefly view on macOS
    /// - Parameters:
    ///   - theme: Name of the theme
    ///   - language: Name of the language
    ///   - font: Name of the font
    ///   - offsetKeyboard: If the editor should offset for the keyboard
    ///   - keyboardOffset: Value of the keyboard offset
    ///   - dynamicGutter: If the editor should use a dynamic gutter
    ///   - gutterWidth: The width of the gutter
    ///   - placeholdersAllowed: If the placeholders are allowed
    ///   - linkPlaceholders: If link placeholders are allowed
    ///   - lineNumbers: If line numbers should be shown or not
    ///   - fontSize: The font size of the editor
    ///   - wrapLines: If the editor should wrap the lines
    public func setup(theme: String, language: String, font: String, offsetKeyboard: Bool, keyboardOffset: CGFloat, dynamicGutter: Bool, gutterWidth: CGFloat, placeholdersAllowed: Bool, linkPlaceholders: Bool, lineNumbers: Bool, fontSize: CGFloat, wrapLines: Bool, isEditable: Bool) {
        self.setLanguage(language: language)

        self.fontName = font
        self.setFontSize(size: fontSize)
        
        self.setWrapLines(isAllowed: wrapLines)

        self.setShouldOffsetKeyboard(enabled: offsetKeyboard)

        self.keyboardOffset = keyboardOffset
        
        self.setDynamicGutter(enabled: dynamicGutter)
        
        self.setGutterWidth(width: gutterWidth)
        
        self.setLineNumbers(visible: lineNumbers)
        
        self.setPlaceholdersAllowed(allowed: placeholdersAllowed)
        
        self.setLinkPlaceholders(enabled: linkPlaceholders)
        
        self.setIsEditable(isEditable: isEditable)

        self.setTheme(name: theme)
    
        self.language = language
    }

    #endif
    

    /// Sets the closure to be called whenever the text contents is modified/
    /// - Parameter notifyWillChange: The closure.
    public func setNotifyWillChange(_ notifyWillChange: ((_ oldText: String, _ location: Int, _ newText: String) -> Void)?) {
        self.notifyWillChangeClosure = notifyWillChange
    }
    
    /// Sets the theme of the view. Supply with a theme name
    /// - Parameters:
    ///   - name: The name of theme
    ///   - highlight: Whether or not the editor should re-highlight after changing themes
    public func setTheme(name: String, highlight: Bool = true) {
        theme = name
        textStorage.syntax.setTheme(to: name)
        layoutManager.theme = textStorage.syntax.theme
        #if canImport(AppKit)
        textView.lineNumberView.theme = textStorage.syntax.theme
        #endif
        updateAppearance(highlight: highlight)
    }
    
    /// Sets the language that is highlighted
    /// - Parameter language: The name of the new language
    public func setLanguage(language: String) {
        self.language = language
        textStorage.syntax.setLanguage(to: language)
        #if canImport(AppKit)
        textView.lineNumberView.theme = textStorage.syntax.theme
        #endif
        updateAppearance()
    }
    
    /// Sets the font of the highlighter. Should be set to a font name, or "system" for the system.
    /// - Parameter name: The name of the font
    public func setFont(name: String) {
        fontName = name
        textStorage.syntax.setFont(to: name)
        #if canImport(AppKit)
        textView.lineNumberView.theme = textStorage.syntax.theme
        #endif
        updateAppearance()
    }
    
    /// Sets the size of the textviews font.
    /// - Parameter size: The size of the font
    public func setFontSize(size: CGFloat) {
        self.textSize = size
        textStorage.syntax.fontSize = size
        textStorage.syntax.setFont(to: fontName)
        #if canImport(AppKit)
        textView.lineNumberView.theme = textStorage.syntax.theme
        #endif
        updateAppearance()
    }

    /// Sets whether or not the editor should offset itself when the keyboard appears
    /// - Parameter bool: If the editor should offset itself or not
    public func setShouldOffsetKeyboard(enabled: Bool) {
        self.shouldOffsetKeyboard = enabled
        #if canImport(UIKit)
        setupNotifs()
        #endif
    }
    
    /// Sets the gutter width.
    /// - Parameter width: The width of the gutter
    public func setGutterWidth(width: CGFloat) {
        self.gutterWidth = width
        textView.gutterWidth = gutterWidth
        layoutManager.gutterWidth = gutterWidth
        
        #if canImport(AppKit)
        textView.lineNumberView.ruleThickness = gutterWidth
        textView.lineNumberView.drawHashMarksAndLabels(in: textView.bounds)
        #endif
    }
    
    /// Sets dynamicGutterWidth
    /// - Parameter allowed: Whether or not a dynamic gutter is enabled
    public func setDynamicGutter(enabled: Bool) {
        self.dynamicGutterWidth = enabled
        updateGutterWidth()
    }
    
    /// Sets the Keyboard Offset
    /// - Parameter offset: The offset of the keyboard.
    public func setKeyboardOffset(offset: CGFloat) {
        self.keyboardOffset = offset
    }
    
    /// Sets the max token length
    /// - Parameter length: The length of the max token
    public func setMaxTokenLength(length: Int) {
        self.maxTokenLength = length
        textStorage.maxTokenLength = length
    }
    
    /// Sets placeholders allowed
    /// - Parameter allowed: Whether or not placeholders are allowed to be generated
    public func setPlaceholdersAllowed(allowed: Bool) {
        self.placeholdersAllowed = allowed
        textStorage.placeholdersAllowed = allowed
    }
    
    /// Tells the view if it links should also be links
    /// - Parameter allowed: Whether or not link placeholders are enabled
    public func setLinkPlaceholders(enabled: Bool) {
        self.linkPlaceholders = enabled
        textStorage.linkPlaceholders = enabled
    }
    
    /// Set if the text can be edited
    /// - Parameter isEditable: Can the text be edited by the user
    public func setIsEditable(isEditable: Bool) {
        self.textView.isEditable = isEditable
    }
    
    /// Set line numbers
    /// - Parameter visible: Whether or not line numbers are visible
    public func setLineNumbers(visible: Bool) {
        showLineNumbers = visible
        layoutManager.showLineNumbers = visible
        if visible {
            setGutterWidth(width: gutterWidth)
        } else {
            setGutterWidth(width: 0)
        }
        
        #if canImport(UIKit)
        textView.setNeedsDisplay()
        #elseif canImport(AppKit)
        layoutManager.showLineNumbers = false
        if showLineNumbers {
            textView.lnv_setUpLineNumberView()
        } else {
            textView.lnv_removeLineNumberView()
        }
        textView.setNeedsDisplay(textView.bounds)
        #endif
    }
    
#if canImport(AppKit)
    /// Set if horizontal scrolling is allowed
    /// - Parameter isAllowed: Whether or not horizontal scroll is allowed
    func setWrapLines(isAllowed: Bool) {
        let contentSize = scrollView.contentSize

        wrapLines = isAllowed
        if wrapLines {
            textContainer.containerSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            textContainer.widthTracksTextView = false
        } else {
            textContainer.containerSize = CGSize(width: contentSize.width, height: CGFloat.greatestFiniteMagnitude)
            textContainer.widthTracksTextView = true
        }
        
        textView.isHorizontallyResizable = wrapLines
        textView.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        
        if wrapLines {
            textView.autoresizingMask = [.width, .height]
        } else {
            textView.autoresizingMask = [.width]
        }
        
        scrollView.hasHorizontalScroller = wrapLines

        textView.lnv_setUpLineNumberView()
    }
    #endif
    
    /// Detects the proper width needed for the gutter.  Can be turned off by setting dynamicGutterWidth to false
    func updateGutterWidth() {
        if showLineNumbers && dynamicGutterWidth {
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
                textView.lineNumberView.ruleThickness = newWidth
                textView.lineNumberView.drawHashMarksAndLabels(in: textView.bounds)
                #endif
            }
        }
    }
}

// MARK: Helping static functions
extension FireflySyntaxView {
    /// Generates a theme with the given name
    /// - Parameter name: The name of the theme you want to generate
    /// - Returns: The generated theme
    static public func getTheme(name: String) -> Theme? {
        if let theme = themes[name] {
            let defaultColor = FireflyColor(hex: (theme["default"] as? String) ?? "#000000")
            let backgroundColor = FireflyColor(hex: (theme["background"] as? String) ?? "#000000")
            
            let currentLineColor = FireflyColor(hex: (theme["currentLine"] as? String) ?? "#000000")
            let selectionColor = FireflyColor(hex: (theme["selection"] as? String) ?? "#000000")
            let cursorColor = FireflyColor(hex: (theme["cursor"] as? String) ?? "#000000")
            
            let styleRaw = theme["style"] as? String
            let style: Theme.UIStyle = styleRaw == "light" ? .light : .dark

            let lineNumber = FireflyColor(hex: (theme["lineNumber"] as? String) ?? "#000000")
            let lineNumber_Active = FireflyColor(hex: (theme["lineNumber-Active"] as? String) ?? "#000000")

            var colors: [String: FireflyColor] = [:]
            
            if let cDefs = theme["definitions"] as? [String: String] {
                for item in cDefs {
                    colors.merge([item.key: FireflyColor(hex: (item.value))]) { (first, _) -> FireflyColor in return first }
                }
            }
            
            return Theme(defaultFontColor: defaultColor, backgroundColor: backgroundColor, currentLine: currentLineColor, selection: selectionColor, cursor: cursorColor, colors: colors, font: FireflyFont.systemFont(ofSize: FireflyFont.systemFontSize), style: style, lineNumber: lineNumber, lineNumber_Active: lineNumber_Active)
        }
        return nil
     }
    
    /// Returns the name of every available theme
    static public func availableThemes() -> [String] {
        var arr: [String] = []
        for item in themes {
            arr.append(item.key)
        }

        return arr
    }
    
    /// Returns the name of every available theme
    static public func availableLanguages() -> [String] {
        var arr: [String] = []
        for item in languages {
            arr.append(item.key)
        }
        return arr
    }
    
    /// Print's all available fonts
    static func getAllFontsInPackage() {
        #if canImport(UIKit)
        FireflyFont.familyNames.forEach({ familyName in
            print("**** " + familyName + " ****")
            FireflyFont.fontNames(forFamilyName: familyName).forEach { fontName in
                print(fontName)
            }
            print("===================================")
        })
        #endif
    }
    
    /// Sends out notification of a section of text changing. Note that because calculating `oldText` is usually an extra step required, the param is
    /// marked as an auto-closure so that the body is only calcuated in the case that there is a `notifyWillChangeClosure` to actually notify.
    /// - Parameter oldText: Contents of the section before the change.
    /// - Parameter location: The index of the change.
    /// - Parameter newText: Contents of the section after the change..
    internal func notifyWillChange(oldText: @autoclosure () -> String, location: Int, newText: String) {
        if let notifyWillChangeClosure = self.notifyWillChangeClosure {
            notifyWillChangeClosure(oldText(), location, newText)
        }
    }
}
