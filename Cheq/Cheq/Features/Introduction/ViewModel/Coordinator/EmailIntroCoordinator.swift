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
    var caption = EmailIntroCoordinator.buildCaption()
    var title = IntroductionType.email.rawValue
    var confirmTitle = IntroButtonTitle.openMailApp.rawValue
    var secondaryButtonTitle = IntroButtonTitle.close.rawValue
    var imageName = IntroEmoji.email.rawValue
    
    static func buildCaption()->String {
        let email = CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue)
        guard email.isEmpty == false else {
            return "We sent an email to you. It has a link that'll activate your account."
        }
        return "We sent an email to you at \(email). It has a link that'll activate your account."
    }
}
