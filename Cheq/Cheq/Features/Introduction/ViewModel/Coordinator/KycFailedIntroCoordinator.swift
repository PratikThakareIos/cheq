//
//  KycFailedIntroCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 18/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class KycFailedIntroCoordinator: IntroductionCoordinatorProtocol {
    
    var type: IntroductionType = .kycFailed
    var caption: String = AppData.shared.declineDescription
    var title: String = IntroductionType.kycFailed.rawValue
    var confirmTitle: String = IntroButtonTitle.tellMeWhy.rawValue
    var secondaryButtonTitle: String = IntroButtonTitle.chatWithUs.rawValue
    var imageName: String = IntroEmoji.cry.rawValue
}
