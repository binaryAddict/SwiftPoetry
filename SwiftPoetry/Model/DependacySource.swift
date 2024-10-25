//
//  DependacySource.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 25/10/2024.
//

import Foundation

struct DependacySource {
    static let shared = DependacySource()
    var poetryServiceProvider = PoetryServiceProvider.shared
    var settings = Settings.shared
}
