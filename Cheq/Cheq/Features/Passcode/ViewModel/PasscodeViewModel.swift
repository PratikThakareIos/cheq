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
    case confirm = "Passcode Confirm"
}

class PasscodeViewModel: BaseViewModel {
    var type: PasscodeValidationType = PasscodeValidationType.setup
    let passcodeLength = 4
    var instruction: String = ""
    var passcode: String = ""
    
    static func resetFailedAttempts() {
        let _ = CKeychain.shared.setValue(CKey.numOfFailedAttempts.rawValue, value: String(0))
    }
    
    func instructions()-> String {
        switch type {
        case .validate:
            return "Enter passcode"
        case .setup:
            return "Create a passcode to secure your account"
        case .confirm:
            return "Confirm passcode"
        }
    }
    
    func validate()-> VerificationValidationError? {
        if passcode.isEmpty { return VerificationValidationError.emptyInput }
        if !StringUtil.shared.isNumericOnly(passcode) { return VerificationValidationError.nonNumeric
            
        }
        if passcode.count != passcodeLength { return VerificationValidationError.invalidLength
            
        }
        
        switch type {
        case .confirm:
            return self.confirmValidation()
        case .setup:
            return self.setupValidation()
        case .validate:
            return self.validation()
        }
    }
    
    func validation()->VerificationValidationError? {
        let storedPasscode = CKeychain.shared.getValueByKey(CKey.confirmPasscodeLock.rawValue)
        if passcode != storedPasscode {
            
            // if we have incorrect entry, we increment failed attempts
            var failed = Int(CKeychain.shared.getValueByKey(CKey.numOfFailedAttempts.rawValue)) ?? 0
            failed = failed + 1
            let _ = CKeychain.shared.setValue(CKey.numOfFailedAttempts.rawValue, value: String(failed))
            return VerificationValidationError.incorrect
        } else {
            return nil
        }
    }
    
    func setupValidation()->VerificationValidationError? {
        let _ = CKeychain.shared.setValue(CKey.numOfFailedAttempts.rawValue, value: String(0))
        let _ = CKeychain.shared.setValue(CKey.passcodeLock.rawValue, value: passcode)
        return nil
    }
    
    func confirmValidation()->VerificationValidationError? {
        let storedPasscode = CKeychain.shared.getValueByKey(CKey.passcodeLock.rawValue)
        if passcode != storedPasscode {
            return VerificationValidationError.incorrect
        } else {
            let _ = CKeychain.shared.setValue(CKey.confirmPasscodeLock.rawValue, value: passcode)
            return nil
        }
    }
}

