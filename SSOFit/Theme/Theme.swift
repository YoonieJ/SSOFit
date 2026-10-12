//
//  Theme.swift
//  SSOFit
//

import SwiftUI

// Single source for colors and layout constants. Colors live in Assets.xcassets/Theme with light and dark variants.
enum Theme {
    static let background = Color(.background)
    static let surface = Color(.surface)
    static let blush = Color(.blush)
    static let rose = Color(.rose)
    static let lavender = Color(.lavender)
    static let sage = Color(.sage)
    static let ink = Color(.ink)
    static let inkSoft = Color(.inkSoft)
    static let divider = Color(.divider)

    // Fixed dark ink for text on Blush or Rose fills, the same in both modes.
    static let onAccent = Color(.onAccent)

    static let heatNone = Color(.heatNone)
    static let heatLow = Color(.heatLow)
    static let heatMid = Color(.heatMid)
    static let heatHigh = Color(.heatHigh)
    static let bodyBase = Color(.bodyBase)

    static let cornerRadius: CGFloat = 16
    static let padding: CGFloat = 16
}
