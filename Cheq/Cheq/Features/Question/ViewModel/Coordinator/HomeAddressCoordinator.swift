//
//  HomeAddressCoordinator.swift
//  Cheq
//
//  Created by Fawaz Faiz on 06/02/2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class HomeAddressCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .verifyHomeAddress
    var sectionTitle: String = Section.verifyMyIdentity.rawValue
    var numOfTextFields: Int = 2
    var question: String = "What is your home address?"
   
    func placeHolder(_ index: Int)->String {
        switch index {
           case 0:
               return "Unit Number"
           case 1:
               return "Full Address"
           default:
               return ""
           }
    }
    
    func validateInput(_ inputs: [String: Any])-> ValidationError? {
        // unit number
        return nil
    }

}
