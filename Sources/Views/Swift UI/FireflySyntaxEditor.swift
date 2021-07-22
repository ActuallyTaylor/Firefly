//
//  FireflySyntaxEditor.swift
//  Firefly
//
//  Created by Zachary lineman on 12/30/20.
//

import SwiftUI

// TODO
/*
- Languages, themes and font-names do not update automatically
*/

public struct FireflySyntaxEditor: ViewRepresentable {
    
    @Binding var text: String
    
    var language: Binding<String>
    var theme: Binding<String>
    var fontName: Binding<String>

    var dynamicGutter: Binding<Bool> = .constant(true)
    var gutterWidth: Binding<CGFloat> = .constant(20)
    var placeholdersAllowed: Binding<Bool> = .constant(true)
    var linkPlaceholders: Binding<Bool> = .constant(false)
    var lineNumbers: Binding<Bool> = .constant(true)
    var fontSize: Binding<CGFloat> = .constant(14)
    
    let cursorPosition: Binding<CGRect?>?
    
    // The below commands are ui framework specific
    #if canImport(UIKit)
    let implementKeyCommands: (keyCommands: (Selector) -> [KeyCommand]?, receiver: (KeyCommand) -> Void)?
    var keyboardOffset: Binding<CGFloat> = .constant(20)
    var offsetKeyboard: Binding<Bool> = .constant(true)
    #elseif canImport(AppKit)
    var keyCommands: () -> [KeyCommand]?
    var allowHorizontalScroll: Binding<Bool> = .constant(true)
    #endif
        
    // Delegate functions
    var didChangeText: (FireflyTextView) -> Void
    var didChangeSelectedRange: (FireflyTextView, NSRange) -> Void
    var textViewDidBeginEditing: (FireflyTextView) -> Void

    public let wrappedView = FireflySyntaxView()

    #if canImport(UIKit)
    /// Initializer for UIKit based implementations
    public init(
        text: Binding<String>,
        language: Binding<String> = .constant("default"),
        theme: Binding<String> = .constant("Basic"),
        fontName: Binding<String> = .constant("system"),
        fontSize: Binding<CGFloat> = .constant(FireflyFont.systemFontSize),
        dynamicGutter: Binding<Bool> = .constant(false),
        gutterWidth: Binding<CGFloat> = .constant(20),
        placeholdersAllowed: Binding<Bool> = .constant(true),
        linkPlaceholders: Binding<Bool> = .constant(false),
        lineNumbers: Binding<Bool> = .constant(true),
        keyboardOffset: Binding<CGFloat> = .constant(20),
        offsetKeyboard: Binding<Bool> = .constant(true),

        cursorPosition: Binding<CGRect?>? = nil,
        implementKeyCommands: (keyCommands: (Selector) -> [KeyCommand]?, receiver: (KeyCommand) -> Void)? = nil,
        didChangeText: @escaping (FireflyTextView) -> Void,
        didChangeSelectedRange: @escaping (FireflyTextView, NSRange) -> Void,
        textViewDidBeginEditing: @escaping (FireflyTextView) -> Void) {
        self._text = text
        self.didChangeText = didChangeText
        self.didChangeSelectedRange = didChangeSelectedRange
        self.textViewDidBeginEditing = textViewDidBeginEditing
        self.language = language
        self.theme = theme
        self.fontName = fontName

        self.fontSize = fontSize
        self.dynamicGutter = dynamicGutter
        self.gutterWidth = gutterWidth
        self.placeholdersAllowed = placeholdersAllowed
        self.linkPlaceholders = linkPlaceholders
        self.lineNumbers = lineNumbers
        self.keyboardOffset = keyboardOffset
        self.offsetKeyboard = offsetKeyboard
        self.cursorPosition = cursorPosition
        self.implementKeyCommands = implementKeyCommands
    }

    public func makeUIView(context: Context) -> FireflySyntaxView {
        let wrappedView = FireflySyntaxView()
        wrappedView.delegate = context.coordinator        
        context.coordinator.wrappedView = wrappedView
        context.coordinator.wrappedView.text = text
        context.coordinator.wrappedView.setup(theme: theme.wrappedValue, language: language.wrappedValue, font: fontName.wrappedValue, offsetKeyboard: offsetKeyboard.wrappedValue, keyboardOffset: keyboardOffset.wrappedValue, dynamicGutter: dynamicGutter.wrappedValue, gutterWidth: gutterWidth.wrappedValue, placeholdersAllowed: placeholdersAllowed.wrappedValue, linkPlaceholders: linkPlaceholders.wrappedValue, lineNumbers: lineNumbers.wrappedValue, fontSize: fontSize.wrappedValue)

        return wrappedView
    }

    public func updateUIView(_ uiView: FireflySyntaxView, context: Context) {}
    
    #elseif canImport(AppKit)
    /// Initializer for AppKit based implementations
    public init(
        text: Binding<String>,
        language: Binding<String> = .constant("default"),
        theme: Binding<String> = .constant("Basic"),
        fontName: Binding<String> = .constant("system"),
        fontSize: Binding<CGFloat> = .constant(FireflyFont.systemFontSize),
        dynamicGutter: Binding<Bool> = .constant(false),
        gutterWidth: Binding<CGFloat> = .constant(20),
        placeholdersAllowed: Binding<Bool> = .constant(true),
        linkPlaceholders: Binding<Bool> = .constant(false),
        lineNumbers: Binding<Bool> = .constant(true),
        allowHorizontalScroll: Binding<Bool> = .constant(false),
        cursorPosition: Binding<CGRect?>? = nil,
        keyCommands: @escaping () -> [KeyCommand]?,
        didChangeText: @escaping (FireflyTextView) -> Void,
        didChangeSelectedRange: @escaping (FireflyTextView, NSRange) -> Void,
        textViewDidBeginEditing: @escaping (FireflyTextView) -> Void) {
        
        self._text = text
        self.didChangeText = didChangeText
        self.didChangeSelectedRange = didChangeSelectedRange
        self.textViewDidBeginEditing = textViewDidBeginEditing
        self.language = language
        self.theme = theme
        self.fontName = fontName
        
        self.fontSize = fontSize
        self.dynamicGutter = dynamicGutter
        self.gutterWidth = gutterWidth
        self.placeholdersAllowed = placeholdersAllowed
        self.linkPlaceholders = linkPlaceholders
        self.lineNumbers = lineNumbers
        self.allowHorizontalScroll = allowHorizontalScroll
        self.cursorPosition = cursorPosition
        self.keyCommands = keyCommands

    }

    public func makeNSView(context: Context) -> FireflySyntaxView {
        wrappedView.delegate = context.coordinator
        context.coordinator.wrappedView = wrappedView
        context.coordinator.wrappedView.text = text
        context.coordinator.wrappedView.keyCommands = keyCommands()
        context.coordinator.wrappedView.setup(theme: theme.wrappedValue, language: language.wrappedValue, font: fontName.wrappedValue, offsetKeyboard: false, keyboardOffset: 0, dynamicGutter: dynamicGutter.wrappedValue, gutterWidth: gutterWidth.wrappedValue, placeholdersAllowed: placeholdersAllowed.wrappedValue, linkPlaceholders: linkPlaceholders.wrappedValue, lineNumbers: lineNumbers.wrappedValue, fontSize: fontSize.wrappedValue, allowHorizontalScroll: allowHorizontalScroll.wrappedValue)
        return wrappedView
    }
    
    public func updateNSView(_ view: FireflySyntaxView, context: Context) {
        if view.theme != theme.wrappedValue {
            view.setTheme(name: theme.wrappedValue)
        }
        if view.language != language.wrappedValue {
            view.setLanguage(language: language.wrappedValue)
        }
        if view.fontName != fontName.wrappedValue {
            view.setFont(name: fontName.wrappedValue)
        }
        if view.textSize != fontSize.wrappedValue {
            view.setFontSize(size: fontSize.wrappedValue)
        }
        if view.dynamicGutterWidth != dynamicGutter.wrappedValue {
            view.setDynamicGutter(enabled: dynamicGutter.wrappedValue)
        }
        if view.gutterWidth != gutterWidth.wrappedValue {
            view.setGutterWidth(width: gutterWidth.wrappedValue)
        }
        if view.placeholdersAllowed != placeholdersAllowed.wrappedValue {
            view.setPlaceholdersAllowed(allowed: placeholdersAllowed.wrappedValue)
        }
        if view.linkPlaceholders != linkPlaceholders.wrappedValue {
            view.setLinkPlaceholders(enabled: linkPlaceholders.wrappedValue)
        }
        if view.showLineNumbers != lineNumbers.wrappedValue {
            view.setLineNumbers(visible: lineNumbers.wrappedValue)
        }
        
        if view.isHorizontalScrollingEnabled != allowHorizontalScroll.wrappedValue {
            view.setIsHorizontalScrollAllowed(isAllowed: allowHorizontalScroll.wrappedValue)
        }
    }
    #endif
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: FireflyDelegate {
        public func didClickLink(_ link: URL) { }
        public var cursorPositionChange: ((CGRect?) -> Void)?
        
        #if canImport(UIKit)
        public var implementKeyCommands: (
             keyCommands: (Selector) -> [KeyCommand]?,
             receiver: (_ sender: KeyCommand) -> Void
         )?
        #endif
        
        let parent: FireflySyntaxEditor
        var wrappedView: FireflySyntaxView!
        
        init(_ parent: FireflySyntaxEditor) {
            self.parent = parent
            
            Dispatch.main {
                if let cursorPosition = parent.cursorPosition {
                    self.cursorPositionChange = {
                        cursorPosition.wrappedValue = $0
                    }
                }
            }
            
            #if canImport(UIKit)
            if let implementKeyCommands = parent.implementKeyCommands {
                 self.implementKeyCommands = implementKeyCommands
             }
            #endif
            
        }
        
        public func didChangeText(_ syntaxTextView: FireflyTextView) {
            Dispatch.main {
                self.parent.text = syntaxTextView.text
            }
            parent.didChangeText(syntaxTextView)
        }
        
        public func didChangeSelectedRange(_ syntaxTextView: FireflyTextView, selectedRange: NSRange) {
            parent.didChangeSelectedRange(syntaxTextView, selectedRange)
        }
        
        public func textViewDidBeginEditing(_ syntaxTextView: FireflyTextView) {
            parent.textViewDidBeginEditing(syntaxTextView)
        }
    }
}
