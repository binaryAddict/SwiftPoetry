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
    
    func groupedArea() -> some View {
        background {
            Color.white
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 10)
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

extension Text {
    func primaryButtonLabelStyle() -> some View {
        font(.title)
        .bold()
        .padding(8)
    }
}

extension View {
    func primaryButtonContainerStyle() -> some View {
        buttonBorderShape(.capsule)
        .buttonStyle(.borderedProminent)
        .shadow(radius: 10)
    }
}
