//
//  Navigation.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

extension View {
    @MainActor func navigationDestinations() -> some View {
        navigationDestination(for: SelectionRootViewModel.self) {
            SelectionRootView(viewModel: $0)
        }
        .navigationDestination(for: AuthorPoemsViewModel.self) {
            AuthorPoemsView(viewModel: $0)
        }
        .navigationDestination(for: AuthorsViewModel.self) {
            AuthorsView(viewModel: $0)
        }
        .navigationDestination(for: RandomPoemViewModel.self) {
            RandomPoemView(viewModel: $0)
        }
        .navigationDestination(for: SpeedReadingViewModel.self) {
            SpeedReadingView(viewModel: $0)
        }
    }
}
