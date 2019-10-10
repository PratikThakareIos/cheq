//
//  EmailIntroCoordinator.swift
//  Cheq
//
//  Created by XUWEI LIANG on 10/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class EmailIntroCoordinator: IntroductionCoordinatorProtocol {

    var type: IntroductionType  = .email
    var caption = "We sent an email to you at xuwei@cheq.com.au. It has a link that'll activate your account"
    var title = IntroductionType.email.rawValue
    var confirmTitle = "Open mail app"
    var secondaryButtonTitle = "Close"
    var imageName = "email"
}
