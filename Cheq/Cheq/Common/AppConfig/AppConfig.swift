//
//  AppConfig.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 10/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import UserNotifications
import PromiseKit
import DateToolsSwift

/// Singleton instance of AppConfig
let sharedAppConfig = AppConfig.shared

/**
 AppConfig manages app global configurations including apns device token, fcm token, active themes and various global UI trigger methods for loading indicator and navigation bar behaviour for certain UI flow. Always refer styling attributes from **AppConfig.shared.activeTheme** instead of doing any hardcoding values
*/
class AppConfig {
    
    /// Singleton instance of AppConfig
    static let shared = AppConfig()
    
    private init () {
        
        /// add observer for events to store **apnsDeviceToken** and **fcmToken**
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateApnsDeviceToken(_:)), name: NSNotification.Name(NotificationEvent.apnsDeviceToken.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFCMDeviceToken(_:)), name: NSNotification.Name(NotificationEvent.fcmToken.rawValue), object: nil)
    }
    
    /// we remove all observables when AppConfig deInit, this is actually not needed in new version of iOS
    deinit {
        // remove all notification observable
        NotificationCenter.default.removeObserver(self)
    }
    
    /// apns device token is the notification register token from Apple
    var apnsDeviceToken: String = ""
    
    /// fcm token is the notification register token from Firebase
    var fcmToken: String = ""
    
    /// array which contains themes title, we are not using this if we don't want to create an menu for list of existing themes for users to choose from
    var themeTitles = [PrimaryTheme().themeTitle, DarkTheme().themeTitle, CBATheme().themeTitle]
    
    /// array of **AppThemeProtocol** , we don't use this unless when want to introduce theme switching in the app
    var themes:[AppThemeProtocol] = [PrimaryTheme(), DarkTheme(), CBATheme()]
    
    /// default theme is **PrimaryTheme** which follows **AppThemeProtocol**
    var activeTheme: AppThemeProtocol = PrimaryTheme()
    
    /// index of current active theme
    var currentActiveThemeIndex = 0
    
    /// boolean to indicate if spinner is currently showing, we can use this to avoid showing spinner multiple times 
    var isShowingSpinner = false
    
    /// method to switch the app's current theme, but we don't need this atm, use it later.
    func switchTheme(_ index: Int) {
        guard index >= 0, index < themes.count else { return }
        self.currentActiveThemeIndex = index
        activeTheme = themes[currentActiveThemeIndex]
    }
}

// MARK: Linking to Setting Screen
extension AppConfig {
    
    /// method abstracting the retrieval of screen height
    func screenHeight()->CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// method abstracting the retrieval of screen width
    func screenWidth()->CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// method abstracting toe navigation to App setting
    func toAppSetting() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    /// setup the global appearance for Navigation bar
    func setupNavBarUI() {
        // hide nav bar
        UINavigationBar.appearance().tintColor = AppConfig.shared.activeTheme.primaryColor
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
        let attributes = [NSAttributedString.Key.font: AppConfig.shared.activeTheme.headerBoldFont]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
    /// remove global progress navigation bar which are used during onboarding flow
    func removeProgressNavBar(_ viewController: UIViewController) {
        guard let _ = viewController.navigationController else { LoggingUtil.shared.cPrint("nav not available");  return }
        viewController.navigationItem.titleView = nil
    }
    
    /// method for updating the progress bar on nav bar during onboarding
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
    
    /// Method to retrieve an Id for which we store in **UserDefaults** to track if the app has been initiallly installed already. This determines whether we show user the Splash screens.
    func installId()-> String {
        let id = Bundle.main.bundleIdentifier ?? "cheq"
        let installId = String("\(id)-install")
        return installId
    }
    
    /// Method to check if we are first time runnning the app after installation
    func isFirstInstall()-> Bool {
        let installIdExist = UserDefaults.standard.bool(forKey: installId())
        let firstInstall = !installIdExist
        return firstInstall
    }
    
    /// this method is used by Splash screen, to marked the first installation so that we know that we have completed the first installation run
    func markFirstInstall() {
       
        CKeychain.shared.clearKeychain()
        UserDefaults.standard.set(true, forKey: installId())
        UserDefaults.standard.synchronize()
    }
}

// MARK: Spinner
extension AppConfig {
    
    /// use **showSpinner** when we want to display loading indicator, this abstracts the rest of the app from knowing how we implemented our loading indicator
    func showSpinner() {
        guard self.isShowingSpinner == false else { return }
        NotificationUtil.shared.notify(NotificationEvent.dismissKeyboard.rawValue, key: "", value: "")
        self.isShowingSpinner = true
        SVProgressHUD.setFont(AppConfig.shared.activeTheme.headerFont)
        SVProgressHUD.setForegroundColor(AppConfig.shared.activeTheme.textBackgroundColor)
        SVProgressHUD.setBorderColor(.clear)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.show(withStatus: " ")
    }
    
    /// call hideSpinner after task is completed
    func hideSpinner()->Promise<Void> {
        return Promise<Void>() { resolver in
            guard self.isShowingSpinner == true else { resolver.fulfill(()); return }
            self.isShowingSpinner = false
            SVProgressHUD.dismiss(completion: {
                resolver.fulfill(())
            })
        }
    }
    
    /// call hideSpinner after task is completed
    func hideSpinner(completion: @escaping ()->Void) {
        guard self.isShowingSpinner == true else { completion(); return }
        self.isShowingSpinner = false
        SVProgressHUD.dismiss {
            completion()
        }
    }
}


// MARK: Push Notification Tokens
extension AppConfig {
    
    /// method update fcmToken from notification
    @objc func updateFCMDeviceToken(_ notification: Notification) {
        self.fcmToken = notification.userInfo?[NotificationUserInfoKey.token.rawValue] as? String ?? ""
        LoggingUtil.shared.cPrint("fcm token")
        LoggingUtil.shared.cPrint(self.fcmToken)
    }
    
    /// method update apnsDeviceToken from notification
    @objc func updateApnsDeviceToken(_ notification: Notification) {
        self.apnsDeviceToken = notification.userInfo?[NotificationUserInfoKey.token.rawValue] as? String ?? ""
        LoggingUtil.shared.cPrint("apns token")
        LoggingUtil.shared.cPrint(self.apnsDeviceToken)
    }
}

