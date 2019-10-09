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

//    case msgRegToken = "msgRegToken"
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

    // push notification
    case apnsToken = "apnToken"
    case fcmToken = "fcmToken"

    // work activity log
    case vDotLog = "VDotLog"
    
    // active date
    case activeTime = "activeTime"
}

class CKeychain {
    
    let defaultDateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let shared = CKeychain()
    private init() { }
    
    func dateByKey(_ key: String)-> Date {
        guard let dateString = KeychainWrapper.standard.string(forKey: key) else {
            return 100.years.earlier
        }
        
        let date = Date(dateString: dateString, format: defaultDateTimeFormat)
        return date
    }
    
    func setDate(_ key: String, date: Date)-> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = defaultDateTimeFormat
        let dateString = dateFormatter.string(from: date)
        return KeychainWrapper.standard.set(dateString, forKey: key)
    }

    func getValueByKey(_ key: String)-> String {
        let result = KeychainWrapper.standard.string(forKey: key) ?? ""
        return result
    }

    func setValue(_ key: String, value: String)-> Bool {
        return KeychainWrapper.standard.set(value, forKey: key)
    }

    func setDictionary(_ key: String, dictionary: Dictionary<String,Any>)-> Bool {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return KeychainWrapper.standard.set(jsonData, forKey: key)
        } catch {
            return false
        }
    }

    func getDictionaryByKey(_ key: String)-> Dictionary<String, Any> {
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
    
    func clearKeychain() {
        // clear old keychain items
        let _ = CKeychain.shared.setValue(CKey.apnsToken.rawValue, value: "")
        let _ = CKeychain.shared.setValue(CKey.fcmToken.rawValue, value: "")
        let _ = CKeychain.shared.setValue(CKey.authToken.rawValue, value: "")
        let _ = CKeychain.shared.setValue(CKey.fbToken.rawValue, value: "")
        
        // setup keychain items
        // work activity log
        let _ = CKeychain.shared.setValue(CKey.vDotLog.rawValue, value: "")
        // active date
        let formatter = DateUtil.shared.defaultDateFormatter()
        let _ = CKeychain.shared.setValue(CKey.activeTime.rawValue, value: formatter.string(from: 100.years.earlier))
        
        // clear the passcode data
        let _ = CKeychain.shared.setValue(CKey.passcodeLock.rawValue, value: "")
        let _ = CKeychain.shared.setValue(CKey.confirmPasscodeLock.rawValue, value: "")
        let _ = CKeychain.shared.setValue(CKey.numOfFailedAttempts.rawValue, value: String(0))
        
        let _ = CKeychain.shared.setValue(CKey.loggedInEmail.rawValue, value: "")
        
        // clear sdk keys
        let _ = CKeychain.shared.setValue(CKey.onfidoSdkToken.rawValue, value: "")
        let _ = CKeychain.shared.setValue(CKey.bluedotAPIKey.rawValue, value: "")
    }
}
