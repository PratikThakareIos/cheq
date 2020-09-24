//
//  PassportNameCoordinator.swift
//  Cheq
//
//  Created by Alexey on 09.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class PassportNameCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .passportName
    var sectionTitle: String { Section.verifyMyIdentity.rawValue }

    var question: String = "Enter your legal name as it appears on your ID"
    var numOfTextFields: Int = 3
    
    func placeHolder(_ index: Int)->String {
        switch index {
        case 0:
            return "Your name"
        case 1:
            return "Middle name"
        case 2:
            return "Surname (as shown on ID)"
            
        default:
            return ""
        }
    }

    var hintImage: UIImage? {
        UIImage(named: "ic_passport_example")
    }

    func validateInput(_ inputs: [String: Any]) -> ValidationError? {
        
        guard let firstName = inputs[placeHolder(0)] as? String, let lastName = inputs[placeHolder(2)] as? String else { return ValidationError.allFieldsMustBeFilled }
                        
        guard firstName.count > 0, lastName.count > 0 else {
            return ValidationError.invalidNameFormat
        }

        return nil
    }
}
