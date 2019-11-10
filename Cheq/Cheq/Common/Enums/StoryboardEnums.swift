//
//  StoryboardEnums.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation

enum StoryboardName: String {
    case onboarding = "Onboarding"
    case main = "Main"
    case common = "Common"
}

enum OnboardingStoryboardId: String {
    case splash = "SplashViewController"
    case registration = "RegistrationViewController"
    case login = "LoginViewController"
    case forgot = "ForgotPasswordViewController"
    case question = "QuestionViewController"
    case intro = "IntroductionViewController"
    case multipleChoice = "MultipleChoiceViewController"
    case dynamic = "DynamicFormViewController"
}

enum MainStoryboardId: String {
    case tab = "TabViewController"
    case lending = "LendingViewController"
    case spending = "SpendingOverviewViewController"
    case spendingCategories = "SpendingCategoriesViewController"
    case budget = "BudgetViewController"
    case preview = "PreviewLoanViewController"
}

enum CommonStoryboardId: String {
    case emailVerify = "EmailVerificationViewController"
    case web = "WebViewController"
    case kyc = "KYCViewController"
    case account = "AccountViewController"
    case passcode = "PasscodeViewController"
}
