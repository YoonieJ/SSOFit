//
//  AuthValidator.swift
//  SSOFit
//

import Foundation

// Checks form input before Firebase is called. Each method returns a message, or nil when the input is fine.
enum AuthValidator {
    static let minPasswordLength = 8

    static func checkEmail(_ email: String) -> String? {
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            return "Enter your email."
        }
        if trimmed.range(of: "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$", options: .regularExpression) == nil {
            return "That email address doesn't look right."
        }
        return nil
    }

    static func checkLogin(email: String, password: String) -> String? {
        if let message = checkEmail(email) {
            return message
        }
        if password.isEmpty {
            return "Enter your password."
        }
        return nil
    }

    static func checkRegistration(email: String, password: String, confirm: String) -> String? {
        if let message = checkEmail(email) {
            return message
        }
        if password.isEmpty {
            return "Enter a password."
        }
        if password.count < minPasswordLength {
            return "Use at least \(minPasswordLength) characters for your password."
        }
        if confirm.isEmpty {
            return "Confirm your password."
        }
        if password != confirm {
            return "The passwords don't match."
        }
        return nil
    }
}
