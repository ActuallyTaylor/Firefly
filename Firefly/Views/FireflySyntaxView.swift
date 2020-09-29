//
//  FireflySyntaxView.swift
//  Refly
//
//  Created by Zachary lineman on 9/27/20.
//

import UIKit

public class FireflySyntaxView: UIView, UITextViewDelegate {
    
    ///The highlighting language
    @IBInspectable
    public var language: String = "Swift"
    
    ///The highlighting theme name
    @IBInspectable
    public var theme: String = "xcode-light"
    
    ///The highlighting font name
    @IBInspectable
    public var fontName: String = "system"
    
    @IBInspectable
    public var gutterWidth: CGFloat = 30 {
        didSet(width) {
            textView.gutterWidth = width
//            layoutManager.gutterWidth = width
        }
    }
    
    public var keyboardOffset: CGFloat = 20

    internal var textView: FireflyTextView!
    
    internal var textStorage = CodeAttributedString()
    
//    internal var layoutManager = LineNumberLayoutManager()
    
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
    
    
    private func setup() {
        //Setup the Text storage and layout managers and actually add the textView to the screen.
        guard let nTheme = Theme(name: theme, fontName: fontName) else { print("Error"); return }
        textStorage.language = language
        textStorage.highlightr.setTheme(to: nTheme)
        
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: .zero)
        layoutManager.addTextContainer(textContainer)

        let tFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        textView = FireflyTextView(frame: tFrame, textContainer: textContainer)
        textView.textContainer.size = textView.bounds.size
        textView.isScrollEnabled = true
        textView.theme = nTheme
        textView.text = ""

        textView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        textView.autocapitalizationType = .none
        textView.keyboardType = .default
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.smartQuotesType = .no
        textView.smartInsertDeleteType = .no
        textView.keyboardAppearance = .dark
        textView.delegate = self
    }
    
    func setupNotifs() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = self.convert(keyboardScreenEndFrame, from: self.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            let top = textView.contentInset.top; let left = textView.contentInset.left; let right = textView.contentInset.right
            textView.contentInset = UIEdgeInsets(top: top, left: left, bottom: keyboardViewEndFrame.height, right: right)
        }
        textView.scrollIndicatorInsets = textView.contentInset

        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    private func updateAppearence(theme: Theme) {
        textView.backgroundColor = theme.backgroundColor
    }
    
    public func setTheme(name: String) {
        guard let nTheme = Theme(name: name, fontName: fontName) else { return }
        theme = name
        textStorage.highlightr.setTheme(to: nTheme)
        updateAppearence(theme: textStorage.highlightr.theme)
        textView.theme = nTheme
//        layoutManager.theme = nTheme
    }
    
    public func setLanguage(nLanguage: String) {
        language = nLanguage
        textStorage.language = nLanguage
    }
    
    public func setFont(font: String) {
        guard let nTheme = Theme(name: theme, fontName: font) else { return }
        fontName = font
        textStorage.highlightr.setTheme(to: nTheme)
        updateAppearence(theme: textStorage.highlightr.theme)
        textView.theme = nTheme
    }
}
