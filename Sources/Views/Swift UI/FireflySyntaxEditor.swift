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
    
    var language: String
    var theme: String
    var fontName: String

    var dynamicGutter: Bool = true
    var gutterWidth: CGFloat = 20
    var placeholdersAllowed: Bool = true
    var linkPlaceholders: Bool = false
    var lineNumbers: Bool = true
    var fontSize: CGFloat = FireflyFont.systemFontSize
    
    let cursorPosition: Binding<CGRect?>?
    
    // The below commands are ui framework specific
    #if canImport(UIKit)
    let implementKeyCommands: (keyCommands: (Selector) -> [KeyCommand]?, receiver: (KeyCommand) -> Void)?
    var keyboardOffset: CGFloat = 20
    var offsetKeyboard: Bool = true
    #elseif canImport(AppKit)
    var keyCommands: () -> [KeyCommand]?
    var allowHorizontalScroll: Bool = true
    #endif
        
    // Delegate functions
    var didChangeText: (FireflyTextView) -> Void
    var didChangeSelectedRange: (FireflyTextView, NSRange) -> Void
    var textViewDidBeginEditing: (FireflyTextView) -> Void

    
    #if canImport(UIKit)
    /// Initializer for UIKit based implementations
    public init(
        text: Binding<String>,
        language: String = "default",
        theme: String = "Basic",
        fontName: String = "system",
        fontSize: CGFloat = FireflyFont.systemFontSize,
        dynamicGutter: Bool = true,
        gutterWidth: CGFloat = 20,
        placeholdersAllowed: Bool = true,
        linkPlaceholders: Bool = false,
        lineNumbers: Bool = true,
        keyboardOffset: CGFloat = 20,
        offsetKeyboard: Bool = true,

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
        context.coordinator.wrappedView.setup(theme: theme, language: language, font: fontName, offsetKeyboard: offsetKeyboard, keyboardOffset: keyboardOffset, dynamicGutter: dynamicGutter, gutterWidth: gutterWidth, placeholdersAllowed: placeholdersAllowed, linkPlaceholders: linkPlaceholders, lineNumbers: lineNumbers, fontSize: fontSize)

        return wrappedView
    }

    public func updateUIView(_ uiView: FireflySyntaxView, context: Context) {}
    
    #elseif canImport(AppKit)
    /// Initializer for AppKit based implementations
    public init(
        text: Binding<String>,
        language: String = "default",
        theme: String = "Basic",
        fontName: String = "system",
        fontSize: CGFloat = FireflyFont.systemFontSize,
        dynamicGutter: Bool = false,
        gutterWidth: CGFloat = 20,
        placeholdersAllowed: Bool = true,
        linkPlaceholders: Bool = false,
        lineNumbers: Bool = true,
        allowHorizontalScroll: Bool = false,
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
        let wrappedView = FireflySyntaxView()
        wrappedView.delegate = context.coordinator
        context.coordinator.wrappedView = wrappedView
        context.coordinator.wrappedView.text = text
        context.coordinator.wrappedView.keyCommands = keyCommands()
        context.coordinator.wrappedView.setup(theme: theme, language: language, font: fontName, offsetKeyboard: false, keyboardOffset: 0, dynamicGutter: dynamicGutter, gutterWidth: gutterWidth, placeholdersAllowed: placeholdersAllowed, linkPlaceholders: linkPlaceholders, lineNumbers: lineNumbers, fontSize: fontSize, allowHorizontalScroll: allowHorizontalScroll)
        return wrappedView
    }
    
    public func updateNSView(_ view: FireflySyntaxView, context: Context) {}
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
