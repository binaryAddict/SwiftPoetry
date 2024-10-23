//
//  View+Extensions.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

extension View {
    func fetchingOverlay(isFetching: Binding<Bool>) -> some View {
        disabled(isFetching.wrappedValue)
            .overlay {
                if isFetching.wrappedValue {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background {
                            Color.white.opacity(0.7)
                        }
                }
            }
    }
}
