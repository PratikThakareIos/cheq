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
    case question = "QuestionViewController"
    case intro = "IntroductionViewController"
    case multipleChoice = "MultipleChoiceViewController"
    case dynamic = "DynamicFormViewController"
}

enum MainStoryboardId: String {
    case finance = "FinanceViewController"
}

enum CommonStoryboardId: String {
    case passcode = "PasscodeViewController"
    case web = "WebViewController"
    case kyc = "KYCViewController"
}
