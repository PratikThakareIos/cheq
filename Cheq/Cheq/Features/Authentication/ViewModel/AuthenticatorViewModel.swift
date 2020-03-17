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
import FRHyperLabel

enum links: String {
    case toc = "https://cheq.com.au/terms-conditions" //"https://cheq.com.au/terms"
    case privacy = "https://cheq.com.au/privacy-policy" //"https://cheq.com.au/privacy"
     
    // internal screens
    case logout = "http://app.logout.cheq.com.au"
    case login = "http://app.login.cheq.com.au"
    case signup = "http://app.signup.cheq.com.au"
    case forgot = "http://app.forgot.cheq.com.au"
    case resendForgot = "http://app.resendCode.forgot.cheq.com.au"
    case resendCode = "http://app.resendCode.cheq.com.au"
    case email = "http://app.email.cheq.com.au"
    case helpAndSupport = "http://app.helpAndSupport.cheq.com.au"
    case appSetting = "http://app.setting.cheq.com.au"
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
    
//    func isForgotPassword(_ linkUrl: String)-> Bool {
//        return linkUrl == links.forgot.rawValue
//    }
//
//    func isLogin(_ linkUrl: String)-> Bool {
//        return linkUrl == links.login.rawValue
//    }
//
//    func isSignup(_ linkUrl: String)-> Bool {
//        return linkUrl == links.signup.rawValue
//    }
    
    func isForgotPassword(_ linkUrl: String)-> Bool {
        return linkUrl == "Forgot your password?"
    }
    
    func isLogin(_ linkUrl: String)-> Bool {
        return linkUrl == "Log in"
    }
    
    func isSignup(_ linkUrl: String)-> Bool {
        return linkUrl == "Register"
    }
    
}

extension AuthenticatorViewModel {
    
//    func conditionsAttributedText()-> NSAttributedString {
//
//        let style = NSMutableParagraphStyle()
//        style.alignment = .center
//        let text = NSMutableAttributedString(string:"By creating an account, you accept Cheq's Terms of Use and Private Policy" ,
//                                      attributes: [NSAttributedString.Key.paragraphStyle:style])
//
//       // let text = NSMutableAttributedString(string: "By creating an account, you accept Cheq's Terms of Use and Private Policy")
//        text.applyLinkTo("Terms of Use", link: links.toc.rawValue, color: AppConfig.shared.activeTheme.linksColor, font:  AppConfig.shared.activeTheme.defaultFont)
//        text.applyLinkTo("Private Policy", link: links.privacy.rawValue, color: AppConfig.shared.activeTheme.linksColor, font: AppConfig.shared.activeTheme.defaultFont)
//        return text
//    }
    
    
//    func loginInText()-> NSAttributedString {
//
//        let style = NSMutableParagraphStyle()
//        style.alignment = .center
//        let text = NSMutableAttributedString(string: "Already have an account? Log in",
//                                      attributes: [NSAttributedString.Key.paragraphStyle:style])
//
//
//       // let text = NSMutableAttributedString(string: "Already have an account? Log in")
//        text.applyLinkTo("Log in", link: links.login.rawValue, color: AppConfig.shared.activeTheme.linksColor, font: AppConfig.shared.activeTheme.mediumFont)
//        return text
//    }
   
//    func signUpText()-> NSAttributedString {
//          let text = NSMutableAttributedString(string: "Don’t have an account? Register")
//          text.applyLinkTo("Sign up", link: links.signup.rawValue, color: AppConfig.shared.activeTheme.linksColor, font: AppConfig.shared.activeTheme.mediumFont)
//          return text
//    }
   
//    func forgotPasswordAttributedText()-> NSAttributedString {
//        let text = NSMutableAttributedString(string: "Forgot your password?")
//        text.applyLinkTo("Forgot your password?", link: links.forgot.rawValue, color: AppConfig.shared.activeTheme.linksColor, font:  AppConfig.shared.activeTheme.defaultFont)
//        return text
//    }
    
    func conditionsAttributedText()-> NSAttributedString {
        let string = "Terms of Use & Private Policy"
        //let font = UIFont.init(name: "SFProText-Regular", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0, weight: .medium)
        let font = AppConfig.shared.activeTheme.mediumFont
        let attributes = [NSAttributedString.Key.foregroundColor: AppConfig.shared.activeTheme.textColor,
                               NSAttributedString.Key.font: font]
        let text = NSMutableAttributedString(string: string, attributes: attributes)
        return text
    }
    
    func loginInText()-> NSAttributedString {
        let string = "Already have an account? Log in"
        //let font = UIFont.init(name: "SFProText-Regular", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0, weight: .medium)
        let font = AppConfig.shared.activeTheme.mediumFont
        let attributes = [NSAttributedString.Key.foregroundColor: AppConfig.shared.activeTheme.textColor,
                               NSAttributedString.Key.font: font]
        let text = NSMutableAttributedString(string: string, attributes: attributes)
        return text
    }
    
    func signUpText()-> NSAttributedString {
        let string = "Don’t have an account? Register"
        let attributes = [NSAttributedString.Key.foregroundColor: AppConfig.shared.activeTheme.altTextColor,
                                     NSAttributedString.Key.font: AppConfig.shared.activeTheme.mediumFont]
        let text = NSMutableAttributedString(string: string, attributes: attributes)
        return text
    }
    
    func forgotPasswordAttributedText()-> NSAttributedString {
          let string = "Forgot your password?"
          let attributes = [NSAttributedString.Key.foregroundColor: AppConfig.shared.activeTheme.textColor,
                                       NSAttributedString.Key.font: AppConfig.shared.activeTheme.mediumFont]
          let text = NSMutableAttributedString(string: string, attributes: attributes)
          return text
      }
    
    func setAttributeOnHyperLable(lable : FRHyperLabel) -> Void{
        
        let LinkColorDefault = AppConfig.shared.activeTheme.linksColor
        let LinkColorHighlight = AppConfig.shared.activeTheme.linksColor
        
        //let font = UIFont.init(name: "SFUIText-Medium", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0, weight: .medium)
        let font = AppConfig.shared.activeTheme.mediumMediumFont
        let linkAttributeDefault = [
            NSAttributedString.Key.foregroundColor:LinkColorDefault,
            NSAttributedString.Key.font: font
            ] as [NSAttributedString.Key : Any]
        lable.linkAttributeDefault = linkAttributeDefault
        
        let linkAttributeHighlight = [
            NSAttributedString.Key.foregroundColor:LinkColorHighlight,
            NSAttributedString.Key.font: font
            ] as [NSAttributedString.Key : Any]
        lable.linkAttributeHighlight = linkAttributeHighlight
    }
    
}

