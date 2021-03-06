//
//  PassportCoordinator.swift
//  Cheq
//
//  Created by Alexey on 09.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class PassportCoordinator: QuestionCoordinatorProtocol {
    
    var type: QuestionType = .passport

    var sectionTitle: String { Section.verifyMyIdentity.rawValue }
    var question: String = "Your Australian passport details"
    var numOfTextFields: Int = 1
    
    func placeHolder(_ index: Int)->String {
        "Document Number"
    }
    
    var hintImage: UIImage? {
        UIImage(named: "ic_passport_example")
    }
    
    func validateInput(_ inputs: [String: Any]) -> ValidationError? {
        guard let passportNumber = inputs[placeHolder(0)] as? String else { return ValidationError.allFieldsMustBeFilled }
        
        if passportNumber.isEmpty{
            return ValidationError.emptyPassportError
        }
        
        if passportNumber.count < 2{
            return ValidationError.invalidPassportError
        }
        
        return nil
    }
}
