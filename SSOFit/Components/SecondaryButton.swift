//
//  SecondaryButton.swift
//  SSOFit
//

import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appBodyBold)
                .foregroundStyle(Theme.ink)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Theme.surface, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
                .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.blush, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SecondaryButton(title: "Log in") {}
        .padding()
}
