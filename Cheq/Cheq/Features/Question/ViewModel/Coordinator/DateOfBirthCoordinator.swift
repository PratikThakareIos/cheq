//
//  DateOfBirthCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class DateOfBirthCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .dateOfBirth
    
    var question: String = "What is your date of birth?"
    
    var numOfTextFields = 1
    
    func placeHolder(_ index: Int)->String {
        return "Date of birth"
    }
    
    func validateInput(_ inputs: [String: Any])-> ValidationError? {
        
        guard let strInput = inputs[placeHolder(0)] as? String, strInput.count > 0 else { return ValidationError.dobIsMandatory }
    
        return nil
    }
}
