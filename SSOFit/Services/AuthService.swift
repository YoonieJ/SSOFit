//
//  AuthService.swift
//  SSOFit
//

import Foundation
import FirebaseCore
import FirebaseAuth

// Wraps FirebaseAuth. Views read isSignedIn, which the auth state listener keeps current.
@Observable
final class AuthService {
    private(set) var isSignedIn = false
    private(set) var uid: String?
    // False until the listener reports once, so the app does not flash Welcome for a signed-in user.
    private(set) var isReady = false

    private var listener: AuthStateDidChangeListenerHandle?

    // Call once after Firebase is configured.
    func start() {
        guard listener == nil, FirebaseApp.app() != nil else {
            isReady = true
            return
        }
        listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isSignedIn = user != nil
            self?.uid = user?.uid
            self?.isReady = true
        }
    }

    deinit {
        if let listener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }

    func register(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }

    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func signOut() throws {
        try Auth.auth().signOut()
        ReminderService.removeAll()
    }

    // Deleting an account needs a recent sign-in, so the password is checked again first.
    func reauthenticate(password: String) async throws {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            throw NSError(domain: AuthErrorDomain, code: AuthErrorCode.userNotFound.rawValue)
        }
        try await user.reauthenticate(with: EmailAuthProvider.credential(withEmail: email, password: password))
    }

    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: AuthErrorDomain, code: AuthErrorCode.userNotFound.rawValue)
        }
        try await user.delete()
    }

    func sendPasswordReset(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}
