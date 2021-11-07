//
//  FireflyTextViewTests.swift
//
//  Created by Marin Todorov on 11/7/21.
//

import XCTest
@testable import Firefly

class FireflyTextViewTests: XCTestCase {

	private func keyDownEvent(keyCode: UInt16, modifiers: NSEvent.ModifierFlags) -> NSEvent? {
		return NSEvent.keyEvent(with: .keyDown, location: .zero, modifierFlags: modifiers, timestamp: Date().timeIntervalSinceReferenceDate, windowNumber: 0, context: nil, characters: "", charactersIgnoringModifiers: "", isARepeat: false, keyCode: keyCode)
	}

	func testKeyCommandModifiersMatching() throws {
	#if canImport(AppKit)
		let textView = FireflyTextView()

		// Test keycommand with no modifier flags
		var didTriggerCommand = false
		textView.keyCommands = [.init(code: Keycode.tab, modifierFlags: [], action: {
			didTriggerCommand = true
			return true
		})]

		// No match for key
		do {
			didTriggerCommand = false

			// Trigger tab key
			let event = try XCTUnwrap(keyDownEvent(keyCode: Keycode.downArrow, modifiers: []))
			textView.keyDown(with: event)

			// Verify exectations
			XCTAssertFalse(didTriggerCommand)
		}

		// Exact match for key
		do {
			didTriggerCommand = false

			// Trigger tab key
			let event = try XCTUnwrap(keyDownEvent(keyCode: Keycode.tab, modifiers: []))
			textView.keyDown(with: event)

			// Verify exectations
			XCTAssertTrue(didTriggerCommand)
		}

		// Match with extra modifiers for key
		do {
			didTriggerCommand = false

			// Trigger tab key + Shift
			let event = try XCTUnwrap(keyDownEvent(keyCode: Keycode.tab, modifiers: [.shift]))
			textView.keyDown(with: event)

			// Verify exectations
			XCTAssertTrue(didTriggerCommand)
		}

		// Exact match for key + modifiers
		do {
			didTriggerCommand = false

			textView.keyCommands = [
				.init(code: Keycode.tab, modifierFlags: [.shift, .control], action: {
					didTriggerCommand = true
					return true
				})
			]

			// Trigger tab key + Shift + Control
			let event = try XCTUnwrap(keyDownEvent(keyCode: Keycode.tab, modifiers: [.shift, .control]))
			textView.keyDown(with: event)

			// Verify exectations
			XCTAssertTrue(didTriggerCommand)
		}

		// Match key + modifiers to an event with a superset of modifiers
		do {
			didTriggerCommand = false

			textView.keyCommands = [
				.init(code: Keycode.tab, modifierFlags: [.shift, .control], action: {
					didTriggerCommand = true
					return true
				})
			]

			// Trigger tab key + Shift + Control
			let event = try XCTUnwrap(keyDownEvent(keyCode: Keycode.tab, modifiers: [.shift, .control, .command, .capsLock]))
			textView.keyDown(with: event)

			// Verify exectations
			XCTAssertTrue(didTriggerCommand)
		}

		// A match with higher precedence (more modifiers) blocks the one with less precedence
		do {
			didTriggerCommand = false

			textView.keyCommands = [
				.init(code: Keycode.tab, modifierFlags: [], action: {
					didTriggerCommand = true
					return true
				}),
				.init(code: Keycode.tab, modifierFlags: [.shift], action: {
					return true
				})
			]

			// Trigger tab key + Shift
			let event = try XCTUnwrap(keyDownEvent(keyCode: Keycode.tab, modifiers: [.shift]))
			textView.keyDown(with: event)

			// Verify exectations
			XCTAssertFalse(didTriggerCommand)
		}
	#endif
    }
}
