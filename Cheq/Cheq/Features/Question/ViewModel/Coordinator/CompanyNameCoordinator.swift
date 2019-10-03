//
//  CompanyNameCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CompanyNameCoordinator: QuestionCoordinatorProtocol {

    var type: QuestionType = .companyName
    
    var question: String = "What is your employer's company name?"
    
    func placeHolder(_ index: Int)->String {
        return "Company name"
    }
    
    func validateInput(_ inputs: [String: Any])-> ValidationError? {
        return nil
    }
}
