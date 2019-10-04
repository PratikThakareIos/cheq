//
//  PasscodeViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class PasscodeViewModel: BaseViewModel {
    var instruction: String = ""
    var passcode: String = ""
    func validate()-> VerificationValidationError? {
        return nil
    }
}
