//
//  CalendarView.swift
//  SSOFit
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            Text("Calendar")
                .font(.appTitle)
                .foregroundStyle(Theme.ink)
        }
    }
}

#Preview {
    CalendarView()
}
