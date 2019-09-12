//
//  PasscodeViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 12/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

enum PasscodeValidationError: Error {
    case invalidLength
    case nonNumeric
}

extension PasscodeValidationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidLength:
            return NSLocalizedString("invalid length", comment: "")
        case .nonNumeric:
            return NSLocalizedString("only numeric value is allowed", comment: "")
        }
    }
}

class PasscodeViewModel: BaseViewModel {
    
    let passcodeLength = 4
    
    func savePasscode(_ passcode: String)->Promise<Bool> {
        return Promise<Bool>() { resolver in
            guard passcode.count == passcodeLength else { resolver.reject(PasscodeValidationError.invalidLength); return }
            resolver.fulfill(true)
        }
    }
}
