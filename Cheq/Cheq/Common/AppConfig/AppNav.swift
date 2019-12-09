//
//  AppNav.swift
//  Cheq
//
//  Created by Xuwei Liang on 18/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import Onfido
import MobileSDK

/**
 AppNav is Singleton class which contains all our viewController intialisation and navigation logics. So we don't have adhoc code scatter everywhere. This class is the single place for viewController initialisation and navigation.
 */
class AppNav {
    
    /// Minutes before passcode screen displays, when user is idle for 5 minutes without updating last active timestamp, then we display the passcode sceen lock
    let minsToShowPasscode = 5
    
    /// For every 30 seconds, we check if idle time have expired **minsToShowPasscode**
    let appLastActiveTimestampCheckInterval = 30
    
    /// timer instance for doing idle activity checks
    var timer: Timer?
    
    /// Singleton instance of AppNav
    static let shared = AppNav()
    
    private init() {
        /// Event for programmatically for app becoming active
        /// Check if we need to show the passcode screen if passcode is setup
        NotificationCenter.default.addObserver(self, selector: #selector(showPasscodeIfNeeded(notification:)), name: NSNotification.Name(NotificationEvent.appBecomeActive.rawValue), object: nil)
    }
    
    /// This method gets called whenever app is active again, then we check if passcode is setup, if so, has user been idle for more than the **minsToShowPasscode** threshold. If user has been idle for more than **minsToShowPasscode** threshold, then **presentPasscodeViewController** is called.
    @objc func showPasscodeIfNeeded(notification: NSNotification) {
        if passcodeExist(), isTimeToShowPasscode(), AuthConfig.shared.activeUser != nil {
            presentPasscodeViewController()
        }
    }
    
    /// Helper method used by **showPasscodeIfNeeded** which if user has been idle long enough to show passcode
    func isTimeToShowPasscode()->Bool {
        let now = Date()
        let earlier = CKeychain.shared.dateByKey(CKey.activeTime.rawValue)
        let minsEarlier = earlier.minutesEarlier(than: now)
        if minsEarlier >= minsToShowPasscode {
            let _ = CKeychain.shared.setDate(CKey.activeTime.rawValue, date: now)
            return true
        }
        return false
    }
    
    /// method to clear passcode from keychain
    func emptyPasscode() {
        let _ = CKeychain.shared.setValue(CKey.passcodeLock.rawValue, value: "")
        let _ = CKeychain.shared.setValue(CKey.confirmPasscodeLock.rawValue, value: "")
    }
    
    /// checks if passcode has been setup in keychain
    func passcodeExist()-> Bool {
        let passcode = CKeychain.shared.getValueByKey(CKey.confirmPasscodeLock.rawValue)
        return !passcode.isEmpty
    }

    /**
     pushToQuestionForm abstract the logics to initialise a new **QuestionViewController** based on **QuestionType** and performs a navigation push from given ViewController
     - parameter questionType: QuestionType determines how **QuestionViewController** renders the to the corresponding screen.
     - parameter viewController: the current source viewController for the navigation action
     */
    func pushToQuestionForm(_ questionType: QuestionType, viewController: UIViewController) {
        guard let nav = viewController.navigationController else { return }
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: QuestionViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.question.rawValue) as! QuestionViewController
        let questionViewModel = QuestionViewModel()
        questionViewModel.loadSaved()
        questionViewModel.coordinator = QuestionViewModel.coordinatorFor(questionType)
        vc.viewModel = questionViewModel
        vc.viewModel.screenName = ScreenName(fromRawValue: questionType.rawValue)
        nav.pushViewController(vc, animated: true)
    }
    
    /**
    pushToMultipleChoice abstract the logics to initialise a new **MultipleChoiceViewController** based on **MultipleChoiceQuestionType** and performs a navigation push from given ViewController
    - parameter multipleChoiceType: MultipleChoiceQuestionType determines how **MultipleChoiceViewController** renders the to the corresponding screen.
    - parameter viewController: the current source viewController for the navigation action
    */
    func pushToMultipleChoice(_ multipleChoiceType: MultipleChoiceQuestionType, viewController: UIViewController) {
        guard let nav = viewController.navigationController else { return }
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: MultipleChoiceViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.multipleChoice.rawValue) as! MultipleChoiceViewController
        let multipleChoiceViewModel = MultipleChoiceViewModel()
        multipleChoiceViewModel.coordinator = MultipleChoiceViewModel.coordinatorfor(multipleChoiceType)
        vc.viewModel = multipleChoiceViewModel
        vc.viewModel.screenName = ScreenName(fromRawValue: multipleChoiceViewModel.coordinator.coordinatorType.rawValue)
        nav.pushViewController(vc, animated: true)
    }
    
    /**
    Dynamic form view UI is driven by **FinancialInstitutionModel**. Push to dynamic form view for linking bank account using MoneySoft SDK
     - parameter institutionModel: FinancialInstitutionModel is retrieved from selecting the destination bank/institution
     - parameter viewController: The source viewController for current navigation action
     */
    func pushToDynamicForm(_ institutionModel: FinancialInstitutionModel, viewController: UIViewController) {
        guard let nav = viewController.navigationController else { return }
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: DynamicFormViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.dynamic.rawValue) as! DynamicFormViewController
        vc.viewModel.screenName = .bankLogin
        nav.pushViewController(vc, animated: true)
    }
    
    /**
     Introduction screen is a common UI pattern across the app. Use the same method to present same UI patterns across the app.
     - parameter introductionType: IntroductionType drives the appearance for **IntroductionViewController**
     - parameter viewController: The source viewController for current navigation action
     */
    func pushToIntroduction(_ introductionType: IntroductionType, viewController: UIViewController) {
        guard let nav = viewController.navigationController else { return }
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: IntroductionViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.intro.rawValue) as! IntroductionViewController
        let introductionViewModel = IntroductionViewModel()
        introductionViewModel.coordinator = IntroductionViewModel.coordinatorFor(introductionType)
        vc.viewModel = introductionViewModel
        nav.pushViewController(vc, animated: true)
    }
    
    /**
     SpendingViewController is reused for different scenarios of displaying spending data. Use **SpendingVCType** to drive how the UI on **SpendingViewController**
     - parameter spendingVCType: **SpendingVCType** supports scenarios for overview, categories list, specific category and transactions list
     - parameter viewController: The source viewController for current navigation action
     */
    func pushToSpendingVC(_ spendingVCType: SpendingVCType, viewController: UIViewController) {
        guard let nav = viewController.navigationController else { return }
        let storyboard = UIStoryboard(name: StoryboardName.main.rawValue, bundle: Bundle.main)
        switch spendingVCType {
        case .overview:
            let vc: SpendingViewController = storyboard.instantiateViewController(withIdentifier: MainStoryboardId.spending.rawValue) as! SpendingViewController
            nav.pushViewController(vc, animated: true)
        case .categories:
            let vc: SpendingCategoriesViewController = storyboard.instantiateViewController(withIdentifier: MainStoryboardId.spendingCategories.rawValue) as! SpendingCategoriesViewController
            nav.pushViewController(vc, animated: true)
        case .specificCategory:
            let vc: SpendingSpecificCategoryViewController = storyboard.instantiateViewController(withIdentifier: MainStoryboardId.spendingCategoryById.rawValue) as! SpendingSpecificCategoryViewController
            nav.pushViewController(vc, animated: true)
        case .transactions:
            let vc: SpendingTransactionsViewController = storyboard.instantiateViewController(withIdentifier: MainStoryboardId.spendingTransactions.rawValue) as! SpendingTransactionsViewController
            nav.pushViewController(vc, animated: true)
        }
    }
    
    /**
     pushToInAppWeb opens a given URL using our own in-app webView
     parameter url: URL is the location we want to open with in-app webview
     parameter viewController: The source viewController for current navigation action
     */
    func pushToInAppWeb(_ url: URL, viewController: UIViewController) {
        guard let nav = viewController.navigationController else { return }
        let storyboard = UIStoryboard(name: StoryboardName.common.rawValue, bundle: Bundle.main)
        let webVC = storyboard.instantiateViewController(withIdentifier: CommonStoryboardId.web.rawValue) as! WebViewController
        webVC.viewModel.url = url.absoluteString
        nav.pushViewController(webVC, animated: true)
    }
    
    
    /**
     pushToViewController abstracts the logic to initialise a viewController by **storyboardName** and **storyboardId** and push it from a given viewController
     - parameter storyboardName: extract storyboardName String from **StoryboardEnums**
     - parameter storyboardId: extract storyboardId String from **OnboardingStoryboardId**, **MainStoryboardId** and **CommonStoryboardId**
     */
    func pushToViewController(_ storyboardName: String, storyboardId: String, viewController: UIViewController) {
        guard let nav =  viewController.navigationController else { return }
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId)
        nav.pushViewController(vc, animated: true)
    }
    
    /**
     a different flavor for **pushToViewController** where we simply provided the initialised viewController
     - parameter newVc: intialised viewController as destination for current navigation action
     - parameter from: current existing source viewController
     */
    func pushToViewController(_ newVc: UIViewController, from: UIViewController) {
        guard let nav =  from.navigationController else { return }
        nav.pushViewController(newVc, animated: true)
    }
    
    /**
     method to open App's setting screen
     */
    func pushToAppSetting() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    /**
     method to open App's location setting screen. But **App-Prefs:root** is not allowed to be use officially by Apple
     */
    func pushToAppLocationServices() {
        guard let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: present related
extension AppNav {
    
    /**
     initialises a new **QuestionViewController**
     - parameter questionType: **QuestionType** will drive the appearance of QuestionViewController
     */
    func initViewController(_ questionType: QuestionType)->UIViewController? {
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        guard let vc: QuestionViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.question.rawValue) as? QuestionViewController else { return nil }
        vc.viewModel.coordinator = QuestionViewModel.coordinatorFor(questionType)
        return vc 
    }
    
    /**
     initialise a new **IntroductionViewController**
     - parameter introType: **IntroductionType** will drive how we initialise the viewController
     */
    func initViewController(_ introType: IntroductionType)-> UIViewController? {
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        guard let vc: IntroductionViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.intro.rawValue) as? IntroductionViewController else { return nil }
        vc.viewModel.coordinator = IntroductionViewModel.coordinatorFor(introType)
        return vc
    }
    
    /**
     After onboarding/login process, the app's main view controllers is embedded inside tabs. We use **initTabViewController** to initialise the parent tab view controller.
     */
    func initTabViewController()-> UIViewController {
        let storyboard = UIStoryboard(name: StoryboardName.main.rawValue, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: MainStoryboardId.tab.rawValue)
        return vc 
    }
    
    /**
     initViewController allows initialisation of viewController by **StoryboardEnums** and choose whether the viewController is embeded inside navigation controller or not with a boolean parameter.
     - parameter storyboardName: Storyboard name from **StoryboardName** enums rawValues
     - parameter storyboardId:
     - parameter embedInNav:
     */
    func initViewController(_ storyboardName: String, storyboardId: String, embedInNav: Bool)-> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId)
        if embedInNav {
            let nav = UINavigationController(rootViewController: vc)
            return nav
        } else {
            return vc
        }
    }
    
    func presentViewController(_ storyboardName: String, storyboardId: String, viewController: UIViewController) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId)
        let nav = UINavigationController(rootViewController: vc)
        viewController.present(nav, animated: true)
    }

    func presentDeclineViewController(_ declineReason: DeclineDetail.DeclineReason, viewController: UIViewController) {
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: IntroductionViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.intro.rawValue) as! IntroductionViewController
        let introductionViewModel = IntroductionViewModel()
        let introType = IntroductionViewModel.introTypeFromDeclineReason(declineReason) ?? IntroductionType.noPayCycle
        let introCoordinator = IntroductionViewModel.coordinatorFor(introType)
        introductionViewModel.coordinator = introCoordinator
        vc.viewModel = introductionViewModel
        let nav = UINavigationController(rootViewController: vc)
        viewController.present(nav, animated: true, completion: nil)
    }
    
    func presentIntroduction(_ introductionType: IntroductionType, viewController: UIViewController) {
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: IntroductionViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.intro.rawValue) as! IntroductionViewController
        let introductionViewModel = IntroductionViewModel()
        let introCoordinator = IntroductionViewModel.coordinatorFor(introductionType)
        introductionViewModel.coordinator = introCoordinator
        vc.viewModel = introductionViewModel
        let nav = UINavigationController(rootViewController: vc)
        viewController.present(nav, animated: true, completion: nil)
    }
    
    func presentPasscodeViewController() {
        let storyboard = UIStoryboard(name: StoryboardName.common.rawValue, bundle: Bundle.main)
        let vc: PasscodeViewController = storyboard.instantiateViewController(withIdentifier: CommonStoryboardId.passcode.rawValue) as! PasscodeViewController
        vc.viewModel.type = .validate
        guard let currentRootVc = UIApplication.shared.keyWindow!.rootViewController else { return }
        currentRootVc.present(vc, animated: true, completion: nil)
    }
    
    func presentToQuestionForm(_ questionType: QuestionType, viewController: UIViewController) {
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: QuestionViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.question.rawValue) as! QuestionViewController
        let questionViewModel = QuestionViewModel()
        questionViewModel.coordinator = QuestionViewModel.coordinatorFor(questionType)
        vc.viewModel = questionViewModel
        let nav = UINavigationController(rootViewController: vc)
        viewController.present(nav, animated: true, completion: nil)
    }
    
    func presentToMultipleChoice(_ multipleChoiceType: MultipleChoiceQuestionType, viewController: UIViewController) {
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: MultipleChoiceViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.multipleChoice.rawValue) as! MultipleChoiceViewController
        let multipleChoiceViewModel = MultipleChoiceViewModel()
        multipleChoiceViewModel.coordinator = MultipleChoiceViewModel.coordinatorfor(multipleChoiceType)
        vc.viewModel = multipleChoiceViewModel
        vc.viewModel.screenName = ScreenName(fromRawValue: multipleChoiceViewModel.coordinator.coordinatorType.rawValue)
        let nav = UINavigationController(rootViewController: vc)
        viewController.present(nav, animated: true, completion: nil)
    }
}

// MARK: KYC
extension AppNav {
    func navigateToKYCFlow(_ type: KycDocType, viewController: UIViewController) {
        let sdkToken = AppData.shared.loadOnfidoSDKToken()
        guard sdkToken.isEmpty == false else {
            viewController.showMessage("Sdk token must be available", completion: nil)
            return
        }
        
        LoggingUtil.shared.cPrint("KYC flow")
        let appearance = Appearance(primaryColor: AppConfig.shared.activeTheme.primaryColor, primaryTitleColor: AppConfig.shared.activeTheme.altTextColor, primaryBackgroundPressedColor: AppConfig.shared.activeTheme.textBackgroundColor, secondaryBackgroundPressedColor: AppConfig.shared.activeTheme.textBackgroundColor, fontRegular: AppConfig.shared.activeTheme.defaultFont.fontName, fontBold: AppConfig.shared.activeTheme.mediumFont.fontName, supportDarkMode: false )
        let docType: DocumentType = (type == .Passport) ? DocumentType.passport : DocumentType.drivingLicence
        let config = try! OnfidoConfig.builder()
            .withAppearance(appearance)
            .withSDKToken(AppData.shared.onfidoSdkToken)
            .withWelcomeStep()
            .withDocumentStep(ofType: docType, andCountryCode: CountryCode.AU.rawValue)
            .withFaceStep(ofVariant: .photo(withConfiguration: nil))
            .build()
        
        let onfidoFlow = OnfidoFlow(withConfiguration: config)
            .with(responseHandler: { results in
                switch results {
                case .success(_):
                    CheqAPIManager.shared.putKycCheck().done {
                        LoggingUtil.shared.cPrint("kyc checked")
                        guard AppData.shared.completingDetailsForLending else { return }
                        viewController.dismiss(animated: true, completion:nil)
                        }.catch{ err in
                            let error = err
                            guard AppData.shared.completingDetailsForLending else {
                                return
                            }
                            viewController.dismiss(animated: true, completion: {
                                NotificationUtil.shared.notify(UINotificationEvent.showError.rawValue, key: "", object: error)
                            })
                    }
                    
                case let OnfidoResponse.error(err):
                    switch err {
                    case OnfidoFlowError.cameraPermission:
                        LoggingUtil.shared.cPrint("cameraPermission")
                    case OnfidoFlowError.failedToWriteToDisk:
                        LoggingUtil.shared.cPrint("failedToWriteToDisk")
                    case OnfidoFlowError.microphonePermission:
                        LoggingUtil.shared.cPrint("microphonePermission")
                    case OnfidoFlowError.upload(_):
                        LoggingUtil.shared.cPrint("upload")
                    default: LoggingUtil.shared.cPrint(err)
                    }
                default: break
                }
            })
        
        do {
            let onfidoRun = try onfidoFlow.run()
            viewController.present(onfidoRun, animated: true) { }
        } catch let err {
            LoggingUtil.shared.cPrint(err)
            viewController.showError(err, completion: nil)
        }
    }
}

// MARK: smart dimiss
extension AppNav {
    
    func rootViewController()-> UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController ?? UIViewController()
    }
    
    func dismissModal(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        guard let presentVc = viewController.presentingViewController else { return }
        presentVc.dismiss(animated: true) {
            NotificationUtil.shared.notify(NotificationEvent.dismissKeyboard.rawValue, key: "", value: "")
            if let cb = completion {
                cb()
            }
        }
    }
    
    func dismiss(_ viewController: UIViewController) {
        if let nav = viewController.navigationController {
            NotificationUtil.shared.notify(NotificationEvent.dismissKeyboard.rawValue, key: "", value: "")
            nav.popViewController(animated: true)
            return
        }
        
        if viewController.isModal {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}
