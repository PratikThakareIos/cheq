//
//  NameConflictCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class NameConflictCoordinator: IntroductionCoordinatorProtocol {
    
    var type: IntroductionType = .hasNameConflict
    var caption: String = AppData.shared.declineDescription
    var title: String = IntroductionType.hasNameConflict.rawValue
    var confirmTitle: String = IntroButtonTitle.confirmAndChange.rawValue
    var secondaryButtonTitle: String = IntroButtonTitle.chatWithUs.rawValue
    var imageName: String = IntroEmoji.nameNotMatch.rawValue
}
