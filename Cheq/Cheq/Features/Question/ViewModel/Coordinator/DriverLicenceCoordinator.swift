//
//  DriverLicenceCoordinator.swift
//  Cheq
//
//  Created by Alexey on 09.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class DriverLicenceCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .driverLicense
    var sectionTitle: String { Section.verifyMyIdentity.rawValue }

    var question: String = "Your driver's licence details"
    var numOfTextFields: Int = 2
    
    func placeHolder(_ index: Int) -> String {
        switch index {
        case 0:
            return "State or territory of issue"
        case 1:
            return "Licence Number"
            
        default:
            return ""
        }
    }
    
    private var selectedState: CountryState {
        let stateVm = MultipleChoiceViewModel()
        stateVm.coordinator = StateCoordinator()
        stateVm.load()
        let savedState = stateVm.savedAnswer[QuestionField.driverLicenceState.rawValue]
        let stateEnum = CountryState(raw: savedState)
        return stateEnum
    }
    
    var hintImage: UIImage? {
        return UIImage(named: "ic_licence_\(selectedState.rawValue)")
    }
    
    func isEditable(at index: Int) -> Bool {
        switch index {
        case 0:
            return false
        default:
            return true
        }
    }
    
    func validateInput(_ inputs: [String: Any]) -> ValidationError? {
        guard let licenceNumber = inputs[placeHolder(1)] as? String else { return ValidationError.allFieldsMustBeFilled }
                
        guard licenceNumber.count >= selectedState.minCharsCount && licenceNumber.count <= selectedState.maxCharsCount else {
            return ValidationError.invalidDriversLicenseFormat
        }
        
        if selectedState == .NSW || selectedState == .SA || selectedState == .TAS{
        }else{
            guard StringUtil.shared.isNumericOnly(licenceNumber) else { return ValidationError.onlyNumericCharactersIsAllowed }
        }
        

//        guard licenceNumber.count >= selectedState.minCharsCount && licenceNumber.count <= selectedState.maxCharsCount else {
//            return ValidationError.invalidDriversLicenseFormat
//        }
        
        return nil
    }
}
