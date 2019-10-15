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
import PromiseKit
import DateToolsSwift

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
    var isShowingSpinner = false
    func switchTheme(_ index: Int) {
        guard index >= 0, index < themes.count else { return }
        self.currentActiveThemeIndex = index
        activeTheme = themes[currentActiveThemeIndex]
    }
}

// MARK: Linking to Setting Screen
extension AppConfig {
    func toAppSetting() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    func setupNavBarUI() {
        // hide nav bar
        UINavigationBar.appearance().tintColor = AppConfig.shared.activeTheme.primaryColor
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
    }
    
    func progressNavBar(progress: CProgress, viewController: UIViewController) {
        guard progress.aboutMe <= 1.0, progress.aboutMe >= 0.0 else { return }
        guard progress.employmentDetails <= 1.0, progress.employmentDetails >= 0.0 else { return }
        guard progress.linkingBank <= 1.0, progress.linkingBank >= 0.0 else { return }
        
        guard let _ = viewController.navigationController else { LoggingUtil.shared.cPrint("nav not available");  return }

        let aboutMeProgress = CProgressView()
        aboutMeProgress.setProgress(progress.aboutMe, animated: true)
        
        let employmentDetailsProgress = CProgressView()
        employmentDetailsProgress.setProgress(progress.employmentDetails, animated: true)
        
        let linkingBankProgress = CProgressView()
        linkingBankProgress.setProgress(progress.linkingBank, animated: true)
        
        let progressStackView = CProgressViewStackView(progressViews: [aboutMeProgress, employmentDetailsProgress, linkingBankProgress])

        viewController.navigationItem.titleView = progressStackView
    }
}

// MARK: First Install Check
extension AppConfig {
    func installId()-> String {
        let id = Bundle.main.bundleIdentifier ?? "cheq"
        let installId = String("\(id)-install")
        return installId
    }
    
    func isFirstInstall()-> Bool {
        let installIdExist = UserDefaults.standard.bool(forKey: installId())
        let firstInstall = !installIdExist
        return firstInstall
    }
    
    func markFirstInstall() {
       
        CKeychain.shared.clearKeychain()
        UserDefaults.standard.set(true, forKey: installId())
        UserDefaults.standard.synchronize()
    }
}

// MARK: Spinner
extension AppConfig {
    func showSpinner() {
        guard self.isShowingSpinner == false else { return }
        NotificationUtil.shared.notify(NotificationEvent.dismissKeyboard.rawValue, key: "", value: "")
        self.isShowingSpinner = true
        SwiftSpinner.setTitleFont(activeTheme.headerFont)
        SwiftSpinner.shared.outerColor = activeTheme.alternativeColor3
        SwiftSpinner.shared.innerColor = activeTheme.alternativeColor3
        SwiftSpinner.setTitleColor(activeTheme.altTextColor)
        SwiftSpinner.setAnimationDelay(activeTheme.quickAnimationDuration)
        SwiftSpinner.show("Loading", animated: true)
    }
    
    func hideSpinner()->Promise<Void> {
        return Promise<Void>() { resolver in
            guard self.isShowingSpinner == true else { resolver.fulfill(()); return }
            self.isShowingSpinner = false
            SwiftSpinner.hide {
                resolver.fulfill(())
            }
        }
    }
    
    func hideSpinner(completion: @escaping ()->Void) {
        guard self.isShowingSpinner == true else { completion(); return }
        self.isShowingSpinner = false
        SwiftSpinner.hide(completion)
    }
}


// MARK: Push Notification Tokens
extension AppConfig {
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

