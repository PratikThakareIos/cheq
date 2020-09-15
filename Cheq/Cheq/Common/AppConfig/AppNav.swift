//
//  AppNav.swift
//  Cheq
//
//  Created by Xuwei Liang on 18/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import Onfido
//import MobileSDK

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
            //manish
            // presentPasscodeViewController()
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
        
        if multipleChoiceType == .onDemand {
            vc.showNextButton = true
        }
        
        vc.modalPresentationStyle = .fullScreen
        nav.pushViewController(vc, animated: true)
    }
    
    /**
     Dynamic form view UI is driven by **GetFinancialInstitution**. Push to dynamic form view for linking bank account using MoneySoft SDK
     - parameter institutionModel: GetFinancialInstitution is retrieved from selecting the destination bank/institution
     - parameter viewController: The source viewController for current navigation action
     */
    func pushToDynamicForm(_ institutionModel: GetFinancialInstitution, response : GetUserActionResponse?, viewController: UIViewController) {
        guard let nav = viewController.navigationController else { return }
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: DynamicFormViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.dynamic.rawValue) as! DynamicFormViewController
        vc.resGetUserActionResponse = response
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
    
    func pushToSetupBank(_ introductionType: IntroductionType, viewController: UIViewController) {
        guard let nav = viewController.navigationController else { return }
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: SetupBankVC = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.setupBankVC.rawValue) as! SetupBankVC
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
        webVC.hidesBottomBarWhenPushed = true
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
    
    func pushToViewControllerWithAnimation(_ storyboardName: String, storyboardId: String, viewController: UIViewController) {
        guard let nav =  viewController.navigationController else { return }
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId)
        
        
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade;
        transition.subtype = CATransitionSubtype.fromTop;
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        nav.view.layer.add(transition, forKey: "kCATransition")
        nav.pushViewController(vc, animated: false)
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
     - parameter storyboardId: storyboard id rawValue from **OnboardingStoryboardId**, **MainStoryboardId**, **CommonStoryboardId** or from any future storyboard id group
     - returns: the initialised viewController
     */
    func initViewController(_ storyboardName: String, storyboardId: String, embedInNav: Bool)-> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId)
        //        if storyboardId == CommonStoryboardId.connecting.rawValue {
        //            let nav = UINavigationController(rootViewController: vc)
        //            nav.modalPresentationStyle = .fullScreen
        //            vc.present(nav, animated: true)
        //        }
        if embedInNav {
            let nav = UINavigationController(rootViewController: vc)
            return nav
        } else {
            return vc
        }
    }
    
    /**
     presents a viewController instantiate by storyboard name, storyboard id
     - parameter storyboardName: Storyboard name from **StoryboardName** enums rawValues
     - parameter storyboardId: storyboard id rawValue from **OnboardingStoryboardId**, **MainStoryboardId**, **CommonStoryboardId** or from any future storyboard id group
     - parameter viewController:
     */
    func presentViewController(_ storyboardName: String, storyboardId: String, viewController: UIViewController, embedInNav: Bool, animated: Bool = true) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId)
        
        if embedInNav {
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            viewController.present(nav, animated: animated)
        } else {
            vc.modalPresentationStyle = .fullScreen
            viewController.present(vc, animated: animated)
        }
    }
    
    /**
     present **decline** viewController is actually initialising **IntroductionViewController** based on provided **declineReason** enum. **presentDeclineViewController** is actually a special case for presenting **IntroductionViewController**
     - parameter declineReason: **DeclineDetail.DeclineReason** the enum mapping to the corresponding decline message.
     */
    func presentDeclineViewController(_ declineReason: DeclineDetail.DeclineReason, viewController: UIViewController) {
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: IntroductionViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.intro.rawValue) as! IntroductionViewController
        
        
        let introductionViewModel = IntroductionViewModel()
        let introType = IntroductionViewModel.introTypeFromDeclineReason(declineReason) ?? IntroductionType.noPayCycle
        let introCoordinator = IntroductionViewModel.coordinatorFor(introType)
        introductionViewModel.coordinator = introCoordinator
        vc.viewModel = introductionViewModel
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        viewController.present(nav, animated: true, completion: nil)
    }
    
    /**
     present a introduction view controller, this leverages on top of initialisation helper method
     - parameter introductionType: **IntroductionType** which determines which coordinator to use for driving the appearance and behaviour of the viewController
     - parameter viewController: current source viewController for the navigation action
     */
    func presentIntroduction(_ introductionType: IntroductionType, viewController: UIViewController) {
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: IntroductionViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.intro.rawValue) as! IntroductionViewController
        let introductionViewModel = IntroductionViewModel()
        let introCoordinator = IntroductionViewModel.coordinatorFor(introductionType)
        introductionViewModel.coordinator = introCoordinator
        vc.viewModel = introductionViewModel
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        viewController.present(nav, animated: true, completion: nil)
    }
    
    /**
     Present the passcode lock viewController
     */
    func presentPasscodeViewController() {
        let storyboard = UIStoryboard(name: StoryboardName.common.rawValue, bundle: Bundle.main)
        let vc: PasscodeViewController = storyboard.instantiateViewController(withIdentifier: CommonStoryboardId.passcode.rawValue) as! PasscodeViewController
        vc.viewModel.type = .validate
        guard let currentRootVc = UIApplication.shared.keyWindow!.rootViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        currentRootVc.present(vc, animated: true, completion: nil)
    }
    
    /**
     Present a question view controller. Built on top of the initialisation helper method for **QuestionViewController**
     - parameter questionType: QuestionType which drives the appearance of the **QuestionViewController**
     - parameter viewController: the source viewController of the current navigation action
     */
    func presentToQuestionForm(_ questionType: QuestionType, viewController: UIViewController) {
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: QuestionViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.question.rawValue) as! QuestionViewController
        let questionViewModel = QuestionViewModel()
        questionViewModel.coordinator = QuestionViewModel.coordinatorFor(questionType)
        vc.viewModel = questionViewModel
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        viewController.present(nav, animated: true, completion: nil)
    }
    
    /**
     Present a multiple choice view controller. Built on top of the initialisation helper method for **MultipleChoiceViewController**
     - parameter multipleChoiceType: MultipleChoiceQuestionType which drives the appearance of the **MultipleChoiceViewController**
     - parameter viewController: source viewController of the current navigation action
     */
    func presentToMultipleChoice(_ multipleChoiceType: MultipleChoiceQuestionType, viewController: UIViewController) {
         LoggingUtil.shared.cPrint(multipleChoiceType)
        
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: MultipleChoiceViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.multipleChoice.rawValue) as! MultipleChoiceViewController
        
        let multipleChoiceViewModel = MultipleChoiceViewModel()
        multipleChoiceViewModel.coordinator = MultipleChoiceViewModel.coordinatorfor(multipleChoiceType)
        vc.viewModel = multipleChoiceViewModel
        vc.viewModel.screenName = ScreenName(fromRawValue: multipleChoiceViewModel.coordinator.coordinatorType.rawValue)
        
        
        if multipleChoiceType == .employmentType {
            vc.showNextButton = true
        }else {
            vc.showNextButton = false
        }
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        viewController.present(nav, animated: true, completion: nil)

    }
    
    func presentPreviewLoanViewController(viewController: UIViewController) {

        let storyboard = UIStoryboard(name: StoryboardName.main.rawValue, bundle: Bundle.main)
        let vc: PreviewLoanViewController = storyboard.instantiateViewController(withIdentifier: MainStoryboardId.preview.rawValue) as! PreviewLoanViewController

        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        viewController.present(nav, animated: true, completion: nil)
    }
    
    func presentIdentityVerificationView(viewController: UIViewController){
        
        let storyboard = UIStoryboard(name: StoryboardName.common.rawValue, bundle: Bundle.main)
        let vc: IdentityVerificationVC = storyboard.instantiateViewController(withIdentifier: CommonStoryboardId.identityVerificationVC.rawValue) as! IdentityVerificationVC
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        viewController.present(nav, animated: true, completion: nil)
    }
    
    func presentUserVerificationDetailsView(viewController: UIViewController){
        
        let storyboard = UIStoryboard(name: StoryboardName.common.rawValue, bundle: Bundle.main)
        let vc: UserVerificationDetailsVC = storyboard.instantiateViewController(withIdentifier: CommonStoryboardId.userVerificationDetailsVC.rawValue) as! UserVerificationDetailsVC
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        viewController.present(nav, animated: true, completion: nil)
    }
    
    func pushUserVerificationDetailsView(viewController: UIViewController) {
        pushToViewController(StoryboardName.common.rawValue,
                             storyboardId: CommonStoryboardId.userVerificationDetailsVC.rawValue,
                             viewController: viewController)
    }

}

// MARK: KYC
extension AppNav {
    
    /**
     Helper method to initiate KYC flow using the onfido SDK
     - parameter type: **KycDocType** can be driver's licence or passport. **navigateToKYCFlow** takes in the user's decision on which document type is used for KYC flow.
     - parameter viewController: source viewController of the navigation action
     */
    func navigateToKYCFlow(_ type: KycDocType, viewController: UIViewController) {
        
        /// fetching the sdkToken from AppData helper method using **loadOnfidoSDKToken**
        let sdkToken = AppData.shared.loadOnfidoSDKToken()
        guard sdkToken.isEmpty == false else {
            /// if the sdk token is empty, then the logic cannot continue
            viewController.showMessage("Sdk token must be available", completion: nil)
            return
        }
        
        LoggingUtil.shared.cPrint("KYC flow")

        let appearance = Appearance(
         primaryColor:  AppConfig.shared.activeTheme.primaryColor,
         primaryTitleColor: AppConfig.shared.activeTheme.altTextColor,
         primaryBackgroundPressedColor: AppConfig.shared.activeTheme.textBackgroundColor,
         supportDarkMode : true)
        
        //let docType: DocumentType = (type == .Passport) ? DocumentType.passport : DocumentType.drivingLicence
        let drivingLicenceConfiguration = DrivingLicenceConfiguration.init(country: CountryCode.AU.rawValue)
        let docType: DocumentType = (type == .passport) ? DocumentType.passport(config: nil) : DocumentType.drivingLicence(config: drivingLicenceConfiguration)
        
        let config = try! OnfidoConfig.builder()
                  .withAppearance(appearance)
                  .withSDKToken(AppData.shared.onfidoSdkToken)
                  .withWelcomeStep()
                  .withDocumentStep(ofType: docType)
                  .withFaceStep(ofVariant: .photo(withConfiguration: nil))
                  .build()
        
//        let config = try! OnfidoConfig.builder()
//            .withAppearance(appearance)
//            .withSDKToken(AppData.shared.onfidoSdkToken)
//            .withWelcomeStep()
//            .withDocumentStep(ofType: docType, andCountryCode: CountryCode.AU.rawValue)
//            .withFaceStep(ofVariant: .photo(withConfiguration: nil))
//            .build()
        
        /// define the handling of the end of Onfido flow
        let onfidoFlow = OnfidoFlow(withConfiguration: config)
            .with(responseHandler: { results in
                switch results {
                /// successful case
                case .success(_):
                    
                    //SDK flow has been completed successfully
                    AppConfig.shared.showSpinner()
                    CheqAPIManager.shared.putKycCheck().done {
                        AppConfig.shared.hideSpinner {
                            LoggingUtil.shared.cPrint("kyc checked")
                            guard AppData.shared.completingDetailsForLending else { return }
                            
                            NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
                            AppNav.shared.dismissModal(viewController){}
                            
                            //viewController.dismiss(animated: true, completion:nil)
                        }
                    }.catch{ err in
                        
                        AppConfig.shared.hideSpinner {
                            let error = err
                            guard AppData.shared.completingDetailsForLending else {
                                return
                            }
                            viewController.dismiss(animated: true, completion: {
                                NotificationUtil.shared.notify(UINotificationEvent.showError.rawValue, key: "", object: error)
                            })
                            
                        }
                    }
                    
                    
                /// error case handling
                case let OnfidoResponse.error(err):
                    switch err {
                        case OnfidoFlowError.cameraPermission:
                            LoggingUtil.shared.cPrint("OnfidoFlowError.cameraPermission")
                        
                        case OnfidoFlowError.failedToWriteToDisk:
                            LoggingUtil.shared.cPrint("nfidoFlowError.failedToWriteToDisk")
                        
                        case OnfidoFlowError.microphonePermission:
                            LoggingUtil.shared.cPrint("OnfidoFlowError.microphonePermission")
                        
                        case OnfidoFlowError.upload(_):
                            LoggingUtil.shared.cPrint("OnfidoFlowError.upload")
                        
                        case OnfidoFlowError.exception(withError: let error, withMessage: let message):
                           LoggingUtil.shared.cPrint(error ?? "")
                           LoggingUtil.shared.cPrint(message ?? "")
                                                
                        default: LoggingUtil.shared.cPrint(err)
                    }
                    
                case OnfidoResponse.cancel:
                    LoggingUtil.shared.cPrint("flow canceled by user")
                                        
                default: break
                }
            })
        
       
        /// presenting onfido viewController to start the flow
        do {
            let onfidoRun = try onfidoFlow.run()
            /*
             Supported presentation styles are:
             For iPhones: .fullScreen
             For iPads: .fullScreen and .formSheet
             */
            var modalPresentationStyle: UIModalPresentationStyle = .fullScreen
            // due to iOS 13 you must specify .fullScreen as the default is now .pageSheet
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                modalPresentationStyle = .formSheet // to present modally on iPads
            }
            
            onfidoRun.modalPresentationStyle = modalPresentationStyle
            viewController.present(onfidoRun, animated: true) { }
        } catch let err {
            // cannot execute the flow
            LoggingUtil.shared.cPrint(err)
            viewController.showError(err, completion: nil)
            
            switch err {
                case OnfidoFlowError.cameraPermission:
                    LoggingUtil.shared.cPrint("OnfidoFlowError.cameraPermission")
                
                case OnfidoFlowError.failedToWriteToDisk:
                    LoggingUtil.shared.cPrint("nfidoFlowError.failedToWriteToDisk")
                
                case OnfidoFlowError.microphonePermission:
                    LoggingUtil.shared.cPrint("OnfidoFlowError.microphonePermission")
                
                case OnfidoFlowError.upload(_):
                    LoggingUtil.shared.cPrint("OnfidoFlowError.upload")
                
                case OnfidoFlowError.exception(withError: let error, withMessage: let message):
                   LoggingUtil.shared.cPrint(error ?? "")
                   LoggingUtil.shared.cPrint(message ?? "")
                                        
                default: LoggingUtil.shared.cPrint(err)
            }
            
            //Onfido.OnfidoFlowError.cameraPermission
        }
    }
}

// MARK: smart dimiss
extension AppNav {
    
    /**
     Returns the current **rootViewController** if it exists
     returns: rootviewController or dummy viewController to avoid returning nil
     */
    func rootViewController()-> UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController ?? UIViewController()
    }
    
    /**
     dismissModal abstracts the dismiss of currently presenting viewController from the given viewController as well as handling the dimissal of any keyboards on display
     - parameter viewController: source viewController of current action 
     - parameter completion: completion callback closure, it can be nil if we don't need it
     */
    func dismissModal(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        guard let presentVc = viewController.presentingViewController else { return }
        presentVc.dismiss(animated: true) {
            NotificationUtil.shared.notify(NotificationEvent.dismissKeyboard.rawValue, key: "", value: "")
            if let cb = completion {
                cb()
            }
        }
    }
    
    /**
     pop the current viewController from navigation controller
     - parameter viewController: source viewController of current action
     */
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



/*
func cameraSelected() {
    // First we check if the device has a camera (otherwise will crash in Simulator - also, some iPod touch models do not have a camera).
    if let deviceHasCamera = UIImagePickerController.isSourceTypeAvailable(.camera) {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authStatus {
            case .authorized:
                showCameraPicker()
            case .denied:
                alertPromptToAllowCameraAccessViaSettings()
            case .notDetermined:
                permissionPrimeCameraAccess()
            default:
                permissionPrimeCameraAccess()
        }
    } else {
        let alertController = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            Analytics.track(event: .permissionsPrimeCameraNoCamera)
        })
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}


func alertPromptToAllowCameraAccessViaSettings() {
    let alert = UIAlertController(title: "\"<Your App>\" Would Like To Access the Camera", message: "Please grant permission to use the Camera so that you can  <customer benefit>.", preferredStyle: .alert )
    alert.addAction(UIAlertAction(title: "Open Settings", style: .cancel) { alert in
        Analytics.track(event: .permissionsPrimeCameraOpenSettings)
        if let appSettingsURL = NSURL(string: UIApplicationOpenSettingsURLString) {
          UIApplication.shared.openURL(appSettingsURL)
        }
    })
    present(alert, animated: true, completion: nil)
}


func permissionPrimeCameraAccess() {
    let alert = UIAlertController( title: "\"<Your App>\" Would Like To Access the Camera", message: "<Your App> would like to access your Camera so that you can <customer benefit>.", preferredStyle: .alert )
    let allowAction = UIAlertAction(title: "Allow", style: .default, handler: { (alert) -> Void in
        Analytics.track(event: .permissionsPrimeCameraAccepted)
        if AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count > 0 {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { [weak self] granted in
                DispatchQueue.main.async {
                    self?.cameraSelected() // try again
                }
            })
        }
    })
    alert.addAction(allowAction)
    let declineAction = UIAlertAction(title: "Not Now", style: .cancel) { (alert) in
        Analytics.track(event: .permissionsPrimeCameraCancelled)
    }
    alert.addAction(declineAction)
    present(alert, animated: true, completion: nil)
}


func showCameraPicker() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.modalPresentationStyle = UIModalPresentationStyle.currentContext
    picker.allowsEditing = false
    picker.sourceType = UIImagePickerControllerSourceType.camera
    present(picker, animated: true, completion: nil)
}
*/
