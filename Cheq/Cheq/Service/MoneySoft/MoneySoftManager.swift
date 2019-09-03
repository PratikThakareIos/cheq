//
//  MoneySoftManager.swift
//  Cheq
//
//  Created by Xuwei Liang on 2/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import MobileSDK
import PromiseKit

class MoneySoftManager {
    static let shared = MoneySoftManager()
    let API_BASE_URL = "https://api.beta.moneysoft.com.au"
    let API_REFERRER = "https://cheq.beta.moneysoft.com.au"
    
    private init() {
        let config = MoneysoftApiConfiguration.init(apiUrl: API_BASE_URL, apiReferrer: API_REFERRER, view: UIView())
        MoneysoftApi.configure(config)
    }
    
    func login(_ credentials: [LoginCredentialType: String])-> Promise<AuthenticationModel> {
        return Promise<AuthenticationModel>() { resolver in
            
            var loginModel: LoginModel
            if let otp = credentials[.msOtp] {
                loginModel = LoginModel(username: credentials[.msUsername] ?? "", password: credentials[.msPassword] ?? "", verification: otp)
            } else {
                loginModel = LoginModel(username: credentials[.msUsername] ?? "", password: credentials[.msPassword] ?? "")
            }
            do {
            let msApi = MoneysoftApi()
                try msApi.user().login(details: loginModel, listener:ApiListener<AuthenticationModel>(successHandler: { authModel in
                    guard let model = authModel else { resolver.reject(MoneySoftManagerError.unableToLoginWithCredential);
                        return
                    }
                    
                    resolver.fulfill(model)
                }, errorHandler: { errorModel in
                
                    if let err: ApiErrorModel = errorModel {
                        print(err.description)
                        print(err.code)
                    }
                    resolver.reject(MoneySoftManagerError.unableToLoginWithCredential)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToLoginWithCredential)
            }
        }
    }
    
    func putUserDetails(_ loggedInUser: AuthUser, putUserReq: PutUserRequest)->Promise<Bool> {
        return Promise<Bool>() { resolver in
            let token = loggedInUser.authToken() ?? ""
            UsersAPI.putUserWithRequestBuilder(request: putUserReq).addHeader(name: "Authorization", value: String("Bearer \(token)")).execute { _, error in
                if let err = error { resolver.reject(err); return }
                resolver.fulfill(true)
            }
        }
    }
    
    func getUserDetails(_ loggedInUser: AuthUser)-> Promise<MoneySoftUser> {
        return Promise<MoneySoftUser>() { resolver in
            
            let token = loggedInUser.authToken() ?? ""
            UsersAPI.getUserWithRequestBuilder().addHeader(name: "Authorization", value: String("Bearer \(token)")).execute() { (response, error) in
                
                guard let msUser: GetUserResponse = response?.body else { resolver.reject(error ?? MoneySoftManagerError.unableToRetrieveMoneySoftCredential); return}
                let username = msUser.moneySoftCredential?.msUsername ?? ""
                let password = msUser.moneySoftCredential?.msPassword ?? ""
                let moneySoftUser = MoneySoftUser(username: username, passwd: password, otp: "")
                resolver.fulfill(moneySoftUser)
            }
        }
    }
}
