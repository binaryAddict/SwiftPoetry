//
//  Navigation.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

struct RandomPoemNavigation: Hashable {
    @HashableIgnored var poetryServiceProvider: PoetryServiceProvider
    @HashableIgnored var settings: Settings
}

struct AuthorsNavigation: Hashable {
    @HashableIgnored var poetryServiceProvider: PoetryServiceProvider
    @HashableIgnored var settings: Settings
}

struct AuthorPoemsNavigation: Hashable {
    let author: String
    @HashableIgnored var poetryServiceProvider: PoetryServiceProvider
    @HashableIgnored var settings: Settings
}

struct PoemNavigation: Hashable {
    let poem: Poem
    @HashableIgnored var settings: Settings
}

struct SpeedReadingNavigation: Hashable {
    let poem: Poem
    @HashableIgnored var settings: Settings
}

extension View {
    @MainActor func navigationDestinations() -> some View {
        navigationDestination(for: AuthorPoemsNavigation.self) {
            AuthorPoemsView(
                viewModel: .init(
                    author: $0.author,
                    poetryServiceProvider: $0.poetryServiceProvider,
                    settings: $0.settings
                )
            )
        }
        .navigationDestination(for: AuthorsNavigation.self) {
            AuthorsView(
                viewModel: .init(
                    poetryServiceProvider: $0.poetryServiceProvider,
                    settings: $0.settings
                )
            )
        }
        .navigationDestination(for: RandomPoemNavigation.self) {
            RandomPoemView(
                viewModel: .init(
                    poetryServiceProvider: $0.poetryServiceProvider,
                    settings: $0.settings
                )
            )
        }
        .navigationDestination(for: PoemNavigation.self) {
            PoemView(
                viewModel: .init(
                    poem: $0.poem,
                    settings: $0.settings
                )
            )
        }
        .navigationDestination(for: SpeedReadingNavigation.self) {
            SpeedReadingView(
                viewModel: .init(
                    poem: $0.poem,
                    settings: $0.settings
                )
            )
        }
    }
}
