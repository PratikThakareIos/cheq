//
//  FirebaseAuthManager.swift
//  Cheq
//
//  Created by XUWEI LIANG on 22/8/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseMessaging
import PromiseKit
import UserNotifications

class FirebaseAuthManager: AuthManagerProtocol {

    static let shared = FirebaseAuthManager()
    private init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

//MARK: active user management
extension FirebaseAuthManager {
    func getCurrentUser()-> Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
            if let authUser = AuthConfig.shared.activeUser {
                resolver.fulfill(authUser)
            } else {
                resolver.reject(AuthManagerError.unableToRetrieveCurrentUser)
            }
        }
    }

    func setUser(_ authUser: AuthUser)-> Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
            AuthConfig.shared.activeUser = authUser
            resolver.fulfill(authUser)
        }
    }
}

//MARK: password update, send password reset link
extension FirebaseAuthManager {

    func updatePassword(_ credentials: [LoginCredentialType: String]) -> Promise<Void> {
        return Promise<Void>() { resolver in
            if let user = Auth.auth().currentUser {
                user.updatePassword(to: credentials[.password] ?? "") { err in
                    if err != nil {
                        resolver.reject(err ?? AuthManagerError.unableToUpdatePassword)
                    } else {
                        resolver.fulfill(())
                    }
                }
            } else {
                resolver.reject(AuthManagerError.unableToRetrieveCurrentUser)
            }
        }
    }

    func sendResetPassword(_ credentials: [LoginCredentialType: String]) -> Promise<Void> {
        return Promise<Void>() { resolver in
            Auth.auth().sendPasswordReset(withEmail: credentials[.email] ?? "") { err in
                if err != nil {
                    resolver.reject(err ?? AuthManagerError.unableToSendPasswordResetLink)
                } else {
                    resolver.fulfill(())
                }
            }
        }
    }
}

//MARK: login, logout, re-authenticate
extension FirebaseAuthManager {

    func logout(_ authUser: AuthUser)-> Promise<Void> {
        return Promise<Void>() { resolver in
            if authUser.clearAuthToken() {
                do {
                    try Auth.auth().signOut()
                        resolver.fulfill(())
                } catch(let err) {
                    resolver.reject(err)
                }
            } else {
                resolver.reject(AuthManagerError.unableToCleanAuthToken)
            }
        }
    }

    func login(_ credentials:[LoginCredentialType: String])-> Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
            let email = credentials[.email] ?? ""
            let password = credentials[.password] ?? ""
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                guard let user = result?.user else { resolver.reject(error ?? AuthManagerError.unknown); return }
                let authUser = FirebaseAuthManager.buildAuthUser(.socialLoginEmail, user: user)
                resolver.fulfill(authUser)
            }
        }.then{ authUser in
            self.retrieveAuthToken(authUser)
        }.then { authUser in
            self.setUser(authUser)
        }
    }

    func reAuthenticate(_ socialLogin: SocialLoginType, credentials:[LoginCredentialType: String])-> Promise<AuthUser>  {
        return Promise<AuthUser>() { resolver in
            var credential: AuthCredential?
            switch socialLogin {
            case .socialLoginEmail:
                credential = EmailAuthProvider.credential(withEmail: credentials[.email] ?? "", password: credentials[.password] ?? "")
            case .socialLoginFB:
                credential = FacebookAuthProvider.credential(withAccessToken: credentials[.token] ?? "")
            }
            guard let authCredential = credential else { resolver.reject(AuthManagerError.unableToRetrieveCredential); return }
            guard let user = Auth.auth().currentUser else { resolver.reject(AuthManagerError.unableToRetrieveCurrentUser); return }
            user.reauthenticate(with: authCredential) { result, error in
                let authUser = FirebaseAuthManager.buildAuthUser(.socialLoginEmail, user: user)
                resolver.fulfill(authUser)
            }
            }
            .then { authUser in
                return self.retrieveAuthToken(authUser)
        }
    }

}

//MARK: registration
extension FirebaseAuthManager {

    // register + retrive authToken
    func register(_ socialLogin: SocialLoginType, credentials:[LoginCredentialType: String])-> Promise<AuthUser> {
        switch socialLogin {
        case .socialLoginEmail:
            let email = credentials[.email] ?? ""
            let password = credentials[.password] ?? ""
            return self.registerWithEmail(email, password: password)
            .then{ authUser in
                self.retrieveAuthToken(authUser)
            }
        case .socialLoginFB:
            let fbToken = credentials[.token] ?? ""
            return self.registerWithFB(fbToken)
            .then{ authUser in
                self.retrieveAuthToken(authUser)
            }
        }
    }

    func retrieveAuthToken(_ authUser: AuthUser)-> Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
            let firUser = authUser.ref as! User
            firUser.getIDTokenForcingRefresh(true, completion: { (authToken, error) in
                guard let token = authToken else { resolver.reject(AuthManagerError.unableToRetrieveAuthToken); return }
                let authUsr = authUser
                if authUsr.saveAuthToken(token) {
                    resolver.fulfill(authUsr)
                } else {
                    resolver.reject(AuthManagerError.unableToStoreAuthToken)
                }
            })
        }
    }

    func registerWithEmail(_ email: String, password: String)-> Promise<(AuthUser)> {

        return Promise<AuthUser>() { resolver in
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                guard let user = authResult?.user else { resolver.reject(error ?? AuthManagerError.unknown); return }
                let authUser = FirebaseAuthManager.buildAuthUser(.socialLoginEmail, user: user)
                resolver.fulfill(authUser)
            }
        }
    }

    func registerWithFB(_ fbToken: String)-> Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
            let credential = FacebookAuthProvider.credential(withAccessToken: fbToken)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                guard let user = authResult?.user else { resolver.reject(error ?? AuthManagerError.unknown); return }
                let authUser = FirebaseAuthManager.buildAuthUser(.socialLoginFB, user: user)
                resolver.fulfill(authUser)
            }
        }
    }
}

// MARK: send email verification
extension FirebaseAuthManager {

    func sendVerificationEmail()-> Promise<Bool> {
        return Promise<Bool>() { resolver in
            guard let user = Auth.auth().currentUser else { resolver.reject(AuthManagerError.unableToRetrieveCurrentUser); return }
            user.sendEmailVerification { error in
                if let err = error { resolver.reject(err) } else {
                    resolver.fulfill(true)
                }
            }
        }
    }
}

// MARK: util
extension FirebaseAuthManager {
    class func buildAuthUser(_ type: SocialLoginType, user: User)-> AuthUser {
        let authUser = AuthUser(type: type, email: user.email ?? "", userId: user.uid, username: user.displayName ?? "", avatarUrl: user.photoURL?.absoluteString ?? "", ref: user)
        return authUser
    }
}

// MARK: delete user account
extension FirebaseAuthManager {

    func removeUserAcct(_ user: AuthUser)-> Promise<Void> {
        return Promise<Void>() { resolver in
            if let user = Auth.auth().currentUser {
                user.delete { err in
                    if err != nil {
                        resolver.reject(err ?? AuthManagerError.unableToDeleteCurrentUserAccount)
                    } else {
                        resolver.fulfill(())
                    }
                }
            } else {
                resolver.fulfill(())
            }
        }
    }
}

extension FirebaseAuthManager {
    
    func registrationToken()-> Promise<String> {
        return Promise<String>() { resolver in
            InstanceID.instanceID().instanceID { (result, error) in
                if let error = error {
                    resolver.reject(error)
                } else if let result = result {
                    resolver.fulfill(result.token)
                }
            }
        }
    }

    func setupForRemoteNotifications(_ application: UIApplication, delegate: Any) {
        // Firebase Message delegate 
        if let messageDelegate = delegate as? MessagingDelegate {
            Messaging.messaging().delegate = messageDelegate
        }
        
        
        // setup for UserNotifications
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            if let userNotificationCenterDelegate = delegate as? UNUserNotificationCenterDelegate {
                UNUserNotificationCenter.current().delegate = userNotificationCenterDelegate
            }
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
}
