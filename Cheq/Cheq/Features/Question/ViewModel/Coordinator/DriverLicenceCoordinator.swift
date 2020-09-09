//
//  DriverLicenceCoordinator.swift
//  Cheq
//
//  Created by Alexey on 09.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class DriverLicenceCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .driverLicence
    
    var question: String = "Your driver's licence details"
    var sectionTitle: String = ""
    var numOfTextFields: Int = 2
    
    func placeHolder(_ index: Int) -> String {
        switch index {
        case 0:
            return "State or territory of issue"
        case 1:
            return "Licence Number"
            
        default:
            return ""
        }
    }
    
    func validateInput(_ inputs: [String: Any]) -> ValidationError? {
        
        guard let firstName = inputs[placeHolder(0)] as? String, let lastName = inputs[placeHolder(1)] as? String else { return ValidationError.allFieldsMustBeFilled }
        
        guard (firstName != "" &&  lastName != "") else {
            return ValidationError.allFieldsMustBeFilled
        }
        
        guard StringUtil.shared.isAlphaOnly(firstName), StringUtil.shared.isAlphaOnly(lastName) else { return ValidationError.onlyAlphabetCharactersIsAllowed }
        
        guard firstName.count >= 2, lastName.count >= 2 else {
            return ValidationError.invalidNameFormat
        }
        
        return nil
    }
}
