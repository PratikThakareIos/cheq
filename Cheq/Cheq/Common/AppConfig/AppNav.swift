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
    static let shared = AppNav()
    private init() { }
    
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
        switch multipleChoiceType {
        case .employmentType:
            multipleChoiceViewModel.coordinator = EmployementTypeCoordinator()
        case .onDemand:
            multipleChoiceViewModel.coordinator = OnDemandCoordinator()
        case .financialInstitutions:
            multipleChoiceViewModel.coordinator = FinancialInstitutionCoordinator()
        case .ageRange:
            multipleChoiceViewModel.coordinator = AgeRangeCoordinator()
        case .state:
            multipleChoiceViewModel.coordinator = StateCoordinator()
        }
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
        introductionViewModel.type = introductionType
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
    
    func pushToViewController(_ viewController: UIViewController) {
        guard let nav =  viewController.navigationController else { return }
        nav.pushViewController(viewController, animated: true)
    }
    
    func pushToAppSetting() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
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
        vc.viewModel.type = introType
        return vc
    }
    
    func initViewController(_ storyboardName: String, storyboardId: String)-> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId)
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    func presentViewController(_ storyboardName: String, storyboardId: String, viewController: UIViewController) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId)
        let nav = UINavigationController(rootViewController: vc)
        viewController.present(nav, animated: true)
    }
}

// MARK: KYC
extension AppNav {
    func navigateToKYCFlow(_ viewController: UIViewController) {
        guard AppData.shared.onfidoSdkToken.isEmpty == false else {
            viewController.showMessage("Test KYC on device, sdk token must be available", completion: nil)
            return
        }
        
        LoggingUtil.shared.cPrint("KYC flow")
        let appearance = Appearance(primaryColor: AppConfig.shared.activeTheme.primaryColor, primaryTitleColor: AppConfig.shared.activeTheme.primaryColor, primaryBackgroundPressedColor: AppConfig.shared.activeTheme.textBackgroundColor, secondaryBackgroundPressedColor: AppConfig.shared.activeTheme.textBackgroundColor, fontRegular: AppConfig.shared.activeTheme.defaultFont.fontName, fontBold: AppConfig.shared.activeTheme.mediumFont.fontName, supportDarkMode: false )
        let config = try! OnfidoConfig.builder()
            .withAppearance(appearance)
            .withSDKToken(AppData.shared.onfidoSdkToken)
            .withWelcomeStep()
            .withDocumentStep()
            .withFaceStep(ofVariant: .photo(withConfiguration: nil))
            .build()
        
        let onfidoFlow = OnfidoFlow(withConfiguration: config)
            .with(responseHandler: { results in
                // Callback when flow ends
                // for KYC, we dismiss the introductionViewController after KYC flow ended
                viewController.dismiss(animated: true, completion: nil)
            })
        let onfidoRun = try! onfidoFlow.run()
        viewController.present(onfidoRun, animated: true, completion: nil) //`self` should be your view controller
    }
}

// MARK: smart dimiss
extension AppNav {
    func dismiss(_ viewController: UIViewController) {
        if let nav = viewController.navigationController {
            nav.popViewController(animated: true)
            return
        }
        
        if viewController.isModal {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}
