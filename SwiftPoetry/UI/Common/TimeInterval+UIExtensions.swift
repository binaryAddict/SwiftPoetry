//
//  TimeInterval+UIExtensions.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 24/10/2024.
//

import Foundation

extension TimeInterval {
    var durationFormatted: String {
        Duration.seconds(self).formatted(.units(allowed: [.hours, .minutes, .seconds]))
    }
}
