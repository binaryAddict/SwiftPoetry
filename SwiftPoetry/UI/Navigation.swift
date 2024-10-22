//
//  Navigation.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

struct AuthorNavigation: Hashable {
    let author: String
    @HashableIgnored var poetryService: any PoetryServer
}

extension View {
    @MainActor func navigationDestinations() -> some View {
        navigationDestination(for: AuthorNavigation.self) {
            AuthorView(viewModel: .init(author: $0.author, poetryService: $0.poetryService))
        }
        .navigationDestination(for: Poem.self) {
//            PoemView(poem: $0)
            SpeedReadingView(viewModel: .init(poem: $0))
        }
    }
}
