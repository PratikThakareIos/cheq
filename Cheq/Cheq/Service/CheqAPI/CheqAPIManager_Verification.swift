//
//  CheqAPIManager_EmailVerification.swift
//  Cheq
//
//  Created by Xuwei Liang on 8/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

extension CheqAPIManager {
    
    func requestEmailVerificationCode()->Promise<Void> {
        return Promise<Void>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                UsersAPI.requestUserSignupVerificationCodeWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in
                    if let error = err {
                        LoggingUtil.shared.cPrint(error)
                        resolver.reject(AuthManagerError.unableToRequestEmailVerificationCode); return
                    }
                    resolver.fulfill(())
                })
            }.catch {err in
                resolver.reject(AuthManagerError.unableToRequestEmailVerificationCode)
            }
        }
    }
    
    func validateEmailVerificationCode(_ req: PutUserSingupVerificationCodeRequest)->Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                UsersAPI.verifyUserSingupCodeWithRequestBuilder(request: req).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute { (response, err) in
                    if let error = err {
                        LoggingUtil.shared.cPrint(error.localizedDescription)
                        resolver.reject(AuthManagerError.unableToVerifyEmailVerificationCode); return
                    }
                    resolver.fulfill(authUser)
                }
            }.catch { err in
                resolver.reject(AuthManagerError.unableToVerifyEmailVerificationCode)
            }
        }
    }
}
