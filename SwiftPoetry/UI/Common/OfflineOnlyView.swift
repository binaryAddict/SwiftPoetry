//
//  OfflineOnlyView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

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
