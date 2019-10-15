//
//  IntroductionCoordinatorProtocol.swift
//  Cheq
//
//  Created by XUWEI LIANG on 10/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

protocol IntroductionCoordinatorProtocol {
    var type: IntroductionType { get }
    var caption: String { get }
    var title: String { get }
    var confirmTitle: String { get }
    var secondaryButtonTitle: String { get }
    var imageName: String { get }
}
