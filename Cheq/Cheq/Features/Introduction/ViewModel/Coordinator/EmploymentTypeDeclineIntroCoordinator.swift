//
//  DeclineIntroCoordinator.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class EmploymentTypeDeclineIntroCoordinator: IntroductionCoordinatorProtocol {
    var type: IntroductionType = .employmentTypeDeclined

    var caption: String = "Unfortunately, we do not currently cater to casual/self-employed/part-time workers. As we grow we will look to expand our service to your employment type. You'll be the first to know about it. Till then, feel free to use our budgeting and spending tools to help you manage your personal finances."

    var title: String = "Same day pay eligibility criteria"

    var confirmTitle: String = IntroButtonTitle.tellMeWhy.rawValue

    var secondaryButtonTitle: String = IntroButtonTitle.chatWithUs.rawValue

    var imageName: String = "cry"


}
