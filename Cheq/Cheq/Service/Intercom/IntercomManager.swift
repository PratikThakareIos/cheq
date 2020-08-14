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
        
        userAttributes.customAttributes = IntercomPersonalData(cFirstName: checkForNull(qvm.fieldValue(.firstname)),
                                                               cLastName: checkForNull(qvm.fieldValue(.lastname)),
                                                               cEmail: checkForNull(CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue)),
                                                               cBankName: checkForNull(qvm.fieldValue(.bankName)),
                                                               cAddress: checkForNull(qvm.fieldValue(.employerAddress)),
                                                               cMobile: checkForNull(qvm.fieldValue(.contactDetails)),
                                                               cAppVersion: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "v1",
                                                               cErrorStep: "Connecting to bank",
                                                               cid: AuthConfig.shared.activeUser?.userId ?? "").dictionary
         Intercom.updateUser(userAttributes)
        
    //MARK: Present the UI after passing the parameters to the Intercome API
        Intercom.presentMessenger()
    }
    
    func present(str_cErrorStep : String = "") {
           
           let userAttributes = ICMUserAttributes()
           let qvm = QuestionViewModel()
           qvm.loadSaved()

           userAttributes.customAttributes = IntercomPersonalData(cFirstName: checkForNull(qvm.fieldValue(.firstname)),
                                                                  cLastName: checkForNull(qvm.fieldValue(.lastname)),
                                                                  cEmail: checkForNull(CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue)),
                                                                  cBankName: checkForNull(qvm.fieldValue(.bankName)),
                                                                  cAddress: checkForNull(qvm.fieldValue(.employerAddress)),
                                                                  cMobile: checkForNull(qvm.fieldValue(.contactDetails)),
                                                                  cAppVersion: checkForNull(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "v1"),
                                                                  cErrorStep: checkForNull(str_cErrorStep),
                                                                  cid:checkForNull(AuthConfig.shared.activeUser?.userId ?? "")).dictionary
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
    
    func checkForNull(_ str:String?) -> String{
        if let strVal = str {
            return strVal
        }
        return ""
    }
}

//Struct represents the parameters to be passed on to the Intercome API
struct IntercomPersonalData:Codable {
    let cFirstName:String
    let cLastName:String
    let cEmail:String
    let cBankName:String
    let cAddress:String
    let cMobile:String
    let cAppVersion:String
    let cErrorStep:String
    let cid:String
    
}




