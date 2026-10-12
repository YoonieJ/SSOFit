//
//  ForgotPasswordView.swift
//  SSOFit
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(AuthService.self) private var auth

    @State private var email = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Reset password")
                        .font(.appTitle)
                        .foregroundStyle(Theme.ink)
                    Text("Enter your email and we'll send you a link to reset your password.")
                        .font(.appBody)
                        .foregroundStyle(Theme.inkSoft)
                    AppTextField(placeholder: "Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    if let errorMessage {
                        Text(errorMessage)
                            .font(.appCaption)
                            .foregroundStyle(Theme.rose)
                    }
                    if let successMessage {
                        Text(successMessage)
                            .font(.appCaption)
                            .foregroundStyle(Theme.ink)
                    }
                    PrimaryButton(title: isLoading ? "Sending..." : "Send reset link") {
                        submit()
                    }
                    .disabled(isLoading)
                }
                .padding(Theme.padding)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func submit() {
        errorMessage = nil
        successMessage = nil
        if let message = AuthValidator.checkEmail(email) {
            errorMessage = message
            return
        }
        isLoading = true
        Task {
            do {
                try await auth.sendPasswordReset(email: email.trimmingCharacters(in: .whitespaces))
                successMessage = "If an account exists for that email, a reset link is on its way."
            } catch {
                errorMessage = AuthErrorMessage.text(for: error)
            }
            isLoading = false
        }
    }
}

#Preview {
    NavigationStack {
        ForgotPasswordView()
    }
    .environment(AuthService())
}
