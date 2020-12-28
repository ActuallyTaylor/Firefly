//
//  FireflySyntaxView.swift
//  Refly
//
//  Created by Zachary lineman on 9/27/20.
//

import UIKit

@IBDesignable
public class FireflySyntaxView: UIView {
    
    ///The highlighting language
    @IBInspectable
    public var language: String = "Swift"
    
    ///The highlighting theme name
    @IBInspectable
    public var theme: String = "xcode-light"
    
    /// The name of the highlighters font
    @IBInspectable
    public var fontName: String = "system"
    
    /// If set, sets the text views text to the given text. If gotten gets the text views text.
    @IBInspectable
    public var text: String {
        get {
            return textView.text
        }
        set(nText) {
            textView.text = nText
            textStorage.highlight(NSRange(location: 0, length: textStorage.string.count))
            if dynamicGutterWidth {
                updateGutterWidth()
            }
        }
    }
    
    /// The minimum / standard gutter width. Becomes the minimum if dynamicGutterWidth is true otherwise it is the standard gutterWidth
    @IBInspectable
    public var gutterWidth: CGFloat = 20 {
        didSet {
            textView.gutterWidth = gutterWidth
            layoutManager.gutterWidth = gutterWidth
        }
    }
    
    /// If set the view will use a dynamic gutter width
    @IBInspectable
    public var dynamicGutterWidth: Bool = true {
        didSet {
            updateGutterWidth()
        }
    }
    
    /// The views offset from the top of the keyboard
    @IBInspectable
    public var keyboardOffset: CGFloat = 20
    
    /// Set to true if the view should be offset when the keyboard opens and closes.
    @IBInspectable
    public var shouldOffsetKeyboard: Bool = false {
        didSet {
            setupNotifs()
        }
    }
    
    /// The delegate that allows for you to get access the UITextViewDelegate from outside this class !
    /// !!DO NOT CHANGE textViews Delegate directly!!!
    public var delegate: FireflyDelegate? {
        didSet {
            delegate?.didChangeText(textView)
        }
    }
    
    public var textView: FireflyTextView!
    
    internal var textStorage = SyntaxAttributedString(syntax: Syntax(language: "default", theme: "Basic", font: "system"))
    
    internal var layoutManager = LineNumberLayoutManager()
    
    internal var shouldHighlightOnChange: Bool = false
    
    internal var highlightAll: Bool = false
    
    internal var lastChar: Character?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupNotifs()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupNotifs()
    }
    
    /// Sets up the basic parts of the view
    private func setup() {
        //Setup the Text storage and layout managers and actually add the textView to the screen.
        layoutManager.textStorage = textStorage
        textStorage.addLayoutManager(layoutManager)

        //This caused a ton of issues. Has to be the greatest finite magnitude so that the text container is big enough. Not setting to greatest finite magnitude would cause issues with text selection.
        let containerSize = CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude)
        let textContainer = NSTextContainer(size: containerSize)
        textContainer.lineBreakMode = .byWordWrapping
        
        layoutManager.addTextContainer(textContainer)
        let tFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        textView = FireflyTextView(frame: tFrame, textContainer: textContainer)
        textView.isScrollEnabled = true
        textView.text = ""
        
        self.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // Sets default values for the text view to make it more like an editor.
        textView.autocapitalizationType = .none
        textView.keyboardType = .default
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.smartQuotesType = .no
        textView.smartInsertDeleteType = .no
        textView.keyboardAppearance = .dark
        textView.delegate = self
    }
    
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
    
    /// Just updates the views appearence
    private func updateAppearence() {
        textView.backgroundColor = textStorage.syntax.theme.backgroundColor
        textView.tintColor = textStorage.syntax.theme.cursor
        textStorage.highlight(NSRange(location: 0, length: textStorage.string.count))
    }
    
   /// Returns the current theme so you can get colors from that
    public func getCurrentTheme() -> Theme {
        return textStorage.syntax.theme
    }
    
    /// Returns the current theme so you can get colors from that
    static public func getTheme(name: String) -> Theme? {
        if let theme = themes[name] {
            let defaultColor = UIColor(hex: (theme["default"] as? String) ?? "#000000")
            let backgroundColor = UIColor(hex: (theme["background"] as? String) ?? "#000000")
            
            let currentLineColor = UIColor(hex: (theme["currentLine"] as? String) ?? "#000000")
            let selectionColor = UIColor(hex: (theme["selection"] as? String) ?? "#000000")
            let cursorColor = UIColor(hex: (theme["cursor"] as? String) ?? "#000000")

            var colors: [String: UIColor] = [:]
            
            if let cDefs = theme["definitions"] as? [String: String] {
                for item in cDefs {
                    colors.merge([item.key: UIColor(hex: (item.value))]) { (first, _) -> UIColor in return first }
                }
            }
            
            return Theme(defaultFontColor: defaultColor, backgroundColor: backgroundColor, currentLine: currentLineColor, selection: selectionColor, cursor: cursorColor, colors: colors, font: UIFont.systemFont(ofSize: UIFont.systemFontSize))
        }
        return nil
     }
    
    /// Sets the theme of the view. Supply with a theme name
    public func setTheme(name: String) {
        theme = name
        textStorage.syntax.setTheme(to: name)
        layoutManager.theme = textStorage.syntax.theme
        updateAppearence()
    }
    
    /// Retuns the name of every available theme
    static public func getAvailableThemes() -> [String] {
        var arr: [String] = []
        for item in themes {
            arr.append(item.key)
        }
        return arr
    }
    
    /// Sets the language that is highlighted
    public func setLanguage(nLanguage: String) {
//        if !(Highlightr()?.supportedLanguages().contains(nLanguage) ?? true) { return }
        language = nLanguage
        textStorage.syntax.setLanguage(to: nLanguage)
        updateAppearence()
    }
    
    /// Sets the font of the highlighter. Should be set to a font name, or "system" for the system.
    public func setFont(font: String) {
        fontName = font
        textStorage.syntax.setFont(to: font)
        updateAppearence()
    }
    
    /// Detects the proper width needed for the gutter.  Can be turned off by setting dynamicGutterWidth to false
    func updateGutterWidth() {
        let components = text.components(separatedBy: .newlines)
        let count = components.count
        let maxNumberOfDigits = "\(count)".count
        
        let leftInset: CGFloat = 4.0
        let rightInset: CGFloat = 4.0
        let charWidth: CGFloat = 10.0
        let newWidth = CGFloat(maxNumberOfDigits) * charWidth + leftInset + rightInset
        
        if newWidth != gutterWidth {
            gutterWidth = newWidth
            textView.setNeedsDisplay()
        }
        textStorage.highlight(NSRange(location: 0, length: textStorage.string.count))
    }
}
