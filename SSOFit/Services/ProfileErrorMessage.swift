//
//  ProfileErrorMessage.swift
//  SSOFit
//

import Foundation
import FirebaseFirestore

// Plain messages for Firestore, network and file errors. Auth errors go to AuthErrorMessage.
enum ProfileErrorMessage {
    private static let networkMessage = "No internet connection. Check your network and try again."

    static func text(for error: Error) -> String {
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            return networkMessage
        }
        if nsError.domain == FirestoreErrorDomain, let code = FirestoreErrorCode.Code(rawValue: nsError.code) {
            switch code {
            case .unavailable, .deadlineExceeded:
                return networkMessage
            case .permissionDenied:
                return "You don't have permission to do that."
            default:
                return "Something went wrong. Please try again."
            }
        }
        return AuthErrorMessage.text(for: error)
    }
}
