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
    var caption = "Please provide us your bank details"
    var title = IntroductionType.setupBank.rawValue
    var confirmTitle = IntroButtonTitle.setupYourBank.rawValue
    var secondaryButtonTitle = IntroButtonTitle.learnMore.rawValue
    var imageName = IntroEmoji.bank.rawValue
}
