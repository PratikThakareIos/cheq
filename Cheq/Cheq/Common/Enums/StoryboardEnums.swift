//
//  StoryboardEnums.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation

/**
 StoryboardName is String enum of all the storyboards in use. This enum is used by AppNav and whenever we want to refer to the storyboard name we want to load. Update the enum when new Storyboard is added.
*/
enum StoryboardName: String {
    case onboarding = "Onboarding"
    case main = "Main"
    case common = "Common"
    case Popup = "PopUp"
}

enum PopupStoryboardId: String {
    case payCyclePopUpVC = "PayCyclePopUpVC"
    case verificationPopupVC = "VerificationPopupVC"
}


/**
 OnboardingStoryboardId are viewController storyboard Ids inside the **onboarding** storyboard. Use these in pair with **StoryboardName.onboarding.rawValue** by **AppNav**
 */
enum OnboardingStoryboardId: String {
    case splash = "SplashViewController"
    case cSplash = "CSplashViewController"
    case cSplashPage = "CSplashPageViewController"
    case registration = "RegistrationVC"//"RegistrationViewController"
    case login = "LoginVC"//"LoginViewController"
    case forgot = "ForgotPasswordViewController"
    case question = "QuestionViewController"
    case intro = "IntroductionViewController"
    case multipleChoice = "MultipleChoiceViewController"
    case dynamic = "DynamicFormViewController"
    case salaryPayments = "SalaryPaymentViewController"
    case payCycleViewController = "PayCycleViewController"
    case verifyDocs = "DocumentVerificationViewController"
    case setupBankVC = "SetupBankVC"
    case bankDetailLearnMoreVC = "BankDetailLearnMoreVC"
    case requestForBankVC = "RequestForBankVC"
}

/**
MainStoryboardId are viewController storyboard Ids inside the **main** storyboard. Use these in pair with **StoryboardName.main.rawValue** by **AppNav**
*/
enum MainStoryboardId: String {
    case tab = "TabViewController"
    case lending = "LendingViewController"
    case spending = "SpendingOverviewViewController"
    case spendingCategories = "SpendingCategoriesViewController"
    case spendingCategoryById = "SpendingSpecificCategoryViewController"
    case spendingTransactions = "SpendingTransactionsViewController"
    case budget = "BudgetViewController"
    case preview = "PreviewLoanViewController"
    case account = "AccountViewController"
    
}

/**
CommonStoryboardId are viewController storyboard Ids inside the **common** storyboard. Use these in pair with **StoryboardName.main.rawValue** by **AppNav**
*/
enum CommonStoryboardId: String {
    case emailVerify = "EmailVerificationViewController"
    case web = "WebViewController"
    case kyc = "KYCViewController"
    case account = "AccountViewController"
    case passcode = "PasscodeViewController"
    case connecting = "ConnectingToBankViewController"
    case reTryConnecting = "ConnectingTobankFalilsViewController"
    case userActionRequiredVC = "UserActionRequiredVC"
    case BankNotSupportedVC = "BankNotSupportedVC"
    case CategorisationInProgressVC = "CategorisationInProgressVC"
    case GenericInfoVC = "GenericInfoVC"
}
