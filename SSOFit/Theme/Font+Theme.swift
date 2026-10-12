//
//  Font+Theme.swift
//  SSOFit
//

import SwiftUI

// Quicksand for titles and numbers, DM Sans for body text. All scale with Dynamic Type.
extension Font {
    static let appLargeTitle = Font.custom(AppFontName.quicksandBold, size: 34, relativeTo: .largeTitle)
    static let appTitle = Font.custom(AppFontName.quicksandBold, size: 28, relativeTo: .title)
    static let appHeading = Font.custom(AppFontName.quicksandSemiBold, size: 20, relativeTo: .headline)
    static let appNumber = Font.custom(AppFontName.quicksandSemiBold, size: 32, relativeTo: .title)
    static let appNumberSmall = Font.custom(AppFontName.quicksandMedium, size: 20, relativeTo: .headline)
    static let appBody = Font.custom(AppFontName.dmSansRegular, size: 16, relativeTo: .body)
    static let appBodyMedium = Font.custom(AppFontName.dmSansMedium, size: 16, relativeTo: .body)
    static let appBodyBold = Font.custom(AppFontName.dmSansBold, size: 16, relativeTo: .body)
    static let appCaption = Font.custom(AppFontName.dmSansRegular, size: 13, relativeTo: .caption)
}
