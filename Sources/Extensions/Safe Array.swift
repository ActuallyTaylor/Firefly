//
//  Safe Array.swift
//  Jellycore
//
//  Created by Zachary lineman on 12/17/20.
//

import Foundation

extension Array {
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }

        return self[index]
    }
}

