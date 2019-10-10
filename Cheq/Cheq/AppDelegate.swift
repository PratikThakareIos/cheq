//
//  AppDelegate.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 7/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
import Fabric
import Crashlytics
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    let backgroundTaskIdentifier = "CheqBackground-Service"
    var visualEffectView = UIVisualEffectView()
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // keep a reference for re-use
        AppData.shared.application = application
        
        // to setup VDot again
        if (launchOptions?[UIApplication.LaunchOptionsKey.location]) != nil {
            let timestamp = Date().timeStamp()
            LoggingUtil.shared.cWriteToFile(LoggingUtil.shared.fcmMsgFile, newText: "launch by location signal - \(timestamp)")
            let _ = VDotManager.shared
        }
        
        let fileContent = LoggingUtil.shared.printLocationFile(LoggingUtil.shared.fcmMsgFile)
        LoggingUtil.shared.cPrint(fileContent)
        // setup UI for nav
        AppConfig.shared.setupNavBarUI()
        
        // init firebase SDK
        FirebaseApp.configure()
        // Firebase Message delegate
        Messaging.messaging().delegate = self
        
        // setup FB SDK
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // setup singleton and SDKs
        self.registerNotificationObservers()
//        self.setupServices()
        self.setupInitialViewController()
//        self.setupInitDevController()
//        self.setupLogController()
        
        return true
    }
    
    // do not use this in AppDelegate as UIApplication.shared is not ready
    static func setupRemoteNotifications() {
        // setup remote notifications
        guard let application = AppData.shared.application else { return }
        AuthConfig.shared.activeManager.setupForRemoteNotifications(application, delegate: self)
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, options: options)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // assign apns device token to Firebase Messaging sdk
        Messaging.messaging().apnsToken = deviceToken
        
        // extract deviceToken into String and notify observers
        let apnsDeviceToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        LoggingUtil.shared.cPrint("apns \(apnsDeviceToken)")
        let _ = CKeychain.shared.setValue(CKey.apnsToken.rawValue, value: apnsDeviceToken)
        NotificationUtil.shared.notify(NotificationEvent.apnsDeviceToken.rawValue, key: NotificationUserInfoKey.token.rawValue, value: apnsDeviceToken)
    }

    func setupInitialViewController() {
        AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
            let vc = AppNav.shared.initViewController(.legalName)
            self.window?.rootViewController = vc ?? UIViewController()
            self.window?.makeKeyAndVisible()
        }.catch { err in
            self.handleNotLoggedIn()
        }
    }
    
    @objc func handleLogout(notification: NSNotification) {
        LoggingUtil.shared.cPrint("handle logout")
        window?.rootViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.registration.rawValue, embedInNav: true)
    }
    
    func handleNotLoggedIn() {
        if !AppConfig.shared.isFirstInstall() {
            window?.rootViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.registration.rawValue, embedInNav: true)
        } else {
            window?.rootViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.splash.rawValue, embedInNav: true)
        }
        self.window?.makeKeyAndVisible()
    }
    
    //MARK: UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    //MARK: Firebase messaging
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        // storeMessagingRegistrationToken stores fcmToken to CKeychain
        AuthConfig.shared.activeManager.storeMessagingRegistrationToken(fcmToken).done { success in
            if success {
                LoggingUtil.shared.cPrint("fcmToken \(fcmToken)")
                NotificationUtil.shared.notify(NotificationEvent.fcmToken.rawValue, key: NotificationUserInfoKey.token.rawValue, value: fcmToken)
            }
            }.catch {_ in }
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        LoggingUtil.shared.cPrint(remoteMessage.messageID)
        let dateString = VDotManager.shared.dateFormatter.string(from: Date())
        LoggingUtil.shared.cWriteToFile(LoggingUtil.shared.fcmMsgFile, newText: "message received \(dateString)")
        self.handleRemoteNotification {
        }
    }
}

// MARK: Remote applicatioin handling
extension AppDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        LoggingUtil.shared.cPrint(userInfo)
    }

    func application(_ application: UIApplication,
                              didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                              fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        LoggingUtil.shared.cPrint(userInfo)
        switch application.applicationState {
        case .active, .inactive, .background:
            LoggingUtil.shared.cPrint(String(application.backgroundTimeRemaining))
            if self.backgroundTask == .invalid, application.backgroundRefreshStatus == .available {
                self.backgroundTask = application.beginBackgroundTask(withName: backgroundTaskIdentifier, expirationHandler: { self.expirationHandler() })
                
                self.handleRemoteNotification {
                    self.expirationHandler()
                    completionHandler(UIBackgroundFetchResult.noData)
                }
            }
        }
    }
    
    func expirationHandler() {
        UIApplication.shared.endBackgroundTask(self.backgroundTask)
        self.backgroundTask = .invalid
    }
    
    func handleRemoteNotification(_ completion: @escaping ()->Void) {
        
        let dateString = VDotManager.shared.dateFormatter.string(from: Date())
        LoggingUtil.shared.cWriteToFile(LoggingUtil.shared.fcmMsgFile, newText: "\(dateString)")
        LoggingUtil.shared.cWriteToFile(LoggingUtil.shared.fcmMsgFile,newText: "message received \(dateString)")
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = TestUtil.shared.randomEmail()
        credentials[.password] = TestUtil.shared.randomPassword()
        AuthConfig.shared.activeManager.register(.socialLoginEmail, credentials: credentials).done { authUser in
            
            completion()
        }.then { authUser in
            CheqAPIManager.shared.putUserDetails(TestUtil.shared.putUserDetailsReq())
        }.done { authUser in
//            LoggingUtil.shared.cWriteToFile(self.fcmMsgFile,newText: "successfully registered a user \(dateString)")
        }.catch{ err in
            LoggingUtil.shared.cPrint(err.localizedDescription)
            LoggingUtil.shared.cWriteToFile(LoggingUtil.shared.fcmMsgFile, newText: "\(err.localizedDescription)")
            completion()
        }
    }
}

// MARK: Segment
extension AppDelegate {
    
    func registerNotificationObservers() {
        // Event for programmatically logging out and returning to Registration screen
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogout(notification:)), name: NSNotification.Name(NotificationEvent.logout.rawValue), object: nil)
    }
    
    // trigger the first initiation of AppConfig singleton
    func setupServices() {
        guard let _ = AppData.shared.application else { return }
        Fabric.with([Crashlytics.self])
        let _ = CheqAPIManager.shared
//        let _ = AppConfig.shared
        let _ = AuthConfig.shared
//        let _ = VDotManager.shared
//        AuthConfig.shared.activeManager.setupForRemoteNotifications(application, delegate: self)
    }
    
    func setupServicesForDev() {
        guard let _ = AppData.shared.application else { return }
//        Fabric.with([Crashlytics.self])
        let _ = CheqAPIManager.shared
        let _ = AppConfig.shared
        let _ = AuthConfig.shared
//        let _ = VDotManager.shared
//        AuthConfig.shared.activeManager.setupForRemoteNotifications(application, delegate: self)
    }
}

// MARK: unused
extension AppDelegate {
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if !self.visualEffectView.isDescendant(of: self.window!) {
            let blurEffect = UIBlurEffect(style: .light)
            self.visualEffectView = UIVisualEffectView(effect: blurEffect)
            self.visualEffectView.frame = (self.window?.bounds)!
            self.window?.addSubview(self.visualEffectView)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        LoggingUtil.shared.cPrint("applicationWillEnterForeground")
        self.visualEffectView.removeFromSuperview()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        LoggingUtil.shared.cPrint("applicationDidBecomeActive")
        NotificationUtil.shared.notify(NotificationEvent.appBecomeActive.rawValue, key: "", value: "")
        self.visualEffectView.removeFromSuperview()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {

    func setupInitDevController () {
        self.setupServicesForDev()
        let vc = AppNav.shared.initViewController(StoryboardName.lending.rawValue, storyboardId: LendingStoryboardId.lending.rawValue, embedInNav: true)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }

    func setupLogController() {
        self.setupServicesForDev()
        let vc = LogViewController()
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    func setupInitPasscodeController() {
        self.setupServicesForDev()
        let storyboard = UIStoryboard(name: StoryboardName.common.rawValue, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: CommonStoryboardId.passcode.rawValue) as! PasscodeViewController
        vc.viewModel.type = .setup
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}

