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
    static let offlineOnly = PoetryServiceProvider(main: .offline, offline: .offline)
}
