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
        assert(poems.count < 1000, "Time to consider throttling and/or persisting filter results")
        return filter.isEmpty ? poems : poems.filter { $0.title.localizedCaseInsensitiveContains(filter) }
    }
    var presentError = false
    private(set) var poems: [Poem] = []
    private let poetryServiceProvider: PoetryServiceProvider
    private let settings: Settings
    
    init(author: String, poetryServiceProvider: PoetryServiceProvider, settings: Settings) {
        self.author = author
        self.poetryServiceProvider = poetryServiceProvider
        self.settings = settings
    }
    
    func onAppear() {
        fetchPoems()
    }
    
    func fetchPoems() {
        fetching = true
        // Not really needed since if they exist offline it will already be used
        // So a failure here is a failure of both services
        let offlineOnly = settings.offlineOnly
        DispatchQueue.main.throwingAsyncAwait {
            try await self.poetryServiceProvider.service(offlineOnly: offlineOnly).poems(author: self.author)
        } completion: { [weak self] val in
            guard let self else { return }
            self.fetching = false
            switch val {
            case .success(let val):
                self.poems = val
            case .failure:
                self.presentError = true
            }
        }
    }
    
    func navigationValue(poem: Poem) -> some Hashable {
        PoemNavigation(poem: poem)
    }
}

extension AuthorPoemsViewModel {
    static func make(author: String, dependacySource: DependacySource) -> AuthorPoemsViewModel {
        .init(
            author: author,
            poetryServiceProvider: dependacySource.poetryServiceProvider,
            settings: dependacySource.settings
        )
    }
}
