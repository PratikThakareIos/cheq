//
//  EnableLocationIntroCoordinator.swift
//  Cheq
//
//  Created by XUWEI LIANG on 10/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class EnableLocationIntroCoordinator: IntroductionCoordinatorProtocol {

    var type: IntroductionType = .enableLocation
    var caption = "Please enable location for our app"
    var title = IntroductionType.enableLocation.rawValue
    var confirmTitle = "Turn on location"
    var secondaryButtonTitle = "Not now"
    var imageName = "location"
}
