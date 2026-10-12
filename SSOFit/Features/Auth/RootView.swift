//
//  RootView.swift
//  SSOFit
//

import SwiftUI

// Switches between the auth flow and the tab shell on the auth state.
struct RootView: View {
    @Environment(AuthService.self) private var auth

    var body: some View {
        Group {
            if !auth.isReady {
                ZStack {
                    Theme.background.ignoresSafeArea()
                    ProgressView()
                }
            } else if auth.isSignedIn {
                MainTabView()
            } else {
                WelcomeView()
            }
        }
        .task {
            auth.start()
        }
    }
}

#Preview {
    RootView()
        .environment(AuthService())
}
