//
//  CreditAssessmentIntroCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 18/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CreditAssessmentIntroCoordinator: IntroductionCoordinatorProtocol {
    
    var type: IntroductionType = .creditAssessment
    var caption: String = AppData.shared.declineDescription
    var title: String = IntroductionType.creditAssessment.rawValue
    var confirmTitle: String = IntroButtonTitle.tellMeWhy.rawValue
    var secondaryButtonTitle: String = IntroButtonTitle.chatWithUs.rawValue
    var imageName: String = IntroEmoji.cry.rawValue
}


class HasOverdueLoansIntroCoordinator: IntroductionCoordinatorProtocol {
    
    var type: IntroductionType = .hasOverdueLoans
    var caption: String = AppData.shared.declineDescription
    var title: String = IntroductionType.hasOverdueLoans.rawValue
    var confirmTitle: String = IntroButtonTitle.tellMeWhy.rawValue
    var secondaryButtonTitle: String = IntroButtonTitle.chatWithUs.rawValue
    var imageName: String = IntroEmoji.cry.rawValue
}

class SalaryInDifferentBankIntroCoordinator: IntroductionCoordinatorProtocol {
    
    var type: IntroductionType = .salaryInDifferentBank
    var caption: String = AppData.shared.declineDescription
    var title: String = IntroductionType.salaryInDifferentBank.rawValue
    var confirmTitle: String = IntroButtonTitle.tellMeWhy.rawValue
    var secondaryButtonTitle: String = IntroButtonTitle.chatWithUs.rawValue
    var imageName: String = IntroEmoji.cry.rawValue
}

class NoEnoughSalaryInfoIntroCoordinator: IntroductionCoordinatorProtocol {
    
    var type: IntroductionType = .noEnoughSalaryInfo
    var caption: String = AppData.shared.declineDescription
    var title: String = IntroductionType.noEnoughSalaryInfo.rawValue
    var confirmTitle: String = IntroButtonTitle.tellMeWhy.rawValue
    var secondaryButtonTitle: String = IntroButtonTitle.chatWithUs.rawValue
    var imageName: String = IntroEmoji.cry.rawValue
}

class SelectYourSalaryInfoIntroCoordinator: IntroductionCoordinatorProtocol {
            
    var type: IntroductionType = .selectYourSalary
    var caption: String = AppData.shared.declineDescription
    var title: String = IntroductionType.selectYourSalary.rawValue
    var confirmTitle: String = IntroButtonTitle.selectSalaryPayments.rawValue
    var secondaryButtonTitle: String = IntroButtonTitle.learnMore.rawValue
    var imageName: String = IntroEmoji.needMoreInfo.rawValue
}

class PayCycleStoppedInfoIntroCoordinator: IntroductionCoordinatorProtocol {
    
    var type: IntroductionType = .payCycleStopped
    var caption: String = AppData.shared.declineDescription
    var title: String = IntroductionType.payCycleStopped.rawValue
    var confirmTitle: String = IntroButtonTitle.tellMeWhy.rawValue
    var secondaryButtonTitle: String = IntroButtonTitle.chatWithUs.rawValue
    var imageName: String = IntroEmoji.cry.rawValue
}
