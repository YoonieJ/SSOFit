//
//  AppFontName.swift
//  SSOFit
//

// PostScript names read from the bundled variable fonts. DM Sans names include "9pt" because that is how iOS exposes its instances.
enum AppFontName {
    static let quicksandMedium = "Quicksand-Medium"
    static let quicksandSemiBold = "Quicksand-SemiBold"
    static let quicksandBold = "Quicksand-Bold"
    static let dmSansRegular = "DMSans-9ptRegular_Regular"
    static let dmSansMedium = "DMSans-9ptRegular_Medium"
    static let dmSansBold = "DMSans-9ptRegular_Bold"

    static let all = [
        quicksandMedium,
        quicksandSemiBold,
        quicksandBold,
        dmSansRegular,
        dmSansMedium,
        dmSansBold
    ]
}
