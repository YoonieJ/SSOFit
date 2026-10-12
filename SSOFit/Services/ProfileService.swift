//
//  ProfileService.swift
//  SSOFit
//

import UIKit
import FirebaseFirestore

// Loads, saves and deletes the signed-in user's profile: text in Firestore, photo on the device, reminders on the device.
@Observable
final class ProfileService {
    var profile: UserProfile?
    // True once a load has finished, so a missing profile can be told apart from one still loading.
    private(set) var hasLoaded = false
    private(set) var loadError: String?

    private func document(uid: String) -> DocumentReference {
        return Firestore.firestore().collection("users").document(uid)
    }

    func load(uid: String) async {
        profile = nil
        hasLoaded = false
        loadError = nil
        do {
            let snapshot = try await document(uid: uid).getDocument()
            if Task.isCancelled {
                return
            }
            if let data = snapshot.data() {
                guard let loaded = UserProfile(data: data) else {
                    loadError = "Your profile couldn't be read. Please try again."
                    return
                }
                profile = loaded
                // Signing in on a device schedules its reminders again.
                if loaded.reminderEnabled {
                    try? await ReminderService.schedule(weekdays: loaded.reminderWeekdays, time: loaded.reminderTime)
                }
            }
            hasLoaded = true
        } catch {
            if !Task.isCancelled {
                loadError = ProfileErrorMessage.text(for: error)
            }
        }
    }

    func reset() {
        profile = nil
        hasLoaded = false
        loadError = nil
    }

    // Writes the profile and applies the photo and reminders. Returns the saved profile, whose reminderEnabled is
    // false when the user denied notifications. The caller decides when to publish it as the current profile.
    func save(uid: String, name: String, weekdays: Set<Int>, time: Date, photo: UIImage?) async throws -> UserProfile {
        // Permission is asked here, as the user finishes choosing days.
        let allowed = await ReminderService.requestPermission()
        let now = Date()
        let saved = UserProfile(displayName: name.trimmingCharacters(in: .whitespacesAndNewlines),
                                reminderEnabled: allowed,
                                reminderWeekdays: weekdays,
                                reminderTime: time,
                                createdAt: profile?.createdAt ?? now,
                                updatedAt: now)
        let reference = document(uid: uid)
        let data = saved.data
        try await Timeout.run {
            try await reference.setData(data)
        }
        if let photo {
            try PhotoStore.save(photo, uid: uid)
        } else {
            PhotoStore.delete(uid: uid)
        }
        if allowed {
            try await ReminderService.schedule(weekdays: weekdays, time: time)
        } else {
            ReminderService.removeAll()
        }
        return saved
    }

    // Re-authenticates first, then removes the Firestore document, the local photo and the reminders, then the Auth user.
    func deleteAccount(uid: String, password: String, auth: AuthService) async throws {
        try await auth.reauthenticate(password: password)
        let reference = document(uid: uid)
        try await Timeout.run {
            try await reference.delete()
        }
        PhotoStore.delete(uid: uid)
        ReminderService.removeAll()
        try await auth.deleteUser()
        profile = nil
    }
}
