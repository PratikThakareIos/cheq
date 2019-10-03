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
        return nil
    }
}
