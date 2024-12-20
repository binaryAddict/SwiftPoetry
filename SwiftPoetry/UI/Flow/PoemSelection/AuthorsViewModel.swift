//
//  AuthorsViewModel.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

@MainActor
@Observable
final class AuthorsViewModel: Chainable {
    
    var filter = ""
    var filteredAuthors: [String] {
        assert(authors.count < 1000, "Time to consider throttling and/or persisting filter results")
        return filter.isEmpty ? authors : authors.filter { $0.localizedCaseInsensitiveContains(filter) }
    }
    var fetching = false
    var presentNetworkedError = false
    var presentOfflineError = false
    private(set) var authors: [String] = []
    private let poetryServiceProvider: PoetryServiceProvider
    var settings: Settings
    private var token: Any?
    
    init(poetryServiceProvider: PoetryServiceProvider, settings: Settings) {
        self.poetryServiceProvider = poetryServiceProvider
        self.settings = settings
        token = withObservationTracking {
            settings.offlineOnly
        } onChange: {
            DispatchQueue.main.async { [weak self] in
                self?.fetchAuthors()
            }
        }
    }
    
    func onAppear() {
        fetchAuthors()
    }
    
    func fetchAuthors() {
        let offlineOnly = settings.offlineOnly
        fetching = true
        authors.removeAll()
        DispatchQueue.main.throwingAsyncAwait {
            try await self.poetryServiceProvider.service(offlineOnly: offlineOnly).authors()
        } completion: { [weak self] val in
            guard let self else { return }
            self.fetching = false
            switch val {
            case .success(let val):
                self.authors = val
            case .failure:
                self.presentNetworkedError = offlineOnly == false
                self.presentOfflineError = offlineOnly
            }
        }
    }
    
    func navigationValue(author: String) -> some Hashable {
        AuthorPoemsNavigation(author: author)
    }
}

extension AuthorsViewModel {
    static func make(dependacySource: DependacySource) -> AuthorsViewModel {
        .init(
            poetryServiceProvider: dependacySource.poetryServiceProvider,
            settings: dependacySource.settings
        )
    }
}
