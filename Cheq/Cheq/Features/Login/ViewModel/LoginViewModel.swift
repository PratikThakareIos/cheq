//
//  LoginViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 7/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

class LoginViewModel: BaseViewModel {
    func load(_ complete: @escaping ()->Void) {
        complete()
    }
    
    func login(_ email: String, password: String)-> Promise<AuthUser> {
        var credentials: [LoginCredentialType: String] = [:]
        credentials[.email] = email
        credentials[.password] = password
        return AuthConfig.shared.activeManager.login(credentials)
    }
}
