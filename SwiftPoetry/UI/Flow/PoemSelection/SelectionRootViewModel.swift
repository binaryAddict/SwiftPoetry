//
//  SelectionRootViewModel.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

@MainActor
@Observable
final class SelectionRootViewModel {
    
    var settings: Settings
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func randomPoemNavigation() -> some Hashable {
        RandomPoemNavigation()
    }
    
    func authorsNavigationValue() -> some Hashable {
        AuthorsNavigation()
    }
}

extension SelectionRootViewModel {
    static func make(dependacySource: DependacySource) -> SelectionRootViewModel {
        SelectionRootViewModel(
            settings: dependacySource.settings
        )
    }
}
