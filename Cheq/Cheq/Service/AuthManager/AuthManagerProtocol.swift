//
//  AuthManager.swift
//  Cheq
//
//  Created by XUWEI LIANG on 22/8/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation
import PromiseKit
import FBSDKLoginKit

protocol AuthManagerProtocol {

    //MARK: User authentication + security management
    func register(_ socialLogin: SocialLoginType, credentials:[LoginCredentialType: String])->Promise<AuthUser>
    func login(_ credentials:[LoginCredentialType: String])-> Promise<AuthUser>
    func logout(_ authUser: AuthUser)-> Promise<Void>
    func reAuthenticate(_ socialLogin: SocialLoginType, credentials:[LoginCredentialType: String])-> Promise<AuthUser>
    func sendVerificationEmail()-> Promise<Bool>

    func updatePassword(_ credentials: [LoginCredentialType: String]) -> Promise<Void>
    func sendResetPassword(_ credentials: [LoginCredentialType: String]) -> Promise<Void>
    func removeUserAcct(_ user: AuthUser)-> Promise<Void>

    //MARK: Local user management methods
    func getCurrentUser()-> Promise<AuthUser>
    func setUser(_ user: AuthUser)-> Promise<AuthUser>

    var timeout: Double { get }
    
    func messagingRegistrationToken()-> String
    func storeMessagingRegistrationToken(_ token: String)-> Promise<Bool>
    func setupForRemoteNotifications(_ application: UIApplication, delegate: Any)
    func currentFacebookToken()-> String?
}

//MARK: Local user management methods default implementation
extension AuthManagerProtocol {

    // default timeout 
    var timeout: Double {
        get {
            return 15.0
        }
    }
    
    func messagingRegistrationToken()-> String {
        return CKeychain.shared.getValueByKey(CKey.fcmToken.rawValue)
    }
    
    func storeMessagingRegistrationToken(_ token: String)-> Promise<Bool> {
        return Promise<Bool>() { resolver in
            let success = CKeychain.shared.setValue(CKey.fcmToken.rawValue, value: token)
            resolver.fulfill(success)
        }
    }
    
    func currentFacebookToken()-> String? {
        var token: String?
        if AccessToken.isCurrentAccessTokenActive {
            token = AccessToken.current?.tokenString
        }
        return token
    }
}


