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
    var sectionTitle: String = Section.verifyMyIdentity.rawValue
    var numOfTextFields: Int = 2
    var question: String = "What's your home address?"
   
    func placeHolder(_ index: Int)->String {
        switch index {
           case 0:
               return "Unit / Apartment (optional)"
           case 1:
               return "Street address"
           default:
               return ""
           }
    }
    
    func validateInput(_ inputs: [String: Any])-> ValidationError? {
        // unit number
        return nil
    }

}
