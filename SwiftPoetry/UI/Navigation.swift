//
//  Navigation.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

struct RandomPoemNavigation: Hashable {}

struct AuthorsNavigation: Hashable {}

struct AuthorPoemsNavigation: Hashable {
    let author: String
}

struct PoemNavigation: Hashable {
    let poem: Poem
}

struct SpeedReadingNavigation: Hashable {
    let poem: Poem
}

/** 
 I could used Enviroment or EnviromentObject for dependacies,
 but would need a wrapper view for each destination or have to deal with more optionals.
 Of the two I would pick the wrapper views, but would wait till it is worth the extra work
 */
extension View {
    @MainActor func navigationDestinations(dependacySource: DependacySource) -> some View {
        navigationDestination(for: RandomPoemNavigation.self) { _ in
            RandomPoemView(viewModel: .make(dependacySource: dependacySource))
        }
        .navigationDestination(for: AuthorsNavigation.self) { _ in
            AuthorsView(viewModel: .make(dependacySource: dependacySource))
        }
        .navigationDestination(for: AuthorPoemsNavigation.self) {
            AuthorPoemsView(viewModel: .make(author: $0.author, dependacySource: dependacySource))
        }
        .navigationDestination(for: PoemNavigation.self) {
            PoemView(viewModel: .make(poem: $0.poem, dependacySource: dependacySource))
        }
        .navigationDestination(for: SpeedReadingNavigation.self) {
            SpeedReadingView(viewModel: .make(poem: $0.poem, dependacySource: dependacySource))
        }
    }
}
