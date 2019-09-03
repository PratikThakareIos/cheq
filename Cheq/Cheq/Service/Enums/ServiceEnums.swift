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

enum MoneySoftManagerError: Error {
    case unableToRetrieveMoneySoftCredential
    case unknown
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
    case otp = "otp"
    case token = "token"
}

enum PersonalDetailsType: String {
    case firstname = "firstname"
    case lastname = "lastname"
    case mobile = "mobile"
    case residentialAddress = "residentialAddress"
}

enum EmployerType: String {
    case employerName = "employerName"
    case employmentType = "employmentType"
    case workAddress = "workAddress"
    case noFixedAddress = "noFixedAddress"
    case latitude = "latitude"
    case longitude = "longitude"
}


