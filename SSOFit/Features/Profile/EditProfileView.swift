//
//  EditProfileView.swift
//  SSOFit
//

import SwiftUI

struct EditProfileView: View {
    @Environment(AuthService.self) private var auth
    @Environment(ProfileService.self) private var profileService
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var photo: UIImage?
    @State private var weekdays: Set<Int> = []
    @State private var time = Date()
    @State private var errorMessage: String?
    @State private var isBusy = false
    @State private var showNotificationDenied = false
    @State private var showDeleteConfirm = false
    @State private var showPasswordPrompt = false
    @State private var password = ""

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    ProfileForm(name: $name, photo: $photo, weekdays: $weekdays, time: $time)
                    if let errorMessage {
                        Text(errorMessage)
                            .font(.appCaption)
                            .foregroundStyle(Theme.rose)
                    }
                    PrimaryButton(title: isBusy ? "Working..." : "Save changes") {
                        save()
                    }
                    .disabled(isBusy)
                    Button("Delete account") {
                        showDeleteConfirm = true
                    }
                    .font(.appBodyBold)
                    .foregroundStyle(Theme.rose)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 12)
                    .disabled(isBusy)
                }
                .padding(Theme.padding)
            }
        }
        .navigationTitle("Edit profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fillFromProfile()
        }
        .alert("Reminders are off", isPresented: $showNotificationDenied) {
            Button("Open Settings") {
                SystemSettings.open()
            }
            Button("Not now", role: .cancel) {}
        } message: {
            Text("Your profile is saved, but notifications are turned off for SSOFit. Turn them on in Settings to get reminders.")
        }
        .alert("Delete account?", isPresented: $showDeleteConfirm) {
            Button("Continue", role: .destructive) {
                password = ""
                showPasswordPrompt = true
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This permanently deletes your profile, photo and account. It can't be undone.")
        }
        .alert("Confirm your password", isPresented: $showPasswordPrompt) {
            SecureField("Password", text: $password)
            Button("Delete account", role: .destructive) {
                deleteAccount()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Enter your password to delete your account.")
        }
    }

    private func fillFromProfile() {
        guard let profile = profileService.profile else {
            return
        }
        name = profile.displayName
        weekdays = profile.reminderWeekdays
        time = profile.reminderTime
        if let uid = auth.uid {
            photo = PhotoStore.load(uid: uid)
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
        isBusy = true
        Task {
            do {
                let saved = try await profileService.save(uid: uid, name: name, weekdays: weekdays, time: time, photo: photo)
                profileService.profile = saved
                if saved.reminderEnabled {
                    dismiss()
                } else {
                    showNotificationDenied = true
                }
            } catch {
                errorMessage = ProfileErrorMessage.text(for: error)
            }
            isBusy = false
        }
    }

    private func deleteAccount() {
        if password.isEmpty {
            errorMessage = "Enter your password to delete your account."
            return
        }
        guard let uid = auth.uid else {
            errorMessage = "You're signed out. Please log in again."
            return
        }
        errorMessage = nil
        isBusy = true
        Task {
            do {
                try await profileService.deleteAccount(uid: uid, password: password, auth: auth)
            } catch {
                errorMessage = ProfileErrorMessage.text(for: error)
            }
            password = ""
            isBusy = false
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
    }
    .environment(AuthService())
    .environment(ProfileService())
}
