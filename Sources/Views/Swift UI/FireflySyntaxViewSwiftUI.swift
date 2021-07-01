//
//  FireflySyntaxViewSwift.swift
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

    var offsetKeyboard: Bool = true
    var keyboardOffset: CGFloat = 20
    var dynamicGutter: Bool = true
    var gutterWidth: CGFloat = 20
    var placeholdersAllowed: Bool = true
    var linkPlaceholders: Bool = false
    var lineNumbers: Bool = true
    var fontSize: CGFloat = Font.systemFontSize
    let cursorPosition: Binding<CGRect?>?
    #if canImport(UIKit)
    let implementKeyCommands: (keyCommands: (Selector) -> [KeyCommand]?, receiver: (KeyCommand) -> Void)?
    #endif
    
    #if canImport(AppKit)
    var allowHorizontalScroll: Bool = true
    #endif
    
    var didChangeText: (FireflySyntaxEditor) -> Void
    var didChangeSelectedRange: (FireflySyntaxEditor, NSRange) -> Void
    var textViewDidBeginEditing: (FireflySyntaxEditor) -> Void

    #if canImport(UIKit)
    public init(text: Binding<String>, language: String, theme: String, fontName: String, cursorPosition: Binding<CGRect?>? = nil, implementKeyCommands: (keyCommands: (Selector) -> [KeyCommand]?, receiver: (KeyCommand) -> Void)? = nil, didChangeText: @escaping (FireflySyntaxEditor) -> Void, didChangeSelectedRange: @escaping (FireflySyntaxEditor, NSRange) -> Void, textViewDidBeginEditing: @escaping (FireflySyntaxEditor) -> Void) {
        self._text = text
        self.didChangeText = didChangeText
        self.didChangeSelectedRange = didChangeSelectedRange
        self.textViewDidBeginEditing = textViewDidBeginEditing
        self.language = language
        self.theme = theme
        self.fontName = fontName
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
    public init(text: Binding<String>, language: String, theme: String, fontName: String, allowHorizontalScroll: Bool, cursorPosition: Binding<CGRect?>? = nil, didChangeText: @escaping (FireflySyntaxEditor) -> Void, didChangeSelectedRange: @escaping (FireflySyntaxEditor, NSRange) -> Void, textViewDidBeginEditing: @escaping (FireflySyntaxEditor) -> Void) {
        self._text = text
        self.didChangeText = didChangeText
        self.didChangeSelectedRange = didChangeSelectedRange
        self.textViewDidBeginEditing = textViewDidBeginEditing
        self.language = language
        self.theme = theme
        self.fontName = fontName
        self.allowHorizontalScroll = allowHorizontalScroll
        
        self.cursorPosition = cursorPosition
    }

    public func makeNSView(context: Context) -> FireflySyntaxView {
        let wrappedView = FireflySyntaxView()
        wrappedView.delegate = context.coordinator
        context.coordinator.wrappedView = wrappedView
        context.coordinator.wrappedView.text = text
        
        #if canImport(UIKit)
        context.coordinator.wrappedView.setup(theme: theme, language: language, font: fontName, offsetKeyboard: offsetKeyboard, keyboardOffset: keyboardOffset, dynamicGutter: dynamicGutter, gutterWidth: gutterWidth, placeholdersAllowed: placeholdersAllowed, linkPlaceholders: linkPlaceholders, lineNumbers: lineNumbers, fontSize: fontSize)
        #elseif canImport(AppKit)
        context.coordinator.wrappedView.setup(theme: theme, language: language, font: fontName, placeholdersAllowed: placeholdersAllowed, linkPlaceholders: linkPlaceholders, lineNumbers: lineNumbers, fontSize: fontSize, allowHorizontalScroll: allowHorizontalScroll)
        #endif
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
            if let implementUIKeyCommands = parent.implementKeyCommands {
                 self.implementKeyCommands = implementKeyCommands
             }
            #endif
        }
        
        public func didChangeText(_ syntaxTextView: FireflyTextView) {
            Dispatch.main {
                self.parent.text = syntaxTextView.text
            }
            parent.didChangeText(parent)
        }
        
        public func didChangeSelectedRange(_ syntaxTextView: FireflyTextView, selectedRange: NSRange) {
            parent.didChangeSelectedRange(parent, selectedRange)
        }
        
        public func textViewDidBeginEditing(_ syntaxTextView: FireflyTextView) {
            parent.textViewDidBeginEditing(parent)
        }
    }
}
