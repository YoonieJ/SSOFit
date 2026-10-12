//
//  PrimaryButton.swift
//  SSOFit
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appBodyBold)
                .foregroundStyle(isEnabled ? Theme.onAccent : Theme.inkSoft)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isEnabled ? Theme.blush : Theme.divider, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PrimaryButton(title: "Continue") {}
        .padding()
}
