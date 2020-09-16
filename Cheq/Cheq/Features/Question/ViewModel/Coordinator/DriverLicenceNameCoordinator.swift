//
//  DriverLicenceNameCoordinator.swift
//  Cheq
//
//  Created by Alexey on 09.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class DriverLicenceNameCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .driverLicenseName
    
    var question: String = "Enter your legal name as it appears on your ID"
    var sectionTitle: String { Section.verifyMyIdentity.rawValue }

    var numOfTextFields: Int = 3
    
    func placeHolder(_ index: Int)->String {
        switch index {
        case 0:
            return "Your name"
        case 1:
            return "Middle name"
        case 2:
            return "Surname (as shown on ID)"
            
        default:
            return ""
        }
    }
    
    var hintImage: UIImage? {
        let stateVm = MultipleChoiceViewModel()
        stateVm.coordinator = StateCoordinator()
        stateVm.load()
        let savedState = stateVm.savedAnswer[QuestionField.driverLicenceState.rawValue]
        let stateEnum = CountryState(raw: savedState)
        return UIImage(named: "ic_licence_\(stateEnum.rawValue)")
    }

    func validateInput(_ inputs: [String: Any]) -> ValidationError? {
        
        guard let firstName = inputs[placeHolder(0)] as? String, let lastName = inputs[placeHolder(2)] as? String else { return ValidationError.allFieldsMustBeFilled }
                        
        guard firstName.count > 0, lastName.count > 0 else {
            return ValidationError.invalidNameFormat
        }
        
        return nil
    }
}
