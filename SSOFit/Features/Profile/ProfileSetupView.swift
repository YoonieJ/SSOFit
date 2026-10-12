//
//  ProfileSetupView.swift
//  SSOFit
//

import SwiftUI

// Shown after register, and to any signed-in user who has no profile yet.
struct ProfileSetupView: View {
    @Environment(AuthService.self) private var auth
    @Environment(ProfileService.self) private var profileService

    @State private var name = ""
    @State private var photo: UIImage?
    @State private var weekdays: Set<Int> = []
    @State private var time = ProfileSetupView.defaultTime()
    @State private var errorMessage: String?
    @State private var isSaving = false
    @State private var savedProfile: UserProfile?
    @State private var showNotificationDenied = false

    private static func defaultTime() -> Date {
        return Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date()
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Set up your profile")
                        .font(.appTitle)
                        .foregroundStyle(Theme.ink)
                    Text("Add a name and pick when you'd like a workout reminder.")
                        .font(.appBody)
                        .foregroundStyle(Theme.inkSoft)
                    ProfileForm(name: $name, photo: $photo, weekdays: $weekdays, time: $time)
                    if let errorMessage {
                        Text(errorMessage)
                            .font(.appCaption)
                            .foregroundStyle(Theme.rose)
                    }
                    PrimaryButton(title: isSaving ? "Saving..." : "Save") {
                        save()
                    }
                    .disabled(isSaving)
                    Button("Sign out") {
                        signOut()
                    }
                    .font(.appBodyMedium)
                    .foregroundStyle(Theme.inkSoft)
                    .frame(maxWidth: .infinity)
                }
                .padding(Theme.padding)
            }
        }
        .alert("Reminders are off", isPresented: $showNotificationDenied) {
            Button("Open Settings") {
                finish()
                SystemSettings.open()
            }
            Button("Not now", role: .cancel) {
                finish()
            }
        } message: {
            Text("Your profile is saved, but notifications are turned off for SSOFit. Turn them on in Settings to get reminders.")
        }
    }

    private func save() {
        if let message = ProfileValidator.check(name: name, weekdays: weekdays) {
            errorMessage = message
            return
        }
        guard let uid = auth.uid else {
            errorMessage = "You're signed out. Please log in again."
            return
        }
        errorMessage = nil
        isSaving = true
        Task {
            do {
                let saved = try await profileService.save(uid: uid, name: name, weekdays: weekdays, time: time, photo: photo)
                savedProfile = saved
                if saved.reminderEnabled {
                    finish()
                } else {
                    showNotificationDenied = true
                }
            } catch {
                errorMessage = ProfileErrorMessage.text(for: error)
            }
            isSaving = false
        }
    }

    // Publishing the profile switches the app to the tabs, so this waits until any alert is dismissed.
    private func finish() {
        profileService.profile = savedProfile
    }

    private func signOut() {
        do {
            try auth.signOut()
        } catch {
            errorMessage = AuthErrorMessage.text(for: error)
        }
    }
}

#Preview {
    ProfileSetupView()
        .environment(AuthService())
        .environment(ProfileService())
}
