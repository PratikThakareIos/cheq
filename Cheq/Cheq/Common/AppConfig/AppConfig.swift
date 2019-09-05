//
//  AppConfig.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 10/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit
import SwiftSpinner
import UserNotifications

let sharedAppConfig = AppConfig.shared

// manages the app global variables
class AppConfig {
    static let shared = AppConfig()
    private init () {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateApnsDeviceToken(_:)), name: NSNotification.Name(NotificationEvent.apnsDeviceToken.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFCMDeviceToken(_:)), name: NSNotification.Name(NotificationEvent.fcmToken.rawValue), object: nil)
    }
    
    deinit {
        // remove all notification observable
        NotificationCenter.default.removeObserver(self)
    }
    
    var apnsDeviceToken: String = ""
    var fcmToken: String = ""
    var themeTitles = [PrimaryTheme().themeTitle, DarkTheme().themeTitle, CBATheme().themeTitle]
    var themes:[AppThemeProtocol] = [PrimaryTheme(), DarkTheme(), CBATheme()]
    var activeTheme: AppThemeProtocol = PrimaryTheme()
    var currentActiveThemeIndex = 0

    func switchTheme(_ index: Int) {
        guard index >= 0, index < themes.count else { return }
        self.currentActiveThemeIndex = index
        activeTheme = themes[currentActiveThemeIndex]
    }

    func showSpinner() {
        SwiftSpinner.setTitleFont(activeTheme.headerFont)
        SwiftSpinner.setTitleColor(activeTheme.alternativeColor1)
        SwiftSpinner.setAnimationDelay(activeTheme.quickAnimationDuration)
        SwiftSpinner.show("Loading", animated: true)
    }

    func hideSpinner() {
        SwiftSpinner.hide()
    }
    
    @objc func updateFCMDeviceToken(_ notification: Notification) {
        self.fcmToken = notification.userInfo?[NotificationUserInfoKey.token.rawValue] as? String ?? ""
        LoggingUtil.shared.cPrint("fcm token")
        LoggingUtil.shared.cPrint(self.fcmToken)
    }
    
    @objc func updateApnsDeviceToken(_ notification: Notification) {
        self.apnsDeviceToken = notification.userInfo?[NotificationUserInfoKey.token.rawValue] as? String ?? ""
        LoggingUtil.shared.cPrint("apns token")
        LoggingUtil.shared.cPrint(self.apnsDeviceToken)
    }
}
