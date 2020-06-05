//
//  IntroductionViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 16/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum BankLogo: String {
    case placeholder = "bankPlaceholder"
}

enum IntroEmoji: String {
    case email = "email"
    case work = "work"
    case bank = "bank"
    case location = "location"
    case notification = "notification"
    case verifyIdentity = "verifyIdentity"
    case cry = "cry"
    case speedy = "speedy"
    case nameNotMatch = "nameNotMatch"
    case needMoreInfo = "needMoreInfo"
    case transferFailed = "transferFailed"
}


enum IntroButtonTitle: String {
    case setupYourBank = "Setup your bank"
    case tellMeWhy = "Tell me why"
    case chatWithUs = "Chat with us"
    case confirmAndChange = "Confirm and change"
    case close = "Close"
    case learnMore = "Learn more"
    case openMailApp = "Open mail app"
    case moreInformation = "More information"
    case selectSalaryPayments = "Select salary payments"
    
}

enum IntroductionType: String {
    case email = "Check your email"
    case employee = "Employee details"
    case setupBank = "Connect to your bank" //Set up your bank"
    case enableLocation = "Enable location"
    case notification = "Notification"
    case verifyIdentity = "Verify your identity"

    // decline types
    case employmentTypeDeclined = "Our eligibility criteria"
    case hasWriteOff = "Has write off"
    case noPayCycle = "No pay cycle"
    case identityConflict = "Identity does not match"
    case jointAccount = "Joint account is not eligible"
    case kycFailed = "KYC failed"
    case monthlyPayCycle = "Monthly pay cycle is not eligible"
    case creditAssessment = "Credit assessment didn't pass"
    case hasNameConflict = "Name does not match"
    case hasReachedCapacity = "Has reached capacity"
    case hasOverdueLoans = "HasOverdueLoans"
    case salaryInDifferentBank = "SalaryInDifferentBank"
    case noEnoughSalaryInfo = "NoEnoughSalaryInfo"
    case selectYourSalary = "selectYourSalary"
    case payCycleStopped = "payCycleStopped"
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
    
    static func declineReasons()->[IntroductionType] {
        return [.employmentTypeDeclined, .creditAssessment, .hasWriteOff, .identityConflict, .jointAccount, .kycFailed, .monthlyPayCycle, .noPayCycle]
    }
    
    static func introTypeFromDeclineReason(_ type: DeclineDetail.DeclineReason)-> IntroductionType? {
        switch type {
        case ._none: return nil
        case .employmentType: return .employmentTypeDeclined
        case .creditAssessment: return .creditAssessment
        case .hasWriteOff: return .hasWriteOff
        case .identityConflict: return .identityConflict
        case .jointAccount: return .jointAccount
        case .monthlyPayCycle: return .monthlyPayCycle
        case .reachedCapacity: return .hasReachedCapacity
        case .hasOverdueLoans : return .hasOverdueLoans
        case .salaryInDifferentBank : return .salaryInDifferentBank
        case .noEnoughSalaryInfo : return .noEnoughSalaryInfo
        case .selectYourSalary : return .selectYourSalary
        case .payCycleStopped:  return .payCycleStopped
            
            //        case .noPayCycle: return .noPayCycle
            //        case .hasNameConflict: return .hasNameConflict
            //        case .kycFailed: return .kycFailed
        }
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
        case .employmentTypeDeclined:
            return EmploymentTypeDeclineIntroCoordinator()
        case .hasWriteOff:
            return HasWriteOffIntroCoordinator()
        case .noPayCycle:
            return NoPayCycleIntroCoordinator()
        case .identityConflict:
            return IdentityConflictIntroCoordinator()
        case .jointAccount:
            return JointAccountIntroCoordinator()
        case .kycFailed:
            return KycFailedIntroCoordinator()
        case .monthlyPayCycle:
            return MonthlyPayCycleIntroCoordinator()
        case .creditAssessment:
            return CreditAssessmentIntroCoordinator()
        case .hasNameConflict:
            return NameConflictCoordinator()
        case .hasReachedCapacity:
            return HasReachedCapacityCoordinator()
        case .hasOverdueLoans:
           return HasOverdueLoansIntroCoordinator()
        case .salaryInDifferentBank:
            return SalaryInDifferentBankIntroCoordinator()
        case .noEnoughSalaryInfo:
            return NoEnoughSalaryInfoIntroCoordinator()
        case .selectYourSalary:
            return SelectYourSalaryInfoIntroCoordinator()
        case .payCycleStopped:
             return PayCycleStoppedInfoIntroCoordinator()
        }
    }
}
