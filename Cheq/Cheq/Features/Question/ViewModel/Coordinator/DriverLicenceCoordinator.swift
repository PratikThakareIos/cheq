//
//  DriverLicenceCoordinator.swift
//  Cheq
//
//  Created by Alexey on 09.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class DriverLicenceCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .driverLicense
    
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
    
    func isEditable(at index: Int) -> Bool {
        switch index {
        case 0:
            return false
        default:
            return true
        }
    }
    
    func validateInput(_ inputs: [String: Any]) -> ValidationError? {
        guard let licenceNumber = inputs[placeHolder(1)] as? String else { return ValidationError.allFieldsMustBeFilled }
                
        guard licenceNumber.count >= 2 else {
            return ValidationError.invalidInputFormat
        }
        
        return nil
    }
}
