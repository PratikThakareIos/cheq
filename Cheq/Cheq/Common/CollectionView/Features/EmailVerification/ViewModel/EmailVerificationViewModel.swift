//
//  PasscodeViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 12/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
import FRHyperLabel

class EmailVerificationViewModel: VerificationViewModel {
    
    var type: VerificatonType = .email
    var code: String = ""
    var newPassword: String = ""
    var header: String = "Cheq your email"
    var image: UIImage = UIImage(named: "email") ?? UIImage()
    
    var instructions: NSAttributedString {
        get {

             let email = CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue)
             let string = "We sent a 6 digit verification code to you at \(email)"
             let font = AppConfig.shared.activeTheme.mediumMediumFont
             print("font = \(font.fontDescriptor)")
             let attributes = [NSAttributedString.Key.foregroundColor: AppConfig.shared.activeTheme.mediumGrayColor,
                                    NSAttributedString.Key.font: font]
             let text = NSMutableAttributedString(string: string, attributes: attributes)
             return text
        }
    }
    
    func showCodeField()->Bool {
        return true
    }
    func showNewPasswordField()->Bool {
        return false
    }
    
    var confirmButtonTitle: String = "Verify code"
    
    var footerText: NSAttributedString {
        get {
            let string = "Not in inbox or spam folder? Resend"
            let font = AppConfig.shared.activeTheme.mediumFont
            let attributes = [NSAttributedString.Key.foregroundColor: AppConfig.shared.activeTheme.mediumGrayColor,
                              NSAttributedString.Key.font: font]
            let text = NSMutableAttributedString(string: string, attributes: attributes)
            return text
        }
    }
}



