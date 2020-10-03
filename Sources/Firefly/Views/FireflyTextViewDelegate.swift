//
//  FireflyDelegate.swift
//  Firefly
//
//  Created by Zachary lineman on 9/29/20.
//  Copyright © 2020 Zachary Lineman. All rights reserved.
//

import Foundation

public protocol FireflyDelegate: class {

    func didChangeText(_ syntaxTextView: FireflyTextView)
}

public extension FireflyDelegate {
    func didChangeText(_ syntaxTextView: FireflyTextView) { }
}
