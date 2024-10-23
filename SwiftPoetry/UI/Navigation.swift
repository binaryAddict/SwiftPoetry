//
//  Navigation.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

struct SelectionRootNavigation: Hashable {
    @HashableIgnored var poetryServiceProvider: PoetryServiceProvider
}

struct AuthorPoemsNavigation: Hashable {
    let author: String
    @HashableIgnored var poetryServiceProvider: PoetryServiceProvider
}

struct AuthorsNavigation: Hashable {
    @HashableIgnored var poetryServiceProvider: PoetryServiceProvider
}

struct RandomPoemNavigation: Hashable {
    @HashableIgnored var poetryServiceProvider: PoetryServiceProvider
}

struct SpeedReederNavigation: Hashable {
    let poem: Poem
    @HashableIgnored var poetryServiceProvider: PoetryServiceProvider
}

extension View {
    @MainActor func navigationDestinations() -> some View {
        navigationDestination(for: SelectionRootNavigation.self) {
            SelectionRootView(viewModel: .init(poetryServiceProvider: $0.poetryServiceProvider))
        }
        .navigationDestination(for: AuthorPoemsNavigation.self) {
            AuthorPoemsView(viewModel: .init(author: $0.author, poetryServiceProvider: $0.poetryServiceProvider))
        }
        .navigationDestination(for: AuthorsNavigation.self) {
            AuthorsView(viewModel: .init(poetryServiceProvider: $0.poetryServiceProvider))
        }
        .navigationDestination(for: RandomPoemNavigation.self) {
            RandomPoemView(viewModel: .init(poetryServiceProvider: $0.poetryServiceProvider))
        }
        .navigationDestination(for: SpeedReederNavigation.self) {
            SpeedReadingView(viewModel: .init(poem: $0.poem))
        }
    }
}
