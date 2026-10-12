//
//  UserProfile.swift
//  SSOFit
//

import Foundation
import FirebaseFirestore

// The text part of a profile, stored in Firestore at users/{uid}. The photo stays on the device.
struct UserProfile {
    var displayName: String
    var reminderEnabled: Bool
    // Calendar weekday numbers: 1 is Sunday through 7 is Saturday.
    var reminderWeekdays: Set<Int>
    // Only the hour and minute are used.
    var reminderTime: Date
    var createdAt: Date
    var updatedAt: Date

    init(displayName: String, reminderEnabled: Bool, reminderWeekdays: Set<Int>, reminderTime: Date, createdAt: Date, updatedAt: Date) {
        self.displayName = displayName
        self.reminderEnabled = reminderEnabled
        self.reminderWeekdays = reminderWeekdays
        self.reminderTime = reminderTime
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    // Returns nil when a field is missing or has the wrong type, so bad data cannot crash the app.
    init?(data: [String: Any]) {
        guard let displayName = data["displayName"] as? String,
              let reminderEnabled = data["reminderEnabled"] as? Bool,
              let weekdays = data["reminderWeekdays"] as? [Int],
              let reminderTime = (data["reminderTime"] as? Timestamp)?.dateValue(),
              let createdAt = (data["createdAt"] as? Timestamp)?.dateValue(),
              let updatedAt = (data["updatedAt"] as? Timestamp)?.dateValue() else {
            return nil
        }
        self.init(displayName: displayName, reminderEnabled: reminderEnabled, reminderWeekdays: Set(weekdays),
                  reminderTime: reminderTime, createdAt: createdAt, updatedAt: updatedAt)
    }

    var data: [String: Any] {
        return [
            "displayName": displayName,
            "reminderEnabled": reminderEnabled,
            "reminderWeekdays": reminderWeekdays.sorted(),
            "reminderTime": Timestamp(date: reminderTime),
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt)
        ]
    }
}
