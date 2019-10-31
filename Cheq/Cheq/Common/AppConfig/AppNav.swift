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

class AppNav {
    let minsToShowPasscode = 5
    let appLastActiveTimestampCheckInterval = 30
    var timer: Timer?
    static let shared = AppNav()
    private init() {
        // Event for programmatically for app becoming active
        // Check if we need to show the passcode screen if passcode is setup
        NotificationCenter.default.addObserver(self, selector: #selector(showPasscodeIfNeeded(notification:)), name: NSNotification.Name(NotificationEvent.appBecomeActive.rawValue), object: nil)
    }
    
    @objc func showPasscodeIfNeeded(notification: NSNotification) {
        if passcodeExist(), isTimeToShowPasscode(), AuthConfig.shared.activeUser != nil {
            presentPasscodeViewController()
        }
    }
    
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
    
    func emptyPasscode() {
        let _ = CKeychain.shared.setValue(CKey.passcodeLock.rawValue, value: "")
        let _ = CKeychain.shared.setValue(CKey.confirmPasscodeLock.rawValue, value: "")
    }
    
    func passcodeExist()-> Bool {
        let passcode = CKeychain.shared.getValueByKey(CKey.confirmPasscodeLock.rawValue)
        return !passcode.isEmpty
    }

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
    
    // Dynamic form view for linking bank account using MoneySoft SDK
    func pushToDynamicForm(_ institutionModel: FinancialInstitutionModel, viewController: UIViewController) {
        guard let nav = viewController.navigationController else { return }
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: DynamicFormViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.dynamic.rawValue) as! DynamicFormViewController
        vc.viewModel.screenName = .bankLogin
        nav.pushViewController(vc, animated: true)
    }
    
    func pushToIntroduction(_ introductionType: IntroductionType, viewController: UIViewController) {
        guard let nav = viewController.navigationController else { return }
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: IntroductionViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.intro.rawValue) as! IntroductionViewController
        let introductionViewModel = IntroductionViewModel()
        introductionViewModel.coordinator = IntroductionViewModel.coordinatorFor(introductionType)
        vc.viewModel = introductionViewModel
        nav.pushViewController(vc, animated: true)
    }
    
    func pushToInAppWeb(_ url: URL, viewController: UIViewController) {
        guard let nav = viewController.navigationController else { return }
        let storyboard = UIStoryboard(name: StoryboardName.common.rawValue, bundle: Bundle.main)
        let webVC = storyboard.instantiateViewController(withIdentifier: CommonStoryboardId.web.rawValue) as! WebViewController
        webVC.viewModel.url = url.absoluteString
        nav.pushViewController(webVC, animated: true)
    }
    
    func pushToViewController(_ storyboardName: String, storyboardId: String, viewController: UIViewController) {
        guard let nav =  viewController.navigationController else { return }
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId)
        nav.pushViewController(vc, animated: true)
    }
    
    func pushToViewController(_ newVc: UIViewController, from: UIViewController) {
        guard let nav =  from.navigationController else { return }
        nav.pushViewController(newVc, animated: true)
    }
    
    func pushToAppSetting() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    func pushToAppLocationServices() {
        guard let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: present related
extension AppNav {
    
    func initViewController(_ questionType: QuestionType)->UIViewController? {
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        guard let vc: QuestionViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.question.rawValue) as? QuestionViewController else { return nil }
        vc.viewModel.coordinator = QuestionViewModel.coordinatorFor(questionType)
        return vc 
    }
    
    func initViewController(_ introType: IntroductionType)-> UIViewController? {
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        guard let vc: IntroductionViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.intro.rawValue) as? IntroductionViewController else { return nil }
        vc.viewModel.coordinator = IntroductionViewModel.coordinatorFor(introType)
        return vc
    }
    
    func initTabViewController()-> UIViewController {
        let storyboard = UIStoryboard(name: StoryboardName.main.rawValue, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: MainStoryboardId.tab.rawValue)
        return vc 
    }
    
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
    
    func dismissModal(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        guard let presentVc = viewController.presentingViewController else { return }
        presentVc.dismiss(animated: true) {
            if let cb = completion {
                NotificationUtil.shared.notify(NotificationEvent.dismissKeyboard.rawValue, key: "", value: "")
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
