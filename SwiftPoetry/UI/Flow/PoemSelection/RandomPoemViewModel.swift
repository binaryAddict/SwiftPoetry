//
//  RandomPoemViewModel.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

@MainActor
@Observable
class RandomPoemViewModel {

    var settings: Settings
    var speedReading: SpeedReadingViewModel?
    private let poetryServiceProvider: PoetryServiceProvider
    var fetching = false
    var presentError = false
    
    init(poetryServiceProvider: PoetryServiceProvider, settings: Settings = .shared) {
        self.poetryServiceProvider = poetryServiceProvider
        self.settings = settings
    }
    
    func onAppear() {
        fetchRandomPoem()
    }
    
    func fetchRandomPoem() {
        let offlineOnly = settings.offlineOnly
        fetching = true
        DispatchQueue.main.asyncAwait {
            try await self.poetryServiceProvider.service(offlineOnly: offlineOnly).randomPoem()
        } completion: { [weak self] result in
            guard let self else { return }
            self.fetching = false
            switch result {
            case .success(let poem):
                self.speedReading = .init(poem: poem)
            case .failure:
                self.presentError = true
            }
        }
    }
}

extension RandomPoemViewModel {
    static func makePreview(mode: PoetryServiceProvider.TestMode = .offlineOnly) -> RandomPoemViewModel {
        .init(
            poetryServiceProvider: .testPreview(mode: mode),
            settings: .makeUnbacked()
        )
    }
}
