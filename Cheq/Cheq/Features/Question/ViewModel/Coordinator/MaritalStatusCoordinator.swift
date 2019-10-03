//
//  MaritalStatusCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class MaritalStatusCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .maritalStatus
    
    var question: String = "What is your living status?"
    
    var numOfTextFields: Int = 2
    
    func placeHolder(_ index: Int)->String {
        let result = (index == 0) ? "Status" : "Number of dependents"
        return result
    }
    
    func validateInput(_ inputs: [String: Any])-> ValidationError? {
        return nil
    }
}
