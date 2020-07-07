//
//  ForgotPasswordViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 21/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

class ForgotPasswordViewModel {
    var resetEmail: String = ""
    
    func forgotPassword()->Promise<Void> {
        return Promise<Void>() { resolver in
            CheqAPIManager.shared.forgotPassword().done { _ in
                resolver.fulfill(())
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    func validateInput()->ValidationError? {
        if StringUtil.shared.isValidEmail(resetEmail) == false {
            return ValidationError.invalidEmailFormat
        }
        return nil
    }
}
