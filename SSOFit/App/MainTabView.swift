//
//  MainTabView.swift
//  SSOFit
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "sun.max") }
            CalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }
            TrendsView()
                .tabItem { Label("Trends", systemImage: "chart.line.uptrend.xyaxis") }
            ExploreView()
                .tabItem { Label("Explore", systemImage: "magnifyingglass") }
            MeView()
                .tabItem { Label("Me", systemImage: "person") }
        }
        .tint(Theme.blush)
    }
}

#Preview {
    MainTabView()
        .environment(AuthService())
}
