//
//  SystemSettings.swift
//  SSOFit
//

import UIKit

enum SystemSettings {
    // Opens this app's page in the iOS Settings app, where permissions can be changed.
    static func open() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url)
    }
}
