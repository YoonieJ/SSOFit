//
//  SSOFitApp.swift
//  SSOFit
//
//  Created by Yoon Jang on 10/11/26.
//

import SwiftUI

@main
struct SSOFitApp: App {
    // Registers the app delegate so Firebase is configured at launch.
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate

    @State private var auth = AuthService()

    init() {
        FontCheck.verify()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(auth)
        }
    }
}
