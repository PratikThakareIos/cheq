//
//  AppDelegate.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 7/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit
import Analytics
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.setupSegment()
        self.setupAppConfig()
        
        // setup
        AuthConfig.shared.activeManager.setupForRemoteNotifications(application, delegate: self)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // assign apns device token to Firebase Messaging sdk
        Messaging.messaging().apnsToken = deviceToken
        
        // extract deviceToken into String and notify observers
        let apnsDeviceToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        NotificationUtil.shared.notify(NotificationEvent.apnsDeviceToken.rawValue, key: NotificationUserInfoKey.token.rawValue, value: apnsDeviceToken)
        
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
        case .active: break
        case .inactive, .background:
            LoggingUtil.shared.cPrint("message received")
            MoneySoftManager.shared.getInstitutions().done { _ in
                completionHandler(.newData)
            }.catch { err in
                completionHandler(.noData)
            }
        }
    }
}

// MARK: Segment
extension AppDelegate {
    
    // configure and setup segment
    func setupSegment() {
        
        let segConfig = SEGAnalyticsConfiguration(writeKey: "DAmGqZ4pL19uFxe97hESgpzPj6UyOlF8")
        segConfig.trackApplicationLifecycleEvents = true
        segConfig.recordScreenViews = true
        SEGAnalytics.setup(with: segConfig)
    }
    
    // trigger the first initiation of AppConfig singleton
    func setupAppConfig() {
        let _ = AppConfig.shared
    }
}

// MARK: Firebase Messaging
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        AuthConfig.shared.activeManager.storeMessagingRegistrationToken(fcmToken).done { success in
            if success {
                NotificationUtil.shared.notify(NotificationEvent.fcmToken.rawValue, key: NotificationUserInfoKey.token.rawValue, value: fcmToken)
            }
        }.catch {_ in }
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        LoggingUtil.shared.cPrint(remoteMessage.messageID)
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

