//
//  SetupBankIntroCoordinator.swift
//  Cheq
//
//  Created by XUWEI LIANG on 10/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class SetupBankIntroCoordinator: IntroductionCoordinatorProtocol {

    var type: IntroductionType = .setupBank
    var caption = "Cheq requires your Bank details o we can verufy your income and expenses to create your budget, spending insights and provide you with On Demand Pay"
    var title = IntroductionType.setupBank.rawValue
    var confirmTitle = IntroButtonTitle.setupYourBank.rawValue
    var secondaryButtonTitle = IntroButtonTitle.learnMore.rawValue
    var imageName = IntroEmoji.bank.rawValue
}
