//
//  AppTextField.swift
//  SSOFit
//

import SwiftUI

struct AppTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure = false

    private var prompt: Text {
        Text(placeholder).foregroundStyle(Theme.inkSoft)
    }

    var body: some View {
        Group {
            if isSecure {
                SecureField("", text: $text, prompt: prompt)
            } else {
                TextField("", text: $text, prompt: prompt)
            }
        }
        .font(.appBody)
        .foregroundStyle(Theme.ink)
        .padding(14)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.divider, lineWidth: 1))
    }
}

#Preview {
    AppTextField(placeholder: "Email", text: .constant(""))
        .padding()
}
