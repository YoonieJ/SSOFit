//
//  ExploreView.swift
//  SSOFit
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            Text("Explore")
                .font(.appTitle)
                .foregroundStyle(Theme.ink)
        }
    }
}

#Preview {
    ExploreView()
}
