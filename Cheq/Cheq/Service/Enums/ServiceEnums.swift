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
    case require2FAVerificationCode
    case requireMFA(reason: String)
    case unableToLoginWithCredential
    case unableToRetrieveMoneySoftCredential
    case unableToRetrieveUserProfile
    case unableToRetrieveFinancialInstitutions
    case unableToRetrieveFinancialInstitutionSignInForm
    case unableToRetreiveLinkableAccounts
    case unableToLinkAccounts
    case unableToRefreshTransactions 
    case unableToLoginWithBankCredentials
    case unableToUpdateDisabledAccountCredentials
    case unableToForceUnlinkAllAccounts
    case unableToUnlinkAccounts
    case unknown
}

enum AuthManagerError: Error {
    case invalidRegistrationFields
    case unableToRegisterExistingEmail
    case unableToRegisterWithMissingFBToken
    case unableToRetrieveAuthToken
    case unableToRetrieveFBToken
    case unableToRetrieveCredential
    case unableToSignIn
    case unableInvalidEmail
    case unableToStoreAuthToken
    case unableToCleanAuthToken
    case unableToRetrieveCurrentUser
    case unableToDeleteCurrentUserAccount
    case unableToUpdatePassword
    case unableToSendPasswordResetLink
    case unknown
}

extension AuthManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidRegistrationFields:
        return NSLocalizedString("Invalid registration fields", comment: "")
        case .unableToRegisterExistingEmail:
        return NSLocalizedString("Unable to register an existing email", comment: "")
        case .unableToRegisterWithMissingFBToken:
        return NSLocalizedString("Unable to register with missing facebook token", comment: "")
        case .unableToRetrieveAuthToken:
        return NSLocalizedString("Unable to retrieve auth token", comment: "")
        case .unableToRetrieveFBToken:
        return NSLocalizedString("Unable to retrieve facebook token", comment: "")
        case .unableToRetrieveCredential:
        return NSLocalizedString("Unable to retrieve credentials", comment: "")
        case .unableToSignIn:
        return NSLocalizedString("Error during to sign in", comment: "")
        case .unableInvalidEmail:
        return NSLocalizedString("Invalid email", comment: "")
        case .unableToStoreAuthToken:
        return NSLocalizedString("Unable to store auth token", comment: "")
        case .unableToCleanAuthToken:
        return NSLocalizedString("Unable to clean up auth token", comment: "")
        case .unableToRetrieveCurrentUser:
        return NSLocalizedString("Unable to retrieve current logged in user", comment: "")
        case .unableToDeleteCurrentUserAccount:
        return NSLocalizedString("Unable to delete current logged in user", comment: "")
        case .unableToUpdatePassword:
        return NSLocalizedString("Unable to update password", comment: "")
        case .unableToSendPasswordResetLink:
        return NSLocalizedString("Unable to send password reset link", comment: "")
        case .unknown:
        return NSLocalizedString("An error has occurred", comment: "")
        }
    }
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
    case msSecurityNo = "msSecurityNo"
    case msUsername = "msUsername"
    case msPassword = "msPassword"
    case msOtp = "msOtp"
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
