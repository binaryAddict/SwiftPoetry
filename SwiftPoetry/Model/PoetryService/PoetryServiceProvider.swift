//
//  PoetryServiceProvider.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 22/10/2024.
//

import Foundation

struct PoetryServiceProvider {
    static let shared = PoetryServiceProvider(main: .mixed, offline: .offline)
    
    let main: any PoetryService
    let offline: any PoetryService
    
    func service(offlineOnly: Bool) -> any PoetryService {
        offlineOnly ? offline : main
    }
}

extension PoetryServiceProvider {
    static let offlineOnly = PoetryServiceProvider(main: .offline, offline: .offline)
    static let delayedNetwork = PoetryServiceProvider(main: .offline.delayed(), offline: .offline)
    static let failingNetwork = PoetryServiceProvider(main: .failing, offline: .offline)
    static let failingOffline = PoetryServiceProvider(main: .offline, offline: .failing)
}
