//
//  IntroductionViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 16/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum IntroductionType: String {
    case email = "Check your email"
    case employee = "Employee details"
    case setupBank = "Set up your bank"
    case enableLocation = "Enable location"
    case notification = "Notification"
    case verifyIdentity = "Verify your identity"

    // decline types
    case workDetailsDecline = "Our eligibility criteria"
}

class IntroductionViewModel: BaseViewModel {

    var coordinator: IntroductionCoordinatorProtocol = EmailIntroCoordinator()

    func caption()-> String {
        return coordinator.caption
    }

    func confirmButtonTitle()-> String {
        return coordinator.confirmTitle
    }
    
    func nextButtonTitle()-> String {
        return coordinator.secondaryButtonTitle
    }
    
    func imageName()-> String {
        return coordinator.imageName
    }
    
    func header()-> String {
        return coordinator.title
    }

    static func coordinatorFor(_ type: IntroductionType)-> IntroductionCoordinatorProtocol {
        switch type {
        case .email:
            return EmailIntroCoordinator()
        case .employee:
            return EmployeeIntroCoordinator()
        case .enableLocation:
            return EnableLocationIntroCoordinator()
        case .notification:
            return EnableNotificationIntroCoordinator()
        case .setupBank:
            return SetupBankIntroCoordinator()
        case .verifyIdentity:
            return VerifyIdentityIntroCoordinator()
        case .workDetailsDecline:
            return EmploymentTypeDeclineIntroCoordinator()
        }
    }
}
