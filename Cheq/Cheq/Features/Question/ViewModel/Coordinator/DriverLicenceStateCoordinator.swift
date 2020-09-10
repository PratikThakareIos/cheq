//
//  DriverLicenceStateCoordinator.swift
//  Cheq
//
//  Created by Alexey on 09.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class DriverLicenceStateCoordinator: QuestionCoordinatorProtocol {
    var type: QuestionType = .driverLicenseState

    var question: String = "What state was your driver's licence issued?"
    var sectionTitle: String = ""
    
    func placeHolder(_ index: Int) -> String {
        ""
    }
    
    func validateInput(_ inputs: [String : Any]) -> ValidationError? {
        nil
    }
}
