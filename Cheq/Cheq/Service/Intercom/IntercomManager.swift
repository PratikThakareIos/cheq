//
//  IntercomManager.swift
//  Cheq
//
//  Created by Xuwei Liang on 17/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import Intercom
import PromiseKit

class IntercomManager {
    static let shared = IntercomManager()
    private init() {
        Intercom.setApiKey(AppData.shared.intercomAPIKey, forAppId: AppData.shared.intercomAppId)
    }
    
    func present() {
        let userAttributes = ICMUserAttributes()
        let qvm = QuestionViewModel()
        qvm.loadSaved()
        
        userAttributes.customAttributes = IntercomPersonalData(firstName: qvm.fieldValue(.firstname), lastName: qvm.fieldValue(.lastname), email: CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue), cheqId: AppData.shared.fbAppId, bankName: qvm.fieldValue(.bankName), workAddress: qvm.fieldValue(.employerAddress), mobile: qvm.fieldValue(.contactDetails), appVersion: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "v1",errorStep: "Connecting to bank",cid:AuthConfig.shared.activeUser?.userId ?? "").dictionary
         Intercom.updateUser(userAttributes)
        
    //MARK: Present the UI after passing the parameters to the Intercome API
        Intercom.presentMessenger()
    }
    
    func logoutIntercom()->Promise<Void> {
        return Promise<Void>() { resolver in
            Intercom.logout()
            resolver.fulfill(())
        }
    }
    
    func loginIntercom()->Promise<AuthUser> {
        
        return Promise<AuthUser>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let userId = authUser.userId
                Intercom.registerUser(withUserId: userId)
                resolver.fulfill(authUser)
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
}

//Struct represents the parameters to be passed on to the Intercome API
struct IntercomPersonalData:Codable {
    let firstName:String
    let lastName:String
    let email:String
    let cheqId:String
    let bankName:String
    let workAddress:String
    let mobile:String
    let appVersion:String
    let errorStep:String
    let cid:String
    
}

//Converts a struct in to a dictionary
struct JSON {
    static let encoder = JSONEncoder()
}
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}

