//
//  VerificationViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum VerificatonType {
    case email
    case passwordReset
}

enum VerificationValidationError: Error {
    case emptyInput
    case invalidLength
    case nonNumeric
    case incorrect
    case lockedOut
    case invalidPasswordFormat
}

extension VerificationValidationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyInput:
            return NSLocalizedString("Please enter the verification code that was sent to you", comment: "")
        case .invalidLength:
            return NSLocalizedString("invalid length", comment: "")
        case .nonNumeric:
            return NSLocalizedString("only numeric value is allowed", comment: "")
        case .incorrect:
            return NSLocalizedString("incorrect passcode", comment: "")
        case .lockedOut:
            return NSLocalizedString("Exceeded maximum number of failed attempts, please login again", comment: "")
        case .invalidPasswordFormat:
            return NSLocalizedString("Please ensure that the password is at least 6 characters long, and has at least 1 uppercase, 1 lowercase, 1 number, and 1 special character", comment: "")
        }
    }
}

protocol VerificationViewModel {
    var type: VerificatonType { get } 
    var code: String { get set }
    var newPassword: String { get set }
    var codeLength: Int { get }
    var header: String { get }
    var image: UIImage { get }
    var codeFieldPlaceHolder: String { get }
    var newPasswordPlaceHolder: String { get }
    var instructions: NSAttributedString { get }
    var confirmButtonTitle: String { get }
    var footerText: NSAttributedString { get }
    func validate()->VerificationValidationError?
    func isResendCodeReq(_ urlString: String)-> Bool
    
    func showCodeField()->Bool
    func showNewPasswordField()->Bool
}

extension VerificationViewModel {
    func validate()->VerificationValidationError? {
        if self.code.isEmpty { return VerificationValidationError.emptyInput }
        if self.code.count != self.codeLength { return VerificationValidationError.invalidLength }
        if !StringUtil.shared.isNumericOnly(self.code) { return VerificationValidationError.nonNumeric }
        
        return nil
    }
    
    var codeLength: Int {
        get {
            return 6
        }
    }
    
    var codeFieldPlaceHolder: String {
        get {
            return "\(self.codeLength) digit code"
        }
    }
    
//    func isResendCodeReq(_ urlString: String)-> Bool {
//        return urlString == links.resendCode.rawValue
//    }
    
    func isResendCodeReq(_ urlString: String)-> Bool {
        return urlString == "Resend"
    }
    
    var newPasswordPlaceHolder: String {
        get {
            return "New password"
        }
    }
}
