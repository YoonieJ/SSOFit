//
//  ProfileForm.swift
//  SSOFit
//

import SwiftUI
import PhotosUI
import AVFoundation

// The fields shared by Profile setup and Edit profile.
struct ProfileForm: View {
    @Binding var name: String
    @Binding var photo: UIImage?
    @Binding var weekdays: Set<Int>
    @Binding var time: Date

    @State private var pickerItem: PhotosPickerItem?
    @State private var showCamera = false
    @State private var showCameraDenied = false
    @State private var photoError: String?

    private var cameraAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 16) {
                avatar
                VStack(alignment: .leading, spacing: 8) {
                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        Text("Choose photo")
                            .font(.appBodyMedium)
                            .foregroundStyle(Theme.rose)
                    }
                    // The simulator has no camera, so the button is hidden there.
                    if cameraAvailable {
                        Button("Take photo") {
                            openCamera()
                        }
                        .font(.appBodyMedium)
                        .foregroundStyle(Theme.rose)
                    }
                    if photo != nil {
                        Button("Remove photo") {
                            photo = nil
                        }
                        .font(.appBodyMedium)
                        .foregroundStyle(Theme.inkSoft)
                    }
                }
            }
            if let photoError {
                Text(photoError)
                    .font(.appCaption)
                    .foregroundStyle(Theme.rose)
            }
            Text("Name")
                .font(.appHeading)
                .foregroundStyle(Theme.ink)
            AppTextField(placeholder: "Display name", text: $name)
                .textContentType(.name)
            Text("Workout reminders")
                .font(.appHeading)
                .foregroundStyle(Theme.ink)
            WeekdayPicker(selection: $weekdays)
            DatePicker("Reminder time", selection: $time, displayedComponents: .hourAndMinute)
                .font(.appBody)
                .foregroundStyle(Theme.ink)
                .tint(Theme.blush)
        }
        .onChange(of: pickerItem) {
            loadPickedPhoto()
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraPicker(image: $photo)
                .ignoresSafeArea()
        }
        .alert("Camera access is off", isPresented: $showCameraDenied) {
            Button("Open Settings") {
                SystemSettings.open()
            }
            Button("Not now", role: .cancel) {}
        } message: {
            Text("Turn on camera access for SSOFit in Settings to take a photo.")
        }
    }

    private var avatar: some View {
        Group {
            if let photo {
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(Theme.inkSoft)
            }
        }
        .frame(width: 96, height: 96)
        .background(Theme.lavender)
        .clipShape(Circle())
        .accessibilityLabel("Profile photo")
    }

    private func openCamera() {
        photoError = nil
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showCamera = true
        case .notDetermined:
            Task {
                if await AVCaptureDevice.requestAccess(for: .video) {
                    showCamera = true
                } else {
                    showCameraDenied = true
                }
            }
        default:
            showCameraDenied = true
        }
    }

    private func loadPickedPhoto() {
        guard let item = pickerItem else {
            return
        }
        photoError = nil
        Task {
            do {
                if let data = try await item.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                    photo = image
                } else {
                    photoError = "That photo couldn't be loaded. Try another one."
                }
            } catch {
                photoError = "That photo couldn't be loaded. Try another one."
            }
            pickerItem = nil
        }
    }
}

#Preview {
    ProfileForm(name: .constant(""), photo: .constant(nil), weekdays: .constant([]), time: .constant(Date()))
        .padding()
}
