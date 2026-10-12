//
//  AppDelegate.swift
//  SSOFit
//

import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Without GoogleService-Info.plist, FirebaseApp.configure() raises an exception, so skip it and warn.
        if Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil {
            FirebaseApp.configure()
        } else {
            print("Firebase not configured: GoogleService-Info.plist is missing from the app target.")
        }
        return true
    }
}
