//
//  HomeView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 22/10/2024.
//

import SwiftUI

@MainActor
@Observable
class HomeViewModel {
    
    @ObservationIgnored 
    @AppStorage(AppStorageKey.offlineOnly.rawValue) var offlineOnly = AppStorageDefaultValue.offlineOnly
    {
        didSet {
            print("Hello")
            fetchRandomPoem()
        }
    }
    private let poetryServiceProvider: PoetryServiceProvider
    private(set) var poem: Poem?
    var fetching = false
    var disabled : Bool {
        fetching || poem == nil
    }
    
    init(poetryService: PoetryServiceProvider = .shared) {
        self.poetryServiceProvider = poetryService
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
                self.poem = poem
            case .failure:
                break
            }
        }
    }
    
    func randomPoemNavigation() -> some Hashable {
        RandomPoemNavigation(poetryServiceProvider: poetryServiceProvider)
//        SpeedReederNavigation(poem: nil, poetryServiceProvider: poetryServiceProvider)
    }
    
    func authorsNavigationValue() -> some Hashable {
        AuthorsNavigation(poetryServiceProvider: poetryServiceProvider)
    }
}

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel
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
            .fetchingOverlay(isFetching: $viewModel.fetching)
        }
        .onAppear(perform: viewModel.onAppear)
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
    HomeView(viewModel: HomeViewModel())
}
