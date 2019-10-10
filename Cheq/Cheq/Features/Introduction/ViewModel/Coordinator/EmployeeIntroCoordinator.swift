//
//  EmployeeIntroCoordinator.swift
//  Cheq
//
//  Created by XUWEI LIANG on 10/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class EmployeeIntroCoordinator: IntroductionCoordinatorProtocol {

    var type: IntroductionType = .employee
    var caption = "Please provide us your employment details"
    var title = IntroductionType.employee.rawValue
    var confirmTitle = "Setup your work details"
    var secondaryButtonTitle = "Not now"
    var imageName = "work"
}
