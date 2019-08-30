//
//  User.swift
//  Cheq
//
//  Created by XUWEI LIANG on 22/8/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

struct AuthUser {
    let type:SocialLoginType
    let email:String
    let userId:String
    let username:String
    let avatarUrl:String
    var ref:Any?

    // unique key
    func uniqueAuthTokenKey()->String {
        let key = "\(type.rawValue),\(email),\(userId),\(username),\(avatarUrl)"
        return key.data(using: .utf16)?.base64EncodedString() ?? ""
    }

    // func  to return basic token 
    func authToken()->String? {
        return CKeychain.getValueByKey(self.uniqueAuthTokenKey())
    }

    // store authToken from keystore
    func saveAuthToken(_ authToken: String)-> Bool {
       return CKeychain.setValue(self.uniqueAuthTokenKey(), value: authToken)
    }

    // remove authToken from keystore
    func clearAuthToken()-> Bool {
        return CKeychain.setValue(self.uniqueAuthTokenKey(), value: "")
    }
}
