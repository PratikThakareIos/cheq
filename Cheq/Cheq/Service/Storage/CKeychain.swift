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
    

    // auth token
    case authToken = "authToken"
    // fb token
    case fbToken = "fbToken"
    
    // auth user details
    case loggedInEmail = "userEmail"

    // screen lock passcode
    case passcodeLock = "passcodeLock"
    case confirmPasscodeLock = "confirmPasscodeLock"
    case numOfFailedAttempts = "numOfFailedAttempts"
    
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
    
    // active date
    case activeTime = "activeTime"
}

struct CKeychain {
    
    static let defaultDateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    static func dateByKey(_ key: String)-> Date {
        guard let dateString = KeychainWrapper.standard.string(forKey: key) else {
            return 100.years.earlier
        }
        
        let date = Date(dateString: dateString, format: defaultDateTimeFormat)
        return date
    }
    
    static func setDate(_ key: String, date: Date)-> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = defaultDateTimeFormat
        let dateString = dateFormatter.string(from: date)
        return KeychainWrapper.standard.set(dateString, forKey: key)
    }

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
