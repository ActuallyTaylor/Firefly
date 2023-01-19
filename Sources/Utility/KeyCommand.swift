//
//  KeyCommand.swift
//  Firefly
//
//  Created by Zachary lineman on 7/1/21.
//

#if targetEnvironment(macCatalyst)

#else
#if canImport(AppKit)
import AppKit

/// A list of key codes that can not be represented by a string
public struct Keycode {
    
    // Layout-independent Keys
    // eg.These key codes are always the same key on all layouts.
    public static let returnKey                 : UInt16 = 0x24
    public static let enter                     : UInt16 = 0x4C
    public static let tab                       : UInt16 = 0x30
    public static let space                     : UInt16 = 0x31
    public static let delete                    : UInt16 = 0x33
    public static let escape                    : UInt16 = 0x35
    public static let command                   : UInt16 = 0x37
    public static let shift                     : UInt16 = 0x38
    public static let capsLock                  : UInt16 = 0x39
    public static let option                    : UInt16 = 0x3A
    public static let control                   : UInt16 = 0x3B
    public static let rightShift                : UInt16 = 0x3C
    public static let rightOption               : UInt16 = 0x3D
    public static let rightControl              : UInt16 = 0x3E
    public static let leftArrow                 : UInt16 = 0x7B
    public static let rightArrow                : UInt16 = 0x7C
    public static let downArrow                 : UInt16 = 0x7D
    public static let upArrow                   : UInt16 = 0x7E
    public static let volumeUp                  : UInt16 = 0x48
    public static let volumeDown                : UInt16 = 0x49
    public static let mute                      : UInt16 = 0x4A
    public static let help                      : UInt16 = 0x72
    public static let home                      : UInt16 = 0x73
    public static let pageUp                    : UInt16 = 0x74
    public static let forwardDelete             : UInt16 = 0x75
    public static let end                       : UInt16 = 0x77
    public static let pageDown                  : UInt16 = 0x79
    public static let function                  : UInt16 = 0x3F
    public static let f1                        : UInt16 = 0x7A
    public static let f2                        : UInt16 = 0x78
    public static let f4                        : UInt16 = 0x76
    public static let f5                        : UInt16 = 0x60
    public static let f6                        : UInt16 = 0x61
    public static let f7                        : UInt16 = 0x62
    public static let f3                        : UInt16 = 0x63
    public static let f8                        : UInt16 = 0x64
    public static let f9                        : UInt16 = 0x65
    public static let f10                       : UInt16 = 0x6D
    public static let f11                       : UInt16 = 0x67
    public static let f12                       : UInt16 = 0x6F
    public static let f13                       : UInt16 = 0x69
    public static let f14                       : UInt16 = 0x6B
    public static let f15                       : UInt16 = 0x71
    public static let f16                       : UInt16 = 0x6A
    public static let f17                       : UInt16 = 0x40
    public static let f18                       : UInt16 = 0x4F
    public static let f19                       : UInt16 = 0x50
    public static let f20                       : UInt16 = 0x5A
}

/// A struct that allows you to make UIKeyCommand like interactions on macOS
public struct NSLimitedKeyCommand {
    /// The input string that must be pressed
    var input: String?
    /// The code that must be pressed
    var code: UInt16?
    /// The modifier flags that must be activated
    var modifierFlags: NSEvent.ModifierFlags
    /// The action that should be called when the command is activated
    /// This must return a bool indicating whether or not the text view should continue with the action this key performs, after this block completes
    var action: () -> Bool
    
    /// Initialize an NSLimitedKeyCommand with an input string
    /// - Parameters:
    ///   - input: The input string that must be pressed
    ///   - modifierFlags: The modifier flags that must be activated
    ///   - action: The action that should be called when the command is activated
    public init(input: String, modifierFlags: NSEvent.ModifierFlags, action: @escaping () -> Bool) {
        self.input = input
        self.modifierFlags = modifierFlags
        self.action = action
        self.code = nil
    }
    
    /// Initialize an NSLimitedKeyCommand with a key code
    /// - Parameters:
    ///   - code: The code that must be pressed
    ///   - modifierFlags: The modifier flags that must be activated
    ///   - action: The action that should be called when the command is activated
    public init(code: UInt16, modifierFlags: NSEvent.ModifierFlags, action: @escaping () -> Bool) {
        self.code = code
        self.modifierFlags = modifierFlags
        self.action = action
        self.input = nil
    }

}
#endif
#endif
