//
//  FrankieKycAddressConfirmCoordinator.swift
//  Cheq
//
//  Created by Alexey on 09.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class FrankieKycAddressConfirmCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .frankieKycAddressConfirm
    var sectionTitle: String = ""
    var numOfTextFields: Int = 8
    var question: String = "Is this the correct address?"
    
    func placeHolder(_ index: Int)->String {
        switch index {
        case 0:
            return "Unit Number"
        case 1:
            return "Street Number *"
        case 2:
            return "Street Name *"
        case 3:
            return "Street Type *"
        case 4:
            return "Town/Suburb *"
        case 5:
            return "State"
        case 6:
            return "Postcode"
        case 7:
            return "Country"
            
        default:
            return ""
        }
    }
    
    func validateInput(_ inputs: [String: Any])-> ValidationError? {
        // unit number
        return nil
    }
}
