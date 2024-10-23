//
//  AuthorViewModel.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

@MainActor
@Observable
class AuthorPoemsViewModel {
    
    var fetching = false
    let author: String
    var filter = ""
    var filteredPoems: [Poem] {
        filter.isEmpty ? peoms : peoms.filter { $0.title.localizedCaseInsensitiveContains(filter) }
    }
    var presentError = false
    private(set) var peoms: [Poem] = []
    private let poetryServiceProvider: PoetryServiceProvider
    
    init(author: String, poetryServiceProvider: PoetryServiceProvider = .shared) {
        self.author = author
        self.poetryServiceProvider = poetryServiceProvider
    }
    
    func onAppear() {
        fetching = true
        DispatchQueue.main.asyncAwait {
            try await self.poetryServiceProvider.service().poems(author: self.author)
        } completion: { [weak self] val in
            guard let self else { return }
            self.fetching = false
            switch val {
            case .success(let val):
                self.peoms = val
            case .failure:
                self.presentError = true
            }
        }
    }
    
    func navigationValue(poem: Poem) -> some Hashable {
        SpeedReederNavigation(poem: poem, poetryServiceProvider: poetryServiceProvider)
    }
}

extension AuthorPoemsViewModel {
    static func makePreview(mode: PoetryServiceProvider.TestMode = .offlineOnly) -> AuthorPoemsViewModel {
        .init(author: PoetryStubs.authorJonathanSwift, poetryServiceProvider: .testPreview(mode: mode))
    }
}
