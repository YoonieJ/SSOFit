//
//  RootView.swift
//  SSOFit
//

import SwiftUI

// Switches between the auth flow, profile setup and the tab shell.
struct RootView: View {
    @Environment(AuthService.self) private var auth
    @Environment(ProfileService.self) private var profileService

    var body: some View {
        Group {
            if !auth.isReady {
                loading
            } else if !auth.isSignedIn {
                WelcomeView()
            } else if profileService.profile != nil {
                MainTabView()
            } else if let message = profileService.loadError {
                loadFailed(message)
            } else if profileService.hasLoaded {
                ProfileSetupView()
            } else {
                loading
            }
        }
        .task {
            auth.start()
        }
        .task(id: auth.uid) {
            if let uid = auth.uid {
                await profileService.load(uid: uid)
            } else {
                profileService.reset()
            }
        }
    }

    private var loading: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ProgressView()
        }
    }

    private func loadFailed(_ message: String) -> some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 14) {
                Text(message)
                    .font(.appBody)
                    .foregroundStyle(Theme.ink)
                    .multilineTextAlignment(.center)
                PrimaryButton(title: "Try again") {
                    guard let uid = auth.uid else {
                        return
                    }
                    Task {
                        await profileService.load(uid: uid)
                    }
                }
                Button("Sign out") {
                    try? auth.signOut()
                }
                .font(.appBodyMedium)
                .foregroundStyle(Theme.inkSoft)
            }
            .padding(Theme.padding)
        }
    }
}

#Preview {
    RootView()
        .environment(AuthService())
        .environment(ProfileService())
}
