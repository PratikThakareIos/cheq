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
