//
//  FireflySyntaxViewSwift.swift
//  Firefly
//
//  Created by Zachary lineman on 12/30/20.
//

import SwiftUI

// TODO
/*
- Languages, themes and fontnames do not update automatically
*/

public struct FireflySyntaxEditor: UIViewRepresentable {
    
    @Binding var text: String
    
    let cursorPosition: Binding<CGRect?>?
    let implementUIKeyCommands: (keyCommands: (Selector) -> [UIKeyCommand]?, receiver: (UIKeyCommand) -> Void)?
    
    var language: String
    var theme: String
    var fontName: String

    var didChangeText: (FireflySyntaxEditor) -> Void
    var didChangeSelectedRange: (FireflySyntaxEditor, NSRange) -> Void
    var textViewDidBeginEditing: (FireflySyntaxEditor) -> Void

    public init(
        text: Binding<String>,
        cursorPosition: Binding<CGRect?>? = nil,
        implementUIKeyCommands: (keyCommands: (Selector) -> [UIKeyCommand]?, receiver: (UIKeyCommand) -> Void)? = nil,
        language: String,
        theme: String,
        fontName: String,
        didChangeText: @escaping (FireflySyntaxEditor) -> Void,
        didChangeSelectedRange: @escaping (FireflySyntaxEditor, NSRange) -> Void,
        textViewDidBeginEditing: @escaping (FireflySyntaxEditor) -> Void
    ) {
        self._text = text
        self.cursorPosition = cursorPosition
        self.implementUIKeyCommands = implementUIKeyCommands
        self.didChangeText = didChangeText
        self.didChangeSelectedRange = didChangeSelectedRange
        self.textViewDidBeginEditing = textViewDidBeginEditing
        self.language = language
        self.theme = theme
        self.fontName = fontName
    }

    public func makeUIView(context: Context) -> FireflySyntaxView {
        let wrappedView = FireflySyntaxView()
        wrappedView.delegate = context.coordinator        
        context.coordinator.wrappedView = wrappedView
        context.coordinator.wrappedView.text = text
        context.coordinator.wrappedView.setFont(font: fontName)
        context.coordinator.wrappedView.setTheme(name: theme)
        context.coordinator.wrappedView.setLanguage(nLanguage: language)

        return wrappedView
    }

    public func updateUIView(_ uiView: FireflySyntaxView, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
     
    public class Coordinator: FireflyDelegate {
        
        public var cursorPositionChange: ((CGRect?) -> Void)?
        public var implementUIKeyCommands: (
            keyCommands: (Selector) -> [UIKeyCommand]?,
            receiver: (_ sender: UIKeyCommand) -> Void
        )?
        
        public func didClickLink(_ link: URL) { }
        
        let parent: FireflySyntaxEditor
        var wrappedView: FireflySyntaxView!
        
        init(_ parent: FireflySyntaxEditor) {
            self.parent = parent
            if let cursorPosition = parent.cursorPosition {
                self.cursorPositionChange = {
                    cursorPosition.wrappedValue = $0
                }
            }
            if let implementUIKeyCommands = parent.implementUIKeyCommands {
                self.implementUIKeyCommands = implementUIKeyCommands
            }
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
