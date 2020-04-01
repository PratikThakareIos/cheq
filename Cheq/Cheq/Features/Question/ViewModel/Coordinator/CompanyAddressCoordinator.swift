//
//  CompanyAddressCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CompanyAddressCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .companyAddress
    var sectionTitle: String = Section.employmentDetails.rawValue
    
    var question: String = "Company Address"
    
    func placeHolder(_ index: Int)->String {
        return "123 Example Street"
    }
    
    func validateInput(_ inputs: [String: Any])-> ValidationError? {
        return nil
    }
}
