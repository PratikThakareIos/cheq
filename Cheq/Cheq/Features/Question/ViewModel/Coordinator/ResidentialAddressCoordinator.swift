//
//  ResidentialAddressCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class ResidentialAddressCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .residentialAddress
    
    var question: String = "What is your residential address?"
    
    func placeHolder(_ index: Int)->String {
        return "123 Example Street"
    }
    
    func validateInput(_ inputs: [String: Any])-> ValidationError? {
        return nil
    }
}
