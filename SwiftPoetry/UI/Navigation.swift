//
//  Navigation.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

struct AuthorNavigation: Hashable {
    let author: String
    @HashableIgnored var poetryServiceProvider: PoetryServiceProvider
}

extension View {
    @MainActor func navigationDestinations() -> some View {
        navigationDestination(for: AuthorNavigation.self) {
            AuthorView(viewModel: .init(author: $0.author, poetryServiceProvider: $0.poetryServiceProvider))
        }
        .navigationDestination(for: Poem.self) {
//            PoemView(poem: $0)
            SpeedReadingView(viewModel: .init(poem: $0))
        }
    }
}
