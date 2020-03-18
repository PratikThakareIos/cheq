//
//  PasscodeViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 12/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit



class EmailVerificationViewModel: VerificationViewModel {
    var type: VerificatonType = .email 
    var code: String = ""
    var newPassword: String = ""
    var header: String = "Cheq your email"
    
    var image: UIImage = UIImage(named: "email") ?? UIImage()
    
    var instructions: NSAttributedString {
        get {
            let email = CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue)
            let instruction = NSMutableAttributedString(string: "We sent a 6 digit verification code to you at \(email).")
            instruction.applyHighlight(email, color: AppConfig.shared.activeTheme.linksColor, font:  AppConfig.shared.activeTheme.defaultFont)
            return instruction
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
            let text = NSMutableAttributedString(string: "Have't received the code yet? Re-send code")
            text.applyLinkTo("Re-send code", link: links.resendCode.rawValue, color: AppConfig.shared.activeTheme.textColor, font: AppConfig.shared.activeTheme.defaultFont)
            return text
        }
    }
}
