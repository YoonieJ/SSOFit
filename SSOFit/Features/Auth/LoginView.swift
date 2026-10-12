//
//  LoginView.swift
//  SSOFit
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthService.self) private var auth

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Welcome back")
                        .font(.appTitle)
                        .foregroundStyle(Theme.ink)
                    Text("Log in to pick up where you left off.")
                        .font(.appBody)
                        .foregroundStyle(Theme.inkSoft)
                    AppTextField(placeholder: "Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    AppTextField(placeholder: "Password", text: $password, isSecure: true)
                        .textContentType(.password)
                    if let errorMessage {
                        Text(errorMessage)
                            .font(.appCaption)
                            .foregroundStyle(Theme.rose)
                    }
                    PrimaryButton(title: isLoading ? "Logging in..." : "Log in") {
                        submit()
                    }
                    .disabled(isLoading)
                    NavigationLink("Forgot password?") {
                        ForgotPasswordView()
                    }
                    .font(.appBodyMedium)
                    .foregroundStyle(Theme.rose)
                    .frame(maxWidth: .infinity)
                }
                .padding(Theme.padding)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func submit() {
        if let message = AuthValidator.checkLogin(email: email, password: password) {
            errorMessage = message
            return
        }
        errorMessage = nil
        isLoading = true
        Task {
            do {
                try await auth.signIn(email: email.trimmingCharacters(in: .whitespaces), password: password)
            } catch {
                errorMessage = AuthErrorMessage.text(for: error)
            }
            isLoading = false
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
    .environment(AuthService())
}
