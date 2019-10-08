//
//  LegalNameCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class LegalNameCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .legalName
    
    var question: String = "Enter your legal name as it appears on your ID"
    
    var numOfTextFields: Int = 2
    
    func placeHolder(_ index: Int)->String {
       let result = (index == 0) ? "First name" : "Last name"
        return result
    }
    
    func validateInput(_ inputs: [String: Any])-> ValidationError? {
  
        guard let firstName = inputs[placeHolder(0)] as? String, let lastName = inputs[placeHolder(1)] as? String else { return ValidationError.allFieldsMustBeFilled }
        guard StringUtil.shared.isAlphaOnly(firstName), StringUtil.shared.isAlphaOnly(lastName) else { return ValidationError.onlyAlphabetCharactersIsAllowed }
        return nil
    }
}
