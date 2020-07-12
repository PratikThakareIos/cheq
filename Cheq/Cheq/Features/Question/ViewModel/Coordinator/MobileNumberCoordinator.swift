//
//  MobileNumberCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class MobileNumberCoordinator: QuestionCoordinatorProtocol {
    
    let mobileNumberLength = 10
    var type: QuestionType = .contactDetails
    
    var question: String = "What is your mobile number?"
    
    func placeHolder(_ index: Int)->String {
        return "0410 000 000"
    }
    
    func validateInput(_ inputs: [String: Any])-> ValidationError? {
        for index in 0..<self.numOfTextFields {
            var value: String = inputs[self.placeHolder(index)] as? String ?? ""
            value = value.replacingOccurrences(of: " ", with: "")
            if value.isEmpty { return ValidationError.allFieldsMustBeFilled }
            if !StringUtil.shared.isNumericOnly(value) { return ValidationError.invalidMobileFormat }
            if value.count < 10 { return ValidationError.allFieldsMustBeFilled }
            let nums = Array(value)
            if nums[0] != "0" { return ValidationError.invalidMobileFormat }
            if nums[1] != "4" && nums[1] != "5" { return ValidationError.invalidMobileFormat}
        }
        return nil
    }
}
