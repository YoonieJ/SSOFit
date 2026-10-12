//
//  TodayView.swift
//  SSOFit
//

import SwiftUI

struct TodayView: View {
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            Text("Today")
                .font(.appTitle)
                .foregroundStyle(Theme.ink)
        }
    }
}

#Preview {
    TodayView()
}
