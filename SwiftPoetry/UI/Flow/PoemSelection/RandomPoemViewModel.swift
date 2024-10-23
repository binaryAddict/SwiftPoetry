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
    @ObservationIgnored
    @AppStorage(AppStorageKey.offlineOnly.rawValue) var offlineOnly = AppStorageDefaultValue.offlineOnly
    
    var speedReading: SpeedReadingViewModel?
    private let poetryServiceProvider: PoetryServiceProvider
    var fetching = false
    
    init(poetryServiceProvider: PoetryServiceProvider) {
        self.poetryServiceProvider = poetryServiceProvider
    }
    
    func onAppear() {
        fetchRandomPoem()
    }
    
    func fetchRandomPoem() {
        let offlineOnly = self.offlineOnly
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
                break
            }
        }
    }
}

extension RandomPoemViewModel {
    static func makePreview() -> RandomPoemViewModel {
        .init(poetryServiceProvider: .offlineOnly)
    }
}
