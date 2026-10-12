//
//  AppCard.swift
//  SSOFit
//

import SwiftUI

struct AppCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(Theme.padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.surface, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
            .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.divider, lineWidth: 1))
    }
}

#Preview {
    AppCard {
        Text("Card")
            .font(.appBody)
    }
    .padding()
}
