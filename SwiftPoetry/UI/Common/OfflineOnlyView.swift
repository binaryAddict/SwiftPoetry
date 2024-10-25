//
//  OfflineOnlyView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

struct OfflineOnlyView: View {
    @Bindable var settings: Settings
    var body: some View {
        HStack(spacing: 16) {
            Text("Offline only")
            Toggle("Offline only", isOn: $settings.offlineOnly)
                .labelsHidden()
        }
    }
}

#Preview {
    DefaultPreviewParent {
        OfflineOnlyView(settings: .makeUnbacked())
    }
}
