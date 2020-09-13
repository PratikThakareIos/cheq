//
//  FrankieKycAddressCoordinator.swift
//  Cheq
//
//  Created by Alexey on 09.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class FrankieKycAddressCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .frankieKycAddress
    var sectionTitle: String { Section.verifyMyIdentity.rawValue }
    var numOfTextFields: Int = 1
    var question: String = "What's your current residential address?"
    
    func placeHolder(_ index: Int)->String {
        switch index {
        case 0:
            return "Street address(cannot be a PO box)"
        default:
            return ""
        }
    }
    
    func validateInput(_ inputs: [String: Any])-> ValidationError? {
        // unit number
        return nil
    }
}
