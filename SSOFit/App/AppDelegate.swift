//
//  AppDelegate.swift
//  SSOFit
//

import UIKit
import FirebaseCore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    // The notification center holds its delegate weakly, so keep a strong reference here.
    private let notificationDelegate = NotificationDelegate()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Without GoogleService-Info.plist, FirebaseApp.configure() raises an exception, so skip it and warn.
        if Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil {
            FirebaseApp.configure()
        } else {
            print("Firebase not configured: GoogleService-Info.plist is missing from the app target.")
        }
        UNUserNotificationCenter.current().delegate = notificationDelegate
        return true
    }
}
