//
//  NotificationDelegate.swift
//  SSOFit
//

import UserNotifications

// Lets reminders show as a banner while the app is open.
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }
}
