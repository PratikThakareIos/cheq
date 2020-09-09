//
//  PassportCoordinator.swift
//  Cheq
//
//  Created by Alexey on 09.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class PassportCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .passport

    var question: String = "Enter your legal name as it appears on your ID"
    var numOfTextFields: Int = 2
    
    func placeHolder(_ index: Int)->String {
        let result = (index == 0) ? "First name" : "Surname"
        return result
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
