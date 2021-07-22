//
//  Comparable + Clamped.swift
//  Firefly
//
//  Created by Zachary lineman on 7/1/21.
//

import Foundation

extension Comparable {
    func clamped(to limits: Range<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
