//
//  TrendsView.swift
//  SSOFit
//

import SwiftUI

struct TrendsView: View {
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            Text("Trends")
                .font(.appTitle)
                .foregroundStyle(Theme.ink)
        }
    }
}

#Preview {
    TrendsView()
}
