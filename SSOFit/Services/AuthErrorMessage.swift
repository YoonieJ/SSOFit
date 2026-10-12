//
//  AuthErrorMessage.swift
//  SSOFit
//

import Foundation
import FirebaseAuth

// Turns Firebase errors into plain sentences.
enum AuthErrorMessage {
    static func text(for error: Error) -> String {
        let nsError = error as NSError
        guard nsError.domain == AuthErrorDomain, let code = AuthErrorCode(rawValue: nsError.code) else {
            return "Something went wrong. Please try again."
        }
        switch code {
        case .emailAlreadyInUse:
            return "An account with that email already exists. Try logging in."
        case .wrongPassword:
            return "That password is incorrect."
        case .userNotFound:
            return "No account was found with that email."
        case .invalidCredential:
            // Newer Firebase projects hide whether the email or the password was wrong.
            return "The email or password is incorrect."
        case .weakPassword:
            return "That password is too weak. Try a longer one."
        case .invalidEmail:
            return "That email address doesn't look right."
        case .networkError:
            return "No internet connection. Check your network and try again."
        case .tooManyRequests:
            return "Too many attempts. Please wait a moment and try again."
        case .userDisabled:
            return "This account has been disabled."
        default:
            return "Something went wrong. Please try again."
        }
    }
}
