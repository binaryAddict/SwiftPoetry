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
    
    func service(offlineOnly: Bool = false) -> any PoetryService {
        offlineOnly ? offline : main
    }
}

extension PoetryServiceProvider {
    enum TestMode {
        case real
        case offlineOnly
        case failingNetwork
    }
    
    static let offlineOnly = PoetryServiceProvider(main: .offline, offline: .offline)
    static let failingNetwork = PoetryServiceProvider(main: .failingNetwork, offline: .offline)
    static func testPreview(mode: TestMode = .offlineOnly) -> PoetryServiceProvider {
        switch mode {
        case .real:
            return .shared
        case .offlineOnly:
            return offlineOnly
        case .failingNetwork:
            return .failingNetwork
        }
    }
}
