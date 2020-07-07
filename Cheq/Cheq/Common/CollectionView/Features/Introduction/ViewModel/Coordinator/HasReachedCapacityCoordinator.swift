//
//  HasReachedCapacityCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 18/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class HasReachedCapacityCoordinator: IntroductionCoordinatorProtocol {
    
    var type: IntroductionType = .hasReachedCapacity
    var caption: String = AppData.shared.declineDescription
    var title: String = IntroductionType.hasReachedCapacity.rawValue
    var confirmTitle: String = IntroButtonTitle.chatWithUs.rawValue
    var secondaryButtonTitle: String = IntroButtonTitle.chatWithUs.rawValue
    var imageName: String = IntroEmoji.cry.rawValue
}
