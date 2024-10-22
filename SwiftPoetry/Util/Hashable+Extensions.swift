//
//  Hashable+Extensions.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import Foundation

protocol ObjectInstanceHashable: AnyObject, Hashable {}

extension ObjectInstanceHashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs === rhs
    }
    nonisolated func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
}

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

