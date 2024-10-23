//
//  SelectionRootView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 22/10/2024.
//

import SwiftUI

struct SelectionRootView: View {
    @Bindable var viewModel: SelectionRootViewModel
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

#Preview {
    SelectionRootView(viewModel: SelectionRootViewModel())
}
