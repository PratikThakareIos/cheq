//
//  NewPasswordSetupViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 21/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

class NewPasswordSetupViewModel: VerificationViewModel {
    
    var type: VerificatonType = .passwordReset
    var newPassword: String = ""
    var code: String = ""
    
    var header: String = "Cheq your email"
    
    var image: UIImage = UIImage(named: "email") ?? UIImage()
    
    var instructions: NSAttributedString {
        get {
//            let email = CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue)
//            let instruction = NSMutableAttributedString(string: "We sent a 6 digit verification code to you at \(email)")
//            instruction.applyHighlight(email, color: AppConfig.shared.activeTheme.linksColor, font:  AppConfig.shared.activeTheme.defaultFont)
//            return instruction
            
            let email = AppData.shared.forgotPasswordEmail //CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue)
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
        return true
    }
    
    var confirmButtonTitle: String = "Reset password"
    
    var footerText: NSAttributedString {
        get {
//            let text = NSMutableAttributedString(string: "Have't received the code yet? Re-send code")
//            text.applyLinkTo("Re-send code", link: links.resendCode.rawValue, color: AppConfig.shared.activeTheme.textColor, font: AppConfig.shared.activeTheme.defaultFont)
//            return text
            
            let string = "Not in inbox or spam folder? Resend"
            let font = AppConfig.shared.activeTheme.mediumFont
            let attributes = [NSAttributedString.Key.foregroundColor: AppConfig.shared.activeTheme.mediumGrayColor,
                              NSAttributedString.Key.font: font]
            let text = NSMutableAttributedString(string: string, attributes: attributes)
            return text
        }
    }
}

extension NewPasswordSetupViewModel {
    
    func validate()->VerificationValidationError? {
        
         if (self.code.isEmpty && self.newPassword.isEmpty) { return VerificationValidationError.allInputEmpty }
        if self.code.isEmpty { return VerificationValidationError.emptyInput }
        if self.code.count != self.codeLength { return VerificationValidationError.invalidLength }
        if !StringUtil.shared.isNumericOnly(self.code) { return VerificationValidationError.nonNumeric }

        if StringUtil.shared.isValidPassword(self.newPassword) == false {
            return VerificationValidationError.invalidPasswordFormat
        }
    
        return nil
    }
}
