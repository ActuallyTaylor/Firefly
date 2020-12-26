//
//  Dispatch.swift
//  
//
//  Created by Zachary lineman on 12/26/20.
//

import Foundation

typealias Dispatch = DispatchQueue

extension Dispatch {

    static func background(_ task: @escaping () -> Void) {
        Dispatch.global(qos: .background).async {
            task()
        }
    }

    static func main(_ task: @escaping () -> Void) {
        Dispatch.main.async {
            task()
        }
    }
}
