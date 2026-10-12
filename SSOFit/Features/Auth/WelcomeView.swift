//
//  WelcomeView.swift
//  SSOFit
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 12) {
                    Spacer()
                    Text("SSOFit")
                        .font(.appLargeTitle)
                        .foregroundStyle(Theme.ink)
                    Text("Track your workouts, your way.")
                        .font(.appBody)
                        .foregroundStyle(Theme.inkSoft)
                        .multilineTextAlignment(.center)
                    Spacer()
                    NavigationLink {
                        RegisterView()
                    } label: {
                        Text("Create account")
                            .font(.appBodyBold)
                            .foregroundStyle(Theme.onAccent)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.blush, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    }
                    NavigationLink {
                        LoginView()
                    } label: {
                        Text("Log in")
                            .font(.appBodyBold)
                            .foregroundStyle(Theme.ink)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.surface, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
                            .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.blush, lineWidth: 1.5))
                    }
                }
                .padding(Theme.padding)
            }
        }
        .tint(Theme.rose)
    }
}

#Preview {
    WelcomeView()
}
