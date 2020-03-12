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
    var question: String = "Enter your direct debit details"

    func placeHolder(_ index: Int) -> String {
        switch index {
        case 0:
            return "First name"
        case 1:
            return "Last name"
        case 2:
            return "BSB"
        case 3:
            return "Account number"
        case 4:
            return "is this a joint Account?"
        default:
            return ""
        }
    }

    var numOfTextFields: Int = 4
    var numOfCheckBox: Int = 1
    var numOfImageContainer: Int = 1

    func validateInput(_ inputs: [String : Any]) -> ValidationError? {
        //*
        // First Name and Last Name
        guard let firstName = inputs[placeHolder(0)] as? String, let lastName = inputs[placeHolder(1)] as? String else { return ValidationError.allFieldsMustBeFilled }
        guard StringUtil.shared.isAlphaOnly(firstName), StringUtil.shared.isAlphaOnly(lastName) else { return ValidationError.onlyAlphabetCharactersIsAllowed }
        guard firstName.count >= 2, lastName.count >= 2 else {
            return ValidationError.invalidNameFormat
        }
        
        // bsb
        guard let bsb = inputs[self.placeHolder(2)] as? String else { return ValidationError.allFieldsMustBeFilled }
        guard StringUtil.shared.isNumericOnly(bsb) else { return ValidationError.onlyNumericCharactersIsAllowed }
        guard bsb.count == 6 else { return ValidationError.invalidInputFormat }
        
        // account number
        guard let accNo = inputs[self.placeHolder(3)] as? String else { return ValidationError.allFieldsMustBeFilled }
        guard StringUtil.shared.isNumericOnly(accNo) else { return ValidationError.onlyNumericCharactersIsAllowed }
      //  */
        // validation passes
        
        return nil 
    }


}
