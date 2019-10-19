//
//  ServiceEnums.swift
//  Cheq
//
//  Created by XUWEI LIANG on 22/8/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation

enum HttpHeaderKeyword: String {
    case authorization = "Authorization"
    case bearer = "Bearer "
}

enum CKeychainError: Error {
    case unableToStore
}

enum ValidationError: Error {
    case allFieldsMustBeFilled
    case invalidMobileFormat
    case invalidInputFormat
    case invalidNameFormat
    case invalidEmailFormat
    case invalidPasswordFormat
    case onlyAlphabetCharactersIsAllowed
    case onlyNumericCharactersIsAllowed
    case unableToMapSelectedBank
}

enum CheqAPIManagerError: Error, Equatable {
    case unableToPerformKYCNow
    case errorHasOccurredOnServer
    case unableToParseResponse
    case invalidInput
    case onboardingRequiredFromGetUserDetails
}

enum CheqAPIManagerError_Spending: Error {
    case unableToRetrieveOverview
    case unableToRetrieveTransactions
    
}

enum CheqAPIManagerError_Lending: Error {
    case unableToRetrieveLendingOverview
    case unableToRetrieveLoanPreview
    case unableToPutBankDetails
    case unableToResolveNameConflict
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
    case unableToUpdateTransactions
    case unableToRefreshTransactions
    case unableToRegisterNotificationToken
    case errorFromHandleNotification
    case unableToGetAccounts 
    case unableToRefreshAccounts
    case unableToLoginWithBankCredentials
    case unableToUpdateDisabledAccountCredentials
    case unableToForceUnlinkAllAccounts
    case unableToUnlinkAccounts
    case unknown
}

enum AuthManagerError: Error {
    case invalidRegistrationFields
    case invalidLoginFields
    case invalidFinancialInstitutionSelected
    case unableToRegisterExistingEmail
    case unableToRegisterWithMissingFBToken
    case unableToRetrieveAuthToken
    case unableToRetrieveFBToken
    case unableToRetrieveFBProfile
    case unableToRetrieveCredential
    case unableToSignIn
    case unableInvalidEmail
    case unableToRequestEmailVerificationCode
    case unableToVerifyEmailVerificationCode
    case unableToStoreAuthToken
    case unableToCleanAuthToken
    case unableToRetrieveCurrentUser
    case unableToDeleteCurrentUserAccount
    case unableToUpdatePassword
    case unableToSendPasswordResetLink
    case unknown
}

extension CheqAPIManagerError_Spending: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unableToRetrieveOverview:
            return NSLocalizedString("Unable to retrieve spending overview, please try again later.", comment: "")
        case .unableToRetrieveTransactions:
            return NSLocalizedString("Unable to retrieve transactions, please try again later.", comment: "")
        }
    }
}

extension CheqAPIManagerError_Lending: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unableToRetrieveLendingOverview:
            return NSLocalizedString("Unable to retrieve lending overview, please try again later.", comment: "")
        case .unableToPutBankDetails:
            return NSLocalizedString("Unable to update bank details, please try again later.", comment: "")
        case .unableToResolveNameConflict:
            return NSLocalizedString("Unable to resolve name conflict", comment: "")
        case .unableToRetrieveLoanPreview:
            return NSLocalizedString("Unable to retrieve loan preview", comment: "")
        }
    }
}

extension CheqAPIManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .errorHasOccurredOnServer:
            return NSLocalizedString("Error has occurred on server", comment: "")
        case .invalidInput:
            return NSLocalizedString("Invalid input", comment: "")
        case .unableToParseResponse:
            return NSLocalizedString("Server error", comment: "")
        case .unableToPerformKYCNow:
            return NSLocalizedString("Unable to perform KYC operation now", comment: "")
        case .onboardingRequiredFromGetUserDetails:
            return NSLocalizedString("Onboarding process required", comment: "")
        }
    }
}

extension ValidationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .allFieldsMustBeFilled:
            return NSLocalizedString("All fields must be entered", comment: "")
        case .invalidInputFormat:
            return  NSLocalizedString("Invalid input format", comment: "")
        case .invalidNameFormat:
            return NSLocalizedString("Invalid name format", comment: "")
        case .invalidMobileFormat:
            return NSLocalizedString("Invalid mobile format", comment: "")
        case .invalidEmailFormat:
            return NSLocalizedString("Invalid email format", comment: "")
        case .invalidPasswordFormat:
            return NSLocalizedString("Invalid password format. Password must be more than 6 characters, with at least one capital, numeric or special character (@,!,#,$,%,&,?)", comment: "")
        case .unableToMapSelectedBank:
            return NSLocalizedString("Internal error with mapping selection", comment: "")
        case .onlyAlphabetCharactersIsAllowed:
            return NSLocalizedString("Only alphabet characters is allowed", comment: "")
        case .onlyNumericCharactersIsAllowed:
            return NSLocalizedString("Only numeric characteres is allowed", comment: "")
        }
    }
}

extension AuthManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidRegistrationFields:
        return NSLocalizedString("Invalid registration fields", comment: "")
        case .invalidLoginFields:
        return NSLocalizedString("Invalid login fields", comment: "")
        case .invalidFinancialInstitutionSelected:
        return NSLocalizedString("Invalid Financial Institution", comment: "")
        case .unableToRegisterExistingEmail:
        return NSLocalizedString("Unable to register an existing email", comment: "")
        case .unableToRegisterWithMissingFBToken:
        return NSLocalizedString("Unable to register with missing facebook token", comment: "")
        case .unableToRetrieveAuthToken:
        return NSLocalizedString("Unable to retrieve auth token", comment: "")
        case .unableToRetrieveFBToken:
        return NSLocalizedString("Unable to retrieve facebook token", comment: "")
        case .unableToRetrieveFBProfile:
        return NSLocalizedString("Unable to retrieve facebook profile", comment: "")
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
        case .unableToRequestEmailVerificationCode:
        return NSLocalizedString("An error has occurred", comment: "")
        case .unableToVerifyEmailVerificationCode:
        return NSLocalizedString("Unable to validate verification code", comment: "")
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
