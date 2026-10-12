//
//  Chip.swift
//  SSOFit
//

import SwiftUI

struct Chip: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.appCaption)
            .foregroundStyle(Theme.ink)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Theme.lavender, in: Capsule())
    }
}

#Preview {
    Chip(text: "Quads")
        .padding()
}
