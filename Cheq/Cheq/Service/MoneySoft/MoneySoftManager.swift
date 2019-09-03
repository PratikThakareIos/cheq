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
