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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    let backgroundTaskIdentifier = "CheqBackground-Service"
    let fcmMsgFile = "temp.txt"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let fileContent = LoggingUtil.shared.printLocationFile(self.fcmMsgFile)
        LoggingUtil.shared.cPrint(fileContent)
        // setup UI for nav
        AppConfig.shared.setupNavBarUI()
        
        // init firebase SDK
        FirebaseApp.configure()
        
        // setup FB SDK
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // setup singleton and SDKs
        self.setupServices()
        
//        AuthConfig.shared.activeManager.setupForRemoteNotifications(application, delegate: self)
        
        self.setupInitialViewController()
        
        return true
    }
    
    static func setupRemoteNotifications() {
        // setup remote notifications
        AuthConfig.shared.activeManager.setupForRemoteNotifications(UIApplication.shared, delegate: self)
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
        NotificationUtil.shared.notify(NotificationEvent.apnsDeviceToken.rawValue, key: NotificationUserInfoKey.token.rawValue, value: apnsDeviceToken)
    }
    
    func setupSplashViewController() {
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.splash.rawValue)
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func setupLogController() {
        let vc = UIViewController()
        let textView = UITextView()
        vc.view.addSubview(textView)
        textView.text = LoggingUtil.shared.printLocationFile(self.fcmMsgFile)
        AutoLayoutUtil.pinToSuperview(textView, padding: 0.0)
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func setupInitDevController() {
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.multipleChoice.rawValue) as! MultipleChoiceViewController
        vc.viewModel.coordinator = AgeRangeCoordinator()
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    func setupInitialViewController() {
        
       window?.rootViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.splash.rawValue)
        
//        AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
//            self.window?.rootViewController = AppNav.shared.initViewController(StoryboardName.main.rawValue, storyboardId: MainStoryboardId.finance.rawValue)
//            self.window?.makeKeyAndVisible()
//        }.catch { err in
//            self.handleNotLoggedIn()
//        }
        
    }
    
    func handleNotLoggedIn() {
        if !AppConfig.shared.isFirstInstall() {
            window?.rootViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.login.rawValue)
        } else {
            window?.rootViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.splash.rawValue)
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
        AuthConfig.shared.activeManager.storeMessagingRegistrationToken(fcmToken).done { success in
            if success {
                LoggingUtil.shared.cPrint("fcmToken \(fcmToken)")
                NotificationUtil.shared.notify(NotificationEvent.fcmToken.rawValue, key: NotificationUserInfoKey.token.rawValue, value: fcmToken)
            }
            }.catch {_ in }
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        LoggingUtil.shared.cPrint(remoteMessage.messageID)
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
        LoggingUtil.shared.cWriteToFile(self.fcmMsgFile, newText: "\(dateString)")
        LoggingUtil.shared.cWriteToFile(self.fcmMsgFile,newText: "message received \(dateString)")
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = DataHelperUtil.shared.randomEmail()
        credentials[.password] = DataHelperUtil.shared.randomPassword()
        AuthConfig.shared.activeManager.register(.socialLoginEmail, credentials: credentials).done { authUser in
            
            completion()
        }.then { authUser in
            CheqAPIManager.shared.putUserDetails(DataHelperUtil.shared.putUserDetailsReq())
        }.done { authUser in
            LoggingUtil.shared.cWriteToFile(self.fcmMsgFile,newText: "successfully registered a user \(dateString)")
        }.catch{ err in
            LoggingUtil.shared.cPrint(err.localizedDescription)
            LoggingUtil.shared.cWriteToFile(self.fcmMsgFile,newText: "\(err.localizedDescription)")
            completion()
        }
    }
}

// MARK: Segment
extension AppDelegate {
    
    // trigger the first initiation of AppConfig singleton
    func setupServices() {
        Fabric.with([Crashlytics.self])
        let _ = CheqAPIManager.shared
        let _ = AppConfig.shared
        let _ = AuthConfig.shared
//        let _ = VDotManager.shared
    }
}

// MARK: unused
extension AppDelegate {
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

