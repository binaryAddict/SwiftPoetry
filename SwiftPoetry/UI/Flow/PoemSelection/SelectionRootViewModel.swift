//
//  SelectionRootViewModel.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

@MainActor
@Observable
final class SelectionRootViewModel: ObjectInstanceHashable {
    
    private let poetryServiceProvider: PoetryServiceProvider
    var settings: Settings
    
    init(poetryServiceProvider: PoetryServiceProvider = .shared, settings: Settings = .shared) {
        self.poetryServiceProvider = poetryServiceProvider
        self.settings = settings
    }
    
    func randomPoemNavigation() -> some Hashable {
        RandomPoemViewModel(poetryServiceProvider: poetryServiceProvider, settings: settings)
    }
    
    func authorsNavigationValue() -> some Hashable {
        AuthorsViewModel(poetryServiceProvider: poetryServiceProvider, settings: settings)
    }
}

extension SelectionRootViewModel {
    static func makePreview(mode: PoetryServiceProvider.TestMode = .offlineOnly) -> SelectionRootViewModel {
        .init(
            poetryServiceProvider: .testPreview(mode: mode),
            settings: .makeUnbacked()
        )
    }
}
