//
//  PasscodeViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum PasscodeValidationType: String {
    case setup = "Passcode Setup"
    case validate = "Passcode Validate"
}

class PasscodeViewModel: BaseViewModel {
    var type: PasscodeValidationType = PasscodeValidationType.setup
    let passcodeLength = 4
    var instruction: String = ""
    var passcode: String = ""
    
    static func resetFailedAttempts() {
        let _ = CKeychain.setValue(CKey.numOfFailedAttempts.rawValue, value: String(0))
    }
    
    func validate()-> VerificationValidationError? {
        if passcode.isEmpty { return VerificationValidationError.emptyInput }
        if !StringUtil.shared.isNumericOnly(passcode) { return VerificationValidationError.nonNumeric }
        if passcode.count != passcodeLength { return VerificationValidationError.invalidLength }
        
        let storedPasscode = CKeychain.getValueByKey(CKey.passcodeLock.rawValue)
        if passcode != storedPasscode {
            
            // if we have incorrect entry, we increment failed attempts
            var failed = Int(CKeychain.getValueByKey(CKey.numOfFailedAttempts.rawValue)) ?? 0
            failed = failed + 1
            let _ = CKeychain.setValue(CKey.numOfFailedAttempts.rawValue, value: String(failed))
            return VerificationValidationError.incorrect
        }
        
        // return nil to indicate no error
        return nil
    }
}
