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

    case msgRegToken = "msgRegToken"
    case bluedotAPIKey = "bluedotAPIKey"
    case onfidoSdkToken = "onfidoSdkToken"
    case loggedInEmail = "userEmail"

    // auth token
    case authToken = "authToken"
    // fb token
    case fbToken = "fbToken"
    
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
    case apnsToken = "apnToken"
    case fcmToken = "fcmToken"
    case fireBasePushToken

    // moneySoft
    case moneySoftUserName
    case moneySoftPassword

    // linked bank
    case bankName
    case bankLogin
    case bankPassword

    // work activity log
    case vDotLog = "VDotLog"
}

struct CKeychain {

    static func getValueByKey(_ key: String)-> String {
        let result = KeychainWrapper.standard.string(forKey: key) ?? ""
        return result
    }

    static func setValue(_ key: String, value: String)-> Bool {
        return KeychainWrapper.standard.set(value, forKey: key)
    }

    static func setDictionary(_ key: String, dictionary: Dictionary<String,Any>)-> Bool {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return KeychainWrapper.standard.set(jsonData, forKey: key)
        } catch {
            return false
        }
    }

    static func getDictionaryByKey(_ key: String)-> Dictionary<String, Any> {
        guard let jsonData = KeychainWrapper.standard.data(forKey: key) else { return [:] }
        do {
            let jsonString = String(data: jsonData, encoding: .utf8)
            LoggingUtil.shared.cPrint(jsonString ?? "")
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? Dictionary<String, Any> ?? [:]
            return jsonDict
        } catch {
            return [:]
        }
    }
}
