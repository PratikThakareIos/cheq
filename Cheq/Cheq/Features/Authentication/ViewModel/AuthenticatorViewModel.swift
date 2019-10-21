//
//  RegistrationViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
import FBSDKCoreKit

enum links: String {
    case toc = "https://cheq.com.au/terms-conditions"
    case privacy = "https://cheq.com.au/privacy-policy"
    
    // internal screens
    case login = "http://login.cheq.com"
    case signup = "http://signup.cheq.com"
    case forgot = "http://forgot.cheq.com"
    case resendForgot = "http://resendCode.forgot.cheq.com"
    case resendCode = "http://resendCode.cheq.com"
    case email = "http://email.cheq.com.au"
}

class AuthenticatorViewModel: BaseViewModel {

    func registerWithFBAccessToken(_ token: String)-> Promise<AuthUser> {
        return AuthConfig.shared.activeManager.registerWithFB(token)
    }
    
    func fetchProfileWithFBAccessToken()-> Promise<Void> {
        return Promise<Void>() { resolver in
            guard AccessToken.isCurrentAccessTokenActive else { resolver.reject(AuthManagerError.unableToRetrieveFBToken); return }
            Profile.loadCurrentProfile { (profile, err) in
                if err != nil { resolver.reject(AuthManagerError.unableToRetrieveFBProfile); return }
                let qVm = QuestionViewModel()
                qVm.loadSaved()
                qVm.save(QuestionField.firstname.rawValue, value: profile?.firstName ?? "")
                qVm.save(QuestionField.lastname.rawValue, value: profile?.lastName ?? "")
                resolver.fulfill(())
            }
        }
    }
    
    func register(_ email: String, password: String, confirmPassword: String)-> Promise<AuthUser> {
        return self.validateRegistrationInput(email, password: password, confirmPassword: confirmPassword).then { ()-> Promise<AuthUser> in
            var credentials: [LoginCredentialType: String] = [:]
            credentials[.email] = email
            credentials[.password] = password
            return AuthConfig.shared.activeManager.register(.socialLoginEmail, credentials: credentials)
        }
    }
    
    func login(_ email: String, password: String)-> Promise<AuthUser> {
        return self.validateLoginInput(email, password: password).then { ()-> Promise<AuthUser> in
            var credentials: [LoginCredentialType: String] = [:]
            credentials[.email] = email
            credentials[.password] = password
            return AuthConfig.shared.activeManager.login(credentials)
        }
    }
    
    func validateLoginInput(_ email: String, password: String)-> Promise<Void> {
        return Promise<Void>() { resolver in
            guard email.isEmpty == false, password.isEmpty == false else {
                resolver.reject(AuthManagerError.invalidLoginFields); return
            }
            
            resolver.fulfill(())
        }
    }

    
    func validateRegistrationInput(_ email: String, password: String, confirmPassword: String)-> Promise<Void> {
        return Promise<Void>() { resolver in
            guard email.isEmpty == false, password.isEmpty == false, confirmPassword.isEmpty == false else {
                resolver.reject(AuthManagerError.invalidRegistrationFields); return
            }
            
            if password != confirmPassword {
                resolver.reject(AuthManagerError.invalidRegistrationFields); return
            }
            
            resolver.fulfill(())
        }
    }
    
    func isForgotPassword(_ linkUrl: String)-> Bool {
        return linkUrl == links.forgot.rawValue
    }
    
    func isLogin(_ linkUrl: String)-> Bool {
        return linkUrl == links.login.rawValue
    }
    
    func isSignup(_ linkUrl: String)-> Bool {
        return linkUrl == links.signup.rawValue
    }
}

extension AuthenticatorViewModel {
    
    func conditionsAttributedText()-> NSAttributedString {
        let text = NSMutableAttributedString(string: "By creating an account, you accept Cheq's Terms of Use and Private Policy")
        text.applyLinkTo("Terms of Use", link: links.toc.rawValue, color: AppConfig.shared.activeTheme.linksColor, font:  AppConfig.shared.activeTheme.defaultFont)
        text.applyLinkTo("Private Policy", link: links.privacy.rawValue, color: AppConfig.shared.activeTheme.linksColor, font: AppConfig.shared.activeTheme.defaultFont)
        return text
    }
    
    func loginInText()-> NSAttributedString {
        let text = NSMutableAttributedString(string: "Already have an account? Log in")
        text.applyLinkTo("Log in", link: links.login.rawValue, color: AppConfig.shared.activeTheme.linksColor, font: AppConfig.shared.activeTheme.mediumFont)
        return text
    }
    
    func signUpText()-> NSAttributedString {
        let text = NSMutableAttributedString(string: "Don't have an account? Sign up")
        text.applyLinkTo("Sign up", link: links.signup.rawValue, color: AppConfig.shared.activeTheme.linksColor, font: AppConfig.shared.activeTheme.mediumFont)
        return text
    }
    
    func forgotPasswordAttributedText()-> NSAttributedString {
        let text = NSMutableAttributedString(string: "Forgot your password?")
        text.applyLinkTo("Forgot your password?", link: links.forgot.rawValue, color: AppConfig.shared.activeTheme.linksColor, font:  AppConfig.shared.activeTheme.defaultFont)
        return text
    }
}
