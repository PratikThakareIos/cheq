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
    var numOfTextFields: Int = 7
    var question: String = "What's your current residential address?"
    
    func placeHolder(_ index: Int)->String {
        switch index {
        case 0:
            return "Unit Number"
        case 1:
            return "Street Number *"
        case 2:
            return "Street Name *"
        case 3:
            return "Town/Suburb *"
        case 4:
            return "State *"
        case 5:
            return "Postcode *"
        case 6:
            return "Country"
            
        default:
            return ""
        }
    }
    
    func isEditable(at index: Int) -> Bool {
        switch index {
        case 6: // Country is hardcoded to AU and not editable
            return false
        default:
            return true
        }
    }
    
    func validateInput(_ inputs: [String: Any])-> ValidationError? {
        guard let streetNumber = inputs[placeHolder(1)] as? String,
            let streetName = inputs[placeHolder(2)] as? String,
            let townSuburb = inputs[placeHolder(3)] as? String,
            let state = inputs[placeHolder(4)] as? String,
            let postcode = inputs[placeHolder(5)] as? String
            else { return ValidationError.allFieldsMustBeFilled }
        
        guard !streetNumber.isEmpty, !streetName.isEmpty, !townSuburb.isEmpty, !state.isEmpty, !postcode.isEmpty else {
            return ValidationError.allFieldsMustBeFilled
        }
        
        guard postcode.count == 4, StringUtil.shared.isNumericOnly(postcode) else {
            return ValidationError.invalidPostcodeFormat
        }
        
        return nil
    }
}
