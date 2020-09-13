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
    var sectionTitle: String { Section.verifyMyIdentity.rawValue }
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
    
    func isEditable(at index: Int) -> Bool {
        switch index {
        case 7: // Country is hardcoded to AU and not editable
            return false
        default:
            return true
        }
    }
    
    func validateInput(_ inputs: [String: Any])-> ValidationError? {
        guard let streetNumber = inputs[placeHolder(1)] as? String,
            let streetName = inputs[placeHolder(2)] as? String,
            let streetType = inputs[placeHolder(3)] as? String,
            let townSuburb = inputs[placeHolder(4)] as? String
            else { return ValidationError.allFieldsMustBeFilled }
        
        guard !streetNumber.isEmpty, !streetName.isEmpty, !streetType.isEmpty, !townSuburb.isEmpty else {
            return ValidationError.allFieldsMustBeFilled
        }
        
        return nil
    }
}
