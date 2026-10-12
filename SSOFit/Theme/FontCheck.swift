//
//  FontCheck.swift
//  SSOFit
//

import UIKit

enum FontCheck {
    // Logs any font name that does not resolve, so a typo cannot silently fall back to the system font.
    static func verify() {
        for name in AppFontName.all where UIFont(name: name, size: 12) == nil {
            print("Font missing: \(name)")
        }
    }
}
