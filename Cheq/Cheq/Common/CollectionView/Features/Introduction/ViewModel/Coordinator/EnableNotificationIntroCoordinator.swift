//
//  EnableNotificationIntroCoordinator.swift
//  Cheq
//
//  Created by XUWEI LIANG on 10/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class EnableNotificationIntroCoordinator: IntroductionCoordinatorProtocol {

    var type: IntroductionType = .notification
    var caption = "Please enable notification for our app"
    var title = IntroductionType.notification.rawValue
    var confirmTitle = "Allow push notification"
    var secondaryButtonTitle = "Not now"
    var imageName = "notification"
}
