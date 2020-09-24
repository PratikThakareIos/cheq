//
//  MedicareNameCoordinator.swift
//  Cheq
//
//  Created by Alexey on 09.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class MedicareNameCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .medicareName
    var sectionTitle: String { Section.verifyMyIdentity.rawValue }

    var question: String = "Enter your legal name as it appears on your ID"
    var numOfTextFields: Int = 3
    
    func placeHolder(_ index: Int)->String {
        switch index {
        case 0:
            return "Given name * (as shown on ID)"
        case 1:
            return "Middle Name or Initial (only include if shown on ID)"
        case 2:
            return "Surname * (as shown on ID)"
        default:
            return ""
        }
    }

    func validateInput(_ inputs: [String: Any]) -> ValidationError? {
        
        guard let firstName = inputs[placeHolder(0)] as? String, let lastName = inputs[placeHolder(2)] as? String else { return ValidationError.allFieldsMustBeFilled }
               
        if firstName.isEmpty{
            return ValidationError.emptyFirstNameError
        }
        
        if lastName.isEmpty{
            return ValidationError.emptyLastNameError
        }
        
        guard firstName.count > 0, lastName.count > 0 else {
            return ValidationError.invalidNameFormat
        }
        
        return nil
    }
}
