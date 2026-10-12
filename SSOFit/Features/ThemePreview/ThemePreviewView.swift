//
//  ThemePreviewView.swift
//  SSOFit
//

import SwiftUI

// TEMPORARY: delete the whole Features/ThemePreview folder once the theme is checked.
struct ThemePreviewView: View {
    @State private var text = ""
    @State private var secret = ""

    private let swatches: [(name: String, color: Color)] = [
        ("Background", Theme.background),
        ("Surface", Theme.surface),
        ("Blush", Theme.blush),
        ("Rose", Theme.rose),
        ("Lavender", Theme.lavender),
        ("Sage", Theme.sage),
        ("Ink", Theme.ink),
        ("Ink soft", Theme.inkSoft),
        ("Divider", Theme.divider),
        ("Heat none", Theme.heatNone),
        ("Heat low", Theme.heatLow),
        ("Heat mid", Theme.heatMid),
        ("Heat high", Theme.heatHigh),
        ("Body base", Theme.bodyBase)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("THEME PREVIEW (temporary)")
                    .font(.appCaption)
                    .foregroundStyle(Theme.rose)

                Text("Colors")
                    .font(.appHeading)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 12)], spacing: 12) {
                    ForEach(swatches, id: \.name) { swatch in
                        VStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(swatch.color)
                                .frame(height: 44)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.divider, lineWidth: 1))
                            Text(swatch.name)
                                .font(.appCaption)
                        }
                    }
                }

                Text("Fonts")
                    .font(.appHeading)
                AppCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Large title").font(.appLargeTitle)
                        Text("Title").font(.appTitle)
                        Text("Heading").font(.appHeading)
                        Text("185.5 lb").font(.appNumber)
                        Text("12 reps").font(.appNumberSmall)
                        Text("Body regular").font(.appBody)
                        Text("Body medium").font(.appBodyMedium)
                        Text("Body bold").font(.appBodyBold)
                        Text("Caption").font(.appCaption).foregroundStyle(Theme.inkSoft)
                    }
                }

                Text("Components")
                    .font(.appHeading)
                PrimaryButton(title: "Primary button") {}
                PrimaryButton(title: "Disabled button") {}
                    .disabled(true)
                HStack {
                    Chip(text: "Quads")
                    Chip(text: "Glutes")
                    Chip(text: "Strength")
                }
                AppTextField(placeholder: "Email", text: $text)
                AppTextField(placeholder: "Password", text: $secret, isSecure: true)
                AppCard {
                    Text("A card with a divider border")
                        .font(.appBody)
                }
            }
            .foregroundStyle(Theme.ink)
            .padding(Theme.padding)
        }
        .background(Theme.background)
    }
}

#Preview("Light") {
    ThemePreviewView()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    ThemePreviewView()
        .preferredColorScheme(.dark)
}
