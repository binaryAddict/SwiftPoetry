//
//  AuthorsViewModel.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

@MainActor
@Observable
final class AuthorsViewModel {
    
    var filter = ""
    var filteredAuthors: [String] {
        filter.isEmpty ? authors : authors.filter { $0.localizedCaseInsensitiveContains(filter) }
    }
    var fetching = false
    var presentError = false
    private(set) var authors: [String] = []
    private let poetryServiceProvider: PoetryServiceProvider
    @ObservationIgnored @AppStorage(AppStorageKey.offlineOnly.rawValue) var offlineOnly = AppStorageDefaultValue.offlineOnly {
        didSet {
            fetchAuthors()
        }
    }
    
    init(poetryServiceProvider: PoetryServiceProvider = .shared) {
        self.poetryServiceProvider = poetryServiceProvider
    }
    
    func onAppear() {
        fetchAuthors()
    }
    
    func fetchAuthors() {
        let offlineOnly = self.offlineOnly
        fetching = true
        authors.removeAll()
        DispatchQueue.main.asyncAwait {
            try await self.poetryServiceProvider.service(offlineOnly: offlineOnly).authors()
        } completion: { [weak self] val in
            guard let self else { return }
            self.fetching = false
            switch val {
            case .success(let val):
                self.authors = val
            case .failure:
                self.presentError = true
            }
        }
    }
    
    func navigationValue(author: String) -> some Hashable {
        AuthorPoemsNavigation(author: author, poetryServiceProvider: poetryServiceProvider)
    }
}

extension AuthorsViewModel {
    static func makePreview(mode: PoetryServiceProvider.TestMode = .offlineOnly) -> AuthorsViewModel {
        .init(poetryServiceProvider: .testPreview(mode: mode))
    }
}
