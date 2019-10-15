//
//  VerifyIdentityIntroCoordinator.swift
//  Cheq
//
//  Created by XUWEI LIANG on 10/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class VerifyIdentityIntroCoordinator: IntroductionCoordinatorProtocol {

    var type: IntroductionType = .verifyIdentity
    var caption = "Please proceed with our identity verification flow"
    var title = IntroductionType.verifyIdentity.rawValue
    var confirmTitle = "Verify"
    var secondaryButtonTitle = "Not now"
    var imageName = "verifyIdentity"
}
