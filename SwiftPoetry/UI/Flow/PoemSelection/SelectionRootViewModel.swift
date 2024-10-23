//
//  SelectionRootViewModel.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

@MainActor
@Observable
class SelectionRootViewModel {
    
    @ObservationIgnored
    @AppStorage(AppStorageKey.offlineOnly.rawValue) var offlineOnly = AppStorageDefaultValue.offlineOnly
    private let poetryServiceProvider: PoetryServiceProvider
    
    init(poetryServiceProvider: PoetryServiceProvider = .shared) {
        self.poetryServiceProvider = poetryServiceProvider
    }
    
    func randomPoemNavigation() -> some Hashable {
        RandomPoemNavigation(poetryServiceProvider: poetryServiceProvider)
    }
    
    func authorsNavigationValue() -> some Hashable {
        AuthorsNavigation(poetryServiceProvider: poetryServiceProvider)
    }
}
