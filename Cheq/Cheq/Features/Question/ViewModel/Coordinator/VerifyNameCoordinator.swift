//
//  VerifyNameCoordinator.swift
//  Cheq
//
//  Created by Fawaz Faiz on 06/02/2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class VerifyNameCoordinator: QuestionCoordinatorProtocol {

        var type: QuestionType = .verifyName
        var sectionTitle: String = Section.verifyMyIdentity.rawValue
        var question: String = "Enter your legal name as it appears on your ID"
        
        var numOfTextFields: Int = 2
        
        func placeHolder(_ index: Int)->String {
           let result = (index == 0) ? "First name" : "Last name"
            return result
        }
        
        func validateInput(_ inputs: [String: Any])-> ValidationError? {
      
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
