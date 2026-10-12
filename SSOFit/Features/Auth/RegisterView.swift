//
//  RegisterView.swift
//  SSOFit
//

import SwiftUI

struct RegisterView: View {
    @Environment(AuthService.self) private var auth

    @State private var email = ""
    @State private var password = ""
    @State private var confirm = ""
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Create account")
                        .font(.appTitle)
                        .foregroundStyle(Theme.ink)
                    Text("Sign up with your email and a password.")
                        .font(.appBody)
                        .foregroundStyle(Theme.inkSoft)
                    AppTextField(placeholder: "Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    AppTextField(placeholder: "Password", text: $password, isSecure: true)
                        .textContentType(.newPassword)
                    AppTextField(placeholder: "Confirm password", text: $confirm, isSecure: true)
                        .textContentType(.newPassword)
                    if let errorMessage {
                        Text(errorMessage)
                            .font(.appCaption)
                            .foregroundStyle(Theme.rose)
                    }
                    PrimaryButton(title: isLoading ? "Creating account..." : "Create account") {
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
        if let message = AuthValidator.checkRegistration(email: email, password: password, confirm: confirm) {
            errorMessage = message
            return
        }
        errorMessage = nil
        isLoading = true
        Task {
            do {
                try await auth.register(email: email.trimmingCharacters(in: .whitespaces), password: password)
            } catch {
                errorMessage = AuthErrorMessage.text(for: error)
            }
            isLoading = false
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
    .environment(AuthService())
}
