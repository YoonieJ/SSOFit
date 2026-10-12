//
//  ReminderService.swift
//  SSOFit
//

import Foundation
import UserNotifications

// Local workout reminders: one repeating weekly notification per chosen weekday, with a fixed identifier each.
enum ReminderService {
    private static func identifier(weekday: Int) -> String {
        return "workout-reminder-\(weekday)"
    }

    // Asks only when the user has not decided yet. Returns whether notifications are allowed.
    static func requestPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        case .notDetermined:
            return (try? await center.requestAuthorization(options: [.alert, .sound])) ?? false
        default:
            return false
        }
    }

    // Replaces any existing reminders with the given ones.
    static func schedule(weekdays: Set<Int>, time: Date) async throws {
        removeAll()
        let parts = Calendar.current.dateComponents([.hour, .minute], from: time)
        for weekday in weekdays.sorted() {
            var when = DateComponents()
            when.weekday = weekday
            when.hour = parts.hour
            when.minute = parts.minute
            let content = UNMutableNotificationContent()
            content.title = "Time to move"
            content.body = "Your workout reminder is here."
            content.sound = .default
            let trigger = UNCalendarNotificationTrigger(dateMatching: when, repeats: true)
            let request = UNNotificationRequest(identifier: identifier(weekday: weekday), content: content, trigger: trigger)
            try await UNUserNotificationCenter.current().add(request)
        }
    }

    static func removeAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
