//
//  SwiftPoetryApp.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 20/10/2024.
//

import SwiftUI

@main
struct SwiftPoetryApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView(viewModel: .init())
//                AuthorsView(viewModel: .init())
                    .navigationDestinations()
            }
        }
    }
}
