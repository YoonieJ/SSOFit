//
//  MeView.swift
//  SSOFit
//

import SwiftUI

struct MeView: View {
    @Environment(AuthService.self) private var auth
    @Environment(ProfileService.self) private var profileService

    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 16) {
                    Text(profileService.profile?.displayName ?? "Me")
                        .font(.appTitle)
                        .foregroundStyle(Theme.ink)
                    NavigationLink {
                        EditProfileView()
                    } label: {
                        Text("Edit profile")
                            .font(.appBodyBold)
                            .foregroundStyle(Theme.onAccent)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.blush, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    }
                    // Temporary, for testing the auth loop.
                    SecondaryButton(title: "Sign out") {
                        do {
                            try auth.signOut()
                        } catch {
                            errorMessage = AuthErrorMessage.text(for: error)
                        }
                    }
                    if let errorMessage {
                        Text(errorMessage)
                            .font(.appCaption)
                            .foregroundStyle(Theme.rose)
                    }
                }
                .padding(Theme.padding)
            }
        }
        .tint(Theme.rose)
    }
}

#Preview {
    MeView()
        .environment(AuthService())
        .environment(ProfileService())
}
