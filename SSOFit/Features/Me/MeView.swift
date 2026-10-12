//
//  MeView.swift
//  SSOFit
//

import SwiftUI

struct MeView: View {
    @Environment(AuthService.self) private var auth

    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Me")
                    .font(.appTitle)
                    .foregroundStyle(Theme.ink)
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
}

#Preview {
    MeView()
        .environment(AuthService())
}
