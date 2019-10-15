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

    var sectionTitle: String = "Bank details"
    var question: String = "Add your account"

    func placeHolder(_ index: Int) -> String {
        switch index {
        case 0:
            return "Bank name"
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
        return nil
    }


}
