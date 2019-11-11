//
//  BankAccountCoordinator.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class BankAccountCoordinator: QuestionCoordinatorProtocol {
    var type: QuestionType = .bankAccount

    var sectionTitle: String = Section.bankDetails.rawValue
    var question: String = "Add your account"

    func placeHolder(_ index: Int) -> String {
        switch index {
        case 0:
            return "Account name"
        case 1:
            return "BSB"
        case 2:
            return "Account number"
        case 3:
            return "Is this a joint account"
        default:
            return ""
        }
    }

    var numOfTextFields: Int = 3
    var numOfCheckBox: Int = 1

    func validateInput(_ inputs: [String : Any]) -> ValidationError? {
        // account name
        guard let accountName = inputs[self.placeHolder(0)] as? String else { return ValidationError.allFieldsMustBeFilled }
        guard StringUtil.shared.isAlphaOnly(accountName) else { return  ValidationError.invalidNameFormat }
        
        // bsb
        guard let bsb = inputs[self.placeHolder(1)] as? String else { return ValidationError.allFieldsMustBeFilled }
        guard StringUtil.shared.isNumericOnly(bsb) else { return ValidationError.onlyNumericCharactersIsAllowed }
        guard bsb.count == 6 else { return ValidationError.invalidInputFormat }
        
        // account number
        guard let accNo = inputs[self.placeHolder(2)] as? String else { return ValidationError.allFieldsMustBeFilled }
        guard StringUtil.shared.isNumericOnly(accNo) else { return ValidationError.onlyNumericCharactersIsAllowed }
        
        // validation passes
        return nil 
    }


}
