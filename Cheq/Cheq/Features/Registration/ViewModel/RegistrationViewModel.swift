//
//  RegistrationViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

enum links: String {
    case toc = "http://cheq.com.au"
    case privacy = "http://cheq.com.au/blog"
    case login = "http://login.cheq.com"
}

class RegistrationViewModel: BaseViewModel {
    
    let fbAppId = "2855589534666837"
    let fbAppSecret = "87b757a52a9b7db61fce607278c4aa2e"

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

    func load(_ complete: @escaping () -> Void) {
    }
    
    func registerWithFBAccessToken(_ token: String)-> Promise<AuthUser> {
        return AuthConfig.shared.activeManager.registerWithFB(token)
    }
    
    func register(_ email: String, password: String, confirmPassword: String)-> Promise<AuthUser> {
        switch validateInput(email, password: password, confirmPassword: confirmPassword) {
        case .failure(let err):
            return Promise<AuthUser>() { resolver in
                resolver.reject(err)
            }
        case .success: break
        }
        var credentials: [LoginCredentialType: String] = [:]
        credentials[.email] = email
        credentials[.password] = password
        return AuthConfig.shared.activeManager.register(.socialLoginEmail, credentials: credentials)
    }
    
    func validateInput(_ email: String, password: String, confirmPassword: String)-> Result<Void> {
        guard email.isEmpty == false, password.isEmpty == false, confirmPassword.isEmpty == false else {
            return .failure(AuthManagerError.invalidRegistrationFields)
        }
        
        if password != confirmPassword {
            return .failure(AuthManagerError.invalidRegistrationFields)
        }
        
        return .success(())
    }
    
    func isLogin(_ linkUrl: String)-> Bool {
        return linkUrl == links.login.rawValue
    }
}
