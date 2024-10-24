//
//  HashableIgnored.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import Foundation

@propertyWrapper
struct HashableIgnored<T>: Hashable {
    var wrappedValue: T
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    static func == (lhs: HashableIgnored<T>, rhs: HashableIgnored<T>) -> Bool {
        true
    }
    func hash(into hasher: inout Hasher) {}
}
