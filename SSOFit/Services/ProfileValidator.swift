//
//  ProfileValidator.swift
//  SSOFit
//

import Foundation

enum ProfileValidator {
    // Returns a message, or nil when the input is fine.
    static func check(name: String, weekdays: Set<Int>) -> String? {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Enter your name."
        }
        if weekdays.isEmpty {
            return "Choose at least one reminder day."
        }
        return nil
    }
}
