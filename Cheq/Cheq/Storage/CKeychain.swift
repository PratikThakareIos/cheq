//
//  CKeychain.swift
//  Cheq
//
//  Created by XUWEI LIANG on 22/8/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

enum CKey: String {

    // auth user details
    case email
    case passwd

    // customer details
    case firstName
    case middleName
    case lastName
    case fullName
    case residentialAddress

    // push notification
    case apnToken
    case fireBasePushToken

    // moneySoft
    case moneySoftUserName
    case moneySoftPassword

    // linked bank
    case bankName
    case bankLogin
    case bankPassword
}

struct CKeychain {

    static func getValueByKey(_ key: String)-> String? {
        let result = KeychainWrapper.standard.string(forKey: key)
        return result
    }

    static func setValue(_ key: String, value: String)-> Bool {
        return KeychainWrapper.standard.set(value, forKey: key)
    }
}
