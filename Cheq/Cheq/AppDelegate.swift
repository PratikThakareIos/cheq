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
import FirebaseCore
import FirebaseMessaging
import FirebaseCrashlytics
import FBSDKLoginKit
import PromiseKit
import IQKeyboardManagerSwift
import OneSignal
import FBSDKCoreKit

//import MobileSDK
//import Fabric
//import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    let backgroundTaskIdentifier = "CheqBackground-Service"
    var visualEffectView = UIVisualEffectView()
    let API_BASE_URL = "https://api.beta.moneysoft.com.au"
    let API_REFERRER = "https://cheq.beta.moneysoft.com.au"
    
    #if DEV
        public static var ONESIGNAL_APP_ID = "52a86023-ec61-47f6-9f2b-7de3e4906e82"
    #elseif UAT
        public static var ONESIGNAL_APP_ID = "4ff7560e-be04-4a7b-829c-31b9235dc94e"
    #else
        public static var ONESIGNAL_APP_ID = "e978954b-8bde-4e45-9c6d-5e284efe9a30"
    #endif
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         
        // Use Firebase library to configure APIs
         FirebaseApp.configure()
      
         Analytics.setAnalyticsCollectionEnabled(true)
        
         //Remove this method to stop OneSignal Debugging
         OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)

         //START OneSignal initialization code
         let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
        
         
         // Replace 'YOUR_ONESIGNAL_APP_ID' with your OneSignal App ID.
         OneSignal.initWithLaunchOptions(launchOptions,
                                         appId: AppDelegate.ONESIGNAL_APP_ID, //"361c802d-82c5-42eb-8765-068dd2c36149", //"YOUR_ONESIGNAL_APP_ID",
           handleNotificationAction: nil,
           settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        // The promptForPushNotifications function code will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 6)
                
        //         OneSignal.promptForPushNotifications(userResponse: { accepted in
        //           print("User accepted notifications: \(accepted)")
        //         })
                
        //END OneSignal initializataion code
        
 
        AppData.shared.resetAllData()
        
        //RemoteConfigManager.shared.getApplicationStatusFromRemoteConfig()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 108
        
        // setup singleton and SDKs
        self.registerNotificationObservers()
        self.setupServices()
        
        // keep a reference for re-use
        AppData.shared.application = application
        
//        //Moneysoft  Configure method goes here
//        let config = MoneysoftApiConfiguration.init(apiUrl: API_BASE_URL,
//                                                                    apiReferrer: API_REFERRER,
//                                                                    view: UIView(),
//                                                                    isDebug: true,
//                                                                    isBeta: true, serviceProvider: .EWISE);
//        MoneysoftApi.configure(config);
        

        let _ = VDotManager.shared //manish
//        
//        // to setup VDot again
//        if (launchOptions?[UIApplication.LaunchOptionsKey.location]) != nil {
//            let timestamp = Date().timeStamp()
//            LoggingUtil.shared.cWriteToFile(LoggingUtil.shared.fcmMsgFile, newText: "launch by location signal - \(timestamp)")
//            let _ = VDotManager.shared
//        }
        
        let fileContent = LoggingUtil.shared.printLocationFile(LoggingUtil.shared.fcmMsgFile)
        LoggingUtil.shared.cPrint(fileContent)
        
        // setup UI for nav
        AppConfig.shared.setupNavBarUI()
        

        
        // Firebase Message delegate
        //To receive registration tokens, implement the messaging delegate protocol and set FIRMessaging's delegate property after calling [FIRApp configure].
        Messaging.messaging().delegate = self
        // Setup Firebase remote config
        
        // setup FB SDK
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Dark these overided for text feilds
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

//        //Manish
//        AuthConfig.shared.activeManager.setupForRemoteNotifications(application, delegate: self)
        
        
        self.setupInitialViewController()
              
//        #if DEMO
//            self.setupSpendingViewController()
//        #else
//           self.setupInitialViewController()
//        #endif
        
//        self.setupIntroDevController()
//        self.setupInitDevController()
//        self.setupLogController()
//        self.setupQuestionController()
//        self.setupSplashController()
      
        return true
    }
}


// MARK: Register Notification Methods
extension AppDelegate {
    
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
        /*
        Swizzling disabled: mapping your APNs token and registration token
        If you have disabled method swizzling, you'll need to explicitly map your APNs token to the FCM registration token. Override the methods didRegisterForRemoteNotificationsWithDeviceToken to retrieve the APNs token, and then set FIRMessaging's APNSToken property:
         After the FCM registration token is generated, you can access it and listen for refresh events using the same methods as with swizzling enabled.
        */
        
        // assign apns device token to Firebase Messaging sdk
        Messaging.messaging().apnsToken = deviceToken
        
        // extract deviceToken into String and notify observers
        let apnsDeviceToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        LoggingUtil.shared.cPrint("apns \(apnsDeviceToken)")
        let _ = CKeychain.shared.setValue(CKey.apnsToken.rawValue, value: apnsDeviceToken)
        NotificationUtil.shared.notify(NotificationEvent.apnsDeviceToken.rawValue, key: NotificationUserInfoKey.token.rawValue, value: apnsDeviceToken)
    }
}


// MARK: Remote Notification
extension AppDelegate {
    
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
    }
    
    
    //MARK: UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        let userInfo = notification.request.content.userInfo
        LoggingUtil.shared.cPrint(userInfo)
        
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        LoggingUtil.shared.cPrint(userInfo)
        
        completionHandler()
    }
}

// MARK: Remote Notification handling
extension AppDelegate {
    
    ///When your app is in the background, iOS directs messages with the notification key to the system tray. A tap on a notification opens the app, and the content of the notification is passed to the didReceiveRemoteNotification callback in the AppDelegate.
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
            
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//          print("Message ID: \(messageID)")
//        }

        // Print full message.
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
                
                self.handleRemoteNotification(userInfo) {
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
    
    func handleRemoteNotification(_ data: [AnyHashable : Any], _ completion: @escaping ()->Void) {
        
//        let dateString = VDotManager.shared.dateFormatter.string(from: Date())
//        LoggingUtil.shared.cWriteToFile(LoggingUtil.shared.fcmMsgFile, newText: "\(dateString)")
//        LoggingUtil.shared.cWriteToFile(LoggingUtil.shared.fcmMsgFile,newText: "message received \(dateString)")
        
//        MoneySoftManager.shared.handleNotification(data).done { success in
//            LoggingUtil.shared.cPrint("handle notification success")
//        }.catch { err in
//            LoggingUtil.shared.cPrint("handle notification failed")
//            LoggingUtil.shared.cPrint(err.localizedDescription)
//        }.finally {
//            completion()
//        }
    }
}

// MARK: disable third party keyboard
extension AppDelegate {
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard {
            return false
        }
        return true
    }
}

// MARK: Segment
extension AppDelegate {
    
    func registerNotificationObservers() {
        
        // Event for programmatically logging out and returning to Registration screen
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogout(notification:)), name: NSNotification.Name(NotificationEvent.logout.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSwitch(notification:)), name: NSNotification.Name(UINotificationEvent.switchRoot.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSwitchToBankListFromHome(notification:)), name: NSNotification.Name(UINotificationEvent.switchRootToBank.rawValue), object: nil)
    }
    
    // trigger the first initiation of AppConfig singleton
    func setupServices() {
        guard let _ = AppData.shared.application else { return }
        //Fabric.with([Crashlytics.self])
        let _ = CheqAPIManager.shared
        let _ = AppConfig.shared
        let _ = AuthConfig.shared
        let _ = RemoteConfigManager.shared
    }
    
    func setupServicesForDev() {
        guard let _ = AppData.shared.application else { return }
        //Fabric.with([Crashlytics.self])
        let _ = CheqAPIManager.shared
        let _ = AppConfig.shared
        let _ = AuthConfig.shared
        let _ = RemoteConfigManager.shared
//      let _ = VDotManager.shared
//      AuthConfig.shared.activeManager.setupForRemoteNotifications(application, delegate: self)
    }
}

// MARK: unused
extension AppDelegate {
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if !self.visualEffectView.isDescendant(of: self.window!) {
            self.visualEffectView = AppConfig.shared.activeTheme.lightBlurEffectView
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
        
        AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
              AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
        }
        self.visualEffectView.removeFromSuperview()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        LoggingUtil.shared.cPrint("applicationDidBecomeActive")
        NotificationUtil.shared.notify(NotificationEvent.appBecomeActive.rawValue, key: "", value: "")
        self.visualEffectView.removeFromSuperview()
        
        AppEvents.activateApp()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


extension AppDelegate {

    func setupQuestionController() {
        self.setupServicesForDev()
        let vc = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.question.rawValue, embedInNav: false) as! QuestionViewController
        vc.viewModel.coordinator = BankAccountCoordinator()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    func setupSplashController() {
        self.setupServicesForDev()
        let vc = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.cSplash.rawValue, embedInNav: false)
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func setupInitDevController2 () {
        self.setupServicesForDev()
        let vc = AppNav.shared.initViewController(.employee) as! IntroductionViewController
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func setupIntroDevController() {
        self.setupServicesForDev()
        let vc = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.intro.rawValue, embedInNav: false) as! IntroductionViewController
        vc.viewModel.coordinator = SetupBankIntroCoordinator()
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func setupInitDevController () {
        self.setupServicesForDev()
        let vc = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.question.rawValue, embedInNav: false) as! QuestionViewController
        vc.viewModel.coordinator = CompanyNameCoordinator()
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
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
    
    func setupSpendingViewController() {
        self.setupServicesForDev()
//        let vc = AppNav.shared.initViewController(StoryboardName.main.rawValue, storyboardId: MainStoryboardId.spending.rawValue, embedInNav: true)
        window?.rootViewController = AppNav.shared.initTabViewController()
        window?.makeKeyAndVisible()
    }
}


// MARK: Custom Methods
extension AppDelegate {
    
    func setupInitialViewController() {
        
        if AppConfig.shared.isUserLoggedIn() {
            window?.rootViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.splashVC.rawValue, embedInNav: true)
            window?.makeKeyAndVisible()
        }else{
            self.handleNotLoggedIn()
//            let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
//            let vc = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.splashVC.rawValue)
//            self.window?.rootViewController = vc
//            self.window?.makeKeyAndVisible()
        }
        
//        AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
//            let vc = AppNav.shared.initViewController(.legalName)
//            self.window?.rootViewController = vc ?? UIViewController()
//            self.window?.makeKeyAndVisible()
//        }.catch { err in
//            self.handleNotLoggedIn()
//        }
        
    }
    
    @objc func handleSwitch(notification: NSNotification) {
        
        LoggingUtil.shared.cPrint("handle login")
        let dict = notification.userInfo?[NotificationUserInfoKey.vcInfo.rawValue] as? Dictionary<String, Any>
        let storyname = dict?[NotificationUserInfoKey.storyboardName.rawValue] as? String ?? ""
        let storyId = dict?[NotificationUserInfoKey.storyboardId.rawValue] as? String ?? ""
        guard storyname.isEmpty == false, storyId.isEmpty == false  else {
            LoggingUtil.shared.cPrint("err")
            return
        }
        
        AppData.shared.completingDetailsForLending = false
        // nav is embeded inside the viewcontrollers of tabbar
        window?.rootViewController = AppNav.shared.initViewController(storyname, storyboardId: storyId, embedInNav: false)
    }
    
    @objc func handleSwitchToBankListFromHome(notification: NSNotification) {
        LoggingUtil.shared.cPrint("Switch : go to bank")
    
        AppData.shared.completingDetailsForLending = false
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: MultipleChoiceViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.multipleChoice.rawValue) as! MultipleChoiceViewController
        let multipleChoiceViewModel = MultipleChoiceViewModel()
        multipleChoiceViewModel.coordinator = MultipleChoiceViewModel.coordinatorfor(.financialInstitutions)
        vc.viewModel = multipleChoiceViewModel
        vc.viewModel.screenName = ScreenName(fromRawValue: multipleChoiceViewModel.coordinator.coordinatorType.rawValue)
        vc.modalPresentationStyle = .fullScreen
        
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
    }
    

    @objc func handleLogout(notification: NSNotification) {
        LoggingUtil.shared.cPrint("handle logout")
        AppData.shared.resetAllData()
        AppData.shared.oneSignal_removeExternalUserId()
        AppConfig.shared.markUserLoggedOut()
        AppData.shared.completingDetailsForLending = false
        window?.rootViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.registration.rawValue, embedInNav: true)
    }
    
    func handleNotLoggedIn() {

        if !AppConfig.shared.isFirstInstall() {
            window?.rootViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.registration.rawValue, embedInNav: true)
        } else {
            window?.rootViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.cSplash.rawValue, embedInNav: true)
        }        
        self.window?.makeKeyAndVisible()
    }
}

