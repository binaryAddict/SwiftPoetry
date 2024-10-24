//
//  NumberFormatter+UIExtensions.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 24/10/2024.
//

import Foundation

extension NumberFormatter {
    static let averageWordsPerMinute = NumberFormatter().with {
        $0.numberStyle = .decimal
        $0.minimumFractionDigits = 1
        $0.maximumFractionDigits = 1
    }
}
