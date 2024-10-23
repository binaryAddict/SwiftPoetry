//
//  AuthorsViewModel.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

@MainActor
@Observable
class AuthorsViewModel {
    
    var filter = ""
    var filteredAuthors: [String] {
        filter.isEmpty ? authors : authors.filter { $0.localizedCaseInsensitiveContains(filter) }
    }
    private(set) var fetching = false
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
        DispatchQueue.main.asyncAwait {
            try await self.poetryServiceProvider.service(offlineOnly: offlineOnly).authors()
        } completion: { [weak self] val in
            guard let self else { return }
            self.fetching = false
            switch val {
            case .success(let val):
                self.authors = val
            case .failure:
                break
            }
        }
    }
    
    func navigationValue(author: String) -> some Hashable {
        AuthorNavigation(author: author, poetryServiceProvider: poetryServiceProvider)
    }
}
