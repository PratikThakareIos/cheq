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
    var caption = "Cheq connects with your bank to sync your transactions so we can"
    var title = IntroductionType.setupBank.rawValue
    var confirmTitle = IntroButtonTitle.setupYourBank.rawValue
    var secondaryButtonTitle = IntroButtonTitle.moreInformation.rawValue
    var imageName = IntroEmoji.bank.rawValue
}
