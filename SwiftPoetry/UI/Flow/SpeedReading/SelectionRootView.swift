//
//  SelectionRootView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 22/10/2024.
//

import SwiftUI

@MainActor
@Observable
class SelectionRootModel {
    
    @ObservationIgnored 
    @AppStorage(AppStorageKey.offlineOnly.rawValue) var offlineOnly = AppStorageDefaultValue.offlineOnly
    private let poetryServiceProvider: PoetryServiceProvider
    
    init(poetryServiceProvider: PoetryServiceProvider = .shared) {
        self.poetryServiceProvider = poetryServiceProvider
    }
    
    func randomPoemNavigation() -> some Hashable {
        RandomPoemNavigation(poetryServiceProvider: poetryServiceProvider)
    }
    
    func authorsNavigationValue() -> some Hashable {
        AuthorsNavigation(poetryServiceProvider: poetryServiceProvider)
    }
}

struct SelectionRootView: View {
    @Bindable var viewModel: SelectionRootModel
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 32) {
                Spacer()
                NavigationLink(value: viewModel.randomPoemNavigation()) {
                    Text("Suprise Me!!")
                        .font(.largeTitle)
                }
                NavigationLink(value: viewModel.authorsNavigationValue()) {
                    Text("Let me choose")
                }
                Spacer()
                OfflineOnlyView(offlineOnly: $viewModel.offlineOnly)
            }
        }
        .navigationTitle("Pick a Poem")
    }
}

struct OfflineOnlyView: View {
    @Binding var offlineOnly: Bool
    var body: some View {
        HStack(spacing: 16) {
            Text("Offline only")
            Toggle("Offline only", isOn: $offlineOnly)
                .labelsHidden()
            Spacer()
        }
        .padding(16)
    }
}

#Preview {
    SelectionRootView(viewModel: SelectionRootModel())
}
