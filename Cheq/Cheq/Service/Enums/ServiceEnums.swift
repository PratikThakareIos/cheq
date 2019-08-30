//
//  ServiceEnums.swift
//  Cheq
//
//  Created by XUWEI LIANG on 22/8/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation

enum CKeychainError: Error {
    case unableToStore
}

enum AuthManagerError: Error {
    case unableToRegisterExistingEmail
    case unableToRegisterWithMissingFBToken
    case unableToRetrieveAuthToken
    case unableToRetrieveCredential
    case unableToSignIn
    case unableToStoreAuthToken
    case unableToCleanAuthToken
    case unableToRetrieveCurrentUser
    case unableToDeleteCurrentUserAccount
    case unableToUpdatePassword
    case unableToSendPasswordResetLink
    case unknown
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum SocialLoginType: String {
    case socialLoginEmail = "Email"
    case socialLoginFB = "Facebook"
}

enum LoginCredentialType: String {
    case email = "email"
    case password = "password"
    case token = "token"
}
