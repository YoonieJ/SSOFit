//
//  Timeout.swift
//  SSOFit
//

import Foundation
import os

// Firestore writes wait for the server and never fail while offline, so this gives up after a few seconds.
// The write may still go through later, when the connection comes back.
enum Timeout {
    static func run<T: Sendable>(seconds: Double = 10, _ operation: @escaping @Sendable () async throws -> T) async throws -> T {
        let finished = OSAllocatedUnfairLock(initialState: false)
        // Whichever of the operation and the timer finishes first claims the continuation.
        let claim: @Sendable () -> Bool = {
            finished.withLock { done in
                if done {
                    return false
                }
                done = true
                return true
            }
        }
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let value = try await operation()
                    if claim() {
                        continuation.resume(returning: value)
                    }
                } catch {
                    if claim() {
                        continuation.resume(throwing: error)
                    }
                }
            }
            Task {
                try? await Task.sleep(for: .seconds(seconds))
                if claim() {
                    continuation.resume(throwing: URLError(.timedOut))
                }
            }
        }
    }
}
