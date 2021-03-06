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

enum RemoteConfigError: Error {
    case unableToFetchAndActivateRemoteConfig
    case unableToFetchInstitutions
    case unableToFetchRemoteConfigValue
}

enum ValidationError: Error {
    case allFieldsMustBeFilled
    case invalidMobileFormat
    case invalidInputFormat
    case invalidNameFormat
    case invalidEmailFormat
    case invalidPasswordFormat
    case invalidDriversLicenseFormat
    case invalidPostcodeFormat
    case invalidMedicareNumberFormat
    case invalidMedicarePositionFormat
    case onlyAlphabetCharactersIsAllowed
    case onlyNumericCharactersIsAllowed
    case unableToMapSelectedBank
    case autoCompleteIsMandatory
    case autoCompleteHomeAddressIsMandatory
    case invalidCompanyName
    case invalidBBSandAccountNO
    case dobIsMandatory
    //NNN
    case associatedEmailPassword
    //Sachin
    case emptyPassportError
    case invalidPassportError
    case emptyFirstNameError
    case emptyLastNameError
    
}

enum CheqAPIManagerError: Error, Equatable {
    case unableToPerformKYCNow
    case errorHasOccurredOnServer
    case unableToParseResponse
    case invalidInput
    case onboardingRequiredFromGetUserDetails
    case errorFromGetUserDetails
    case errorFromGetUserAction
    case errorInvalidBSB
}

enum CheqAPIManagerError_Budget: Error {
    case unableToRetrieveBudgets
    case unableToPutBudgets
}

enum CheqAPIManagerError_Spending: Error {
    case unableToRetrieveOverview
    case unableToRetrieveCategories
    case unableToRetrieveCategoryById
    case unableToRetrieveSpendingStatus
    case unableToRetrieveTransactions
    
}

enum CheqAPIManagerError_Lending: Error {
    case unableToRetrieveLendingOverview
    case unableToRetrieveLoanPreview
    case unableToPutBankDetails
    case unableToResolveNameConflict
    case unableToProcessBorrow
    case unableToGetTimeSheets
    case unableToPostSalaryTransaction
    case unableToResolveBankAccount
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
    case wrongUserNameOrPasswordLinkableAccounts
    case invalidCredentials
    case unableToUpdateAccountCredentials
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
    case unableToRequestPasswordResetEmail
    case unableToVerifyEmailVerificationCode
    case unableToStoreAuthToken
    case unableToCleanAuthToken
    case unableToRetrieveCurrentUser
    case unableToDeleteCurrentUserAccount
    case unableToUpdatePassword
    case unableToSendPasswordResetLink
    
    case unknown
}

extension MoneySoftManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .require2FAVerificationCode:
            return NSLocalizedString("Require 2FA verification code", comment: "")
        case .unknown:
            return NSLocalizedString("Server error has occurred", comment: "")
        case .errorFromHandleNotification:
            return NSLocalizedString("Error from handling notification", comment: "")
        case .requireMFA:
            return NSLocalizedString("Due to technical limitations, we do not support bank accounts that have 2FA enabled. We do not recommend you disable your 2FA. This is a limitation with Cheq, not your Bank.", comment: "")
        case .unableToForceUnlinkAllAccounts:
            return NSLocalizedString("Unable to force unlink all accounts", comment: "")
        case .unableToGetAccounts:
            return NSLocalizedString("Unable to get accounts", comment: "")
        case .unableToLinkAccounts:
            return NSLocalizedString("Unable to link accounts", comment: "")
        case .unableToRefreshAccounts:
            return NSLocalizedString("Unable to refresh accounts", comment: "")
        case .unableToUpdateTransactions:
            return NSLocalizedString("Unable to update transactions", comment: "")
        case .unableToLoginWithCredential:
            return NSLocalizedString("Unable to login with moneysoft credential", comment: "")
        case .unableToUnlinkAccounts:
            return NSLocalizedString("Unable to unlink accounts", comment: "")
        case .unableToRetreiveLinkableAccounts:
            return NSLocalizedString("Unable to retrieve linkable accounts", comment: "")
        case .unableToUpdateAccountCredentials:
            return NSLocalizedString("Unable to update account credentials", comment: "")
        case .unableToRegisterNotificationToken:
            return NSLocalizedString("Unable to register notification token", comment: "")
        case .unableToRetrieveUserProfile:
            return NSLocalizedString("Unable to retrieve user profile", comment: "")
        case .unableToUpdateDisabledAccountCredentials:
            return NSLocalizedString("Unable to update disabled account credentials", comment: "")
        case .unableToRetrieveFinancialInstitutions:
            return NSLocalizedString("Unable to retrieve financial institutions", comment: "")
        case .unableToRetrieveFinancialInstitutionSignInForm:
            return NSLocalizedString("Unable to retrieve financial institution sign-in form", comment: "")
        case .unableToRefreshTransactions:
            return NSLocalizedString("Unable to refresh transactions", comment: "")
        case .unableToLoginWithBankCredentials:
            return NSLocalizedString("Unable to login with bank credentials", comment: "")
        case .unableToRetrieveMoneySoftCredential:
            return NSLocalizedString("Unable to retrieve money soft credentials", comment: "")
        case .wrongUserNameOrPasswordLinkableAccounts:
            return NSLocalizedString("The log in details you have entered are incorrect.  Please re-enter your financial account log in details, exactly as you would if logging into your internet banking site.", comment: "")
        case .invalidCredentials:
            return NSLocalizedString("Warning attemting this with multiple time with wrong credentials might lock you out of your internet banking", comment: "")
        }
    }
}

extension RemoteConfigError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unableToFetchAndActivateRemoteConfig:
            return NSLocalizedString("Unable to fetch and activate remote config, please try again later.", comment: "")
        case .unableToFetchInstitutions:
            return NSLocalizedString("Unable to fetch institutions.", comment: "")
        case .unableToFetchRemoteConfigValue:
            return NSLocalizedString("Unable to fetch remote config values.", comment: "")
        }
    }
}

extension CheqAPIManagerError_Budget: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unableToRetrieveBudgets:
            return NSLocalizedString("Unable to retrieve budget overview", comment: "")
        case .unableToPutBudgets:
            return NSLocalizedString("Unable to put budgets", comment: "")
        }
    }
}

extension CheqAPIManagerError_Spending: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unableToRetrieveOverview:
            return NSLocalizedString("Unable to retrieve spending overview, please try again later.", comment: "")
        case .unableToRetrieveCategories:
            return NSLocalizedString("Unable to retrieve spending categories, please try again later.", comment: "")
        case .unableToRetrieveTransactions:
            return NSLocalizedString("Unable to retrieve transactions, please try again later.", comment: "")
        case .unableToRetrieveCategoryById:
            return NSLocalizedString("Unable to retrieve spending by category by id, please try again later", comment: "")
        case .unableToRetrieveSpendingStatus:
            return NSLocalizedString("Unable to retrieve spending status, please try again later", comment: "")
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
        case .unableToProcessBorrow:
            return NSLocalizedString("Unable to process on server, please try again later", comment: "")
        case .unableToGetTimeSheets:
            return NSLocalizedString("Unable to load time-sheets, please try again later", comment: "")
        case .unableToPostSalaryTransaction:
            return NSLocalizedString("Unable to post Salary Transactions, please try again later", comment: "")
        case .unableToResolveBankAccount:
            return NSLocalizedString("Unable to unable to Resolve Bank Account, please try again later", comment: "")
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
        case .errorFromGetUserDetails:
            return NSLocalizedString("Error from get user details", comment: "")
        case .errorFromGetUserAction:
            return NSLocalizedString("Error from get User Action", comment: "")
        case .errorInvalidBSB:
            return NSLocalizedString("Invalid bsb and account number", comment: "")
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
            return NSLocalizedString("Invalid email format, please try again", comment: "")
        case .invalidPasswordFormat:
            return NSLocalizedString("At least 6 characters long with 1 upper case character and 1 number", comment: "")
        case .invalidPostcodeFormat:
            return NSLocalizedString("Postcode should be 4 digits", comment: "")
        case .invalidDriversLicenseFormat:
            return NSLocalizedString("Please enter your licence number as it appears on the ID", comment: "")
        case .invalidMedicareNumberFormat:
            return NSLocalizedString("Card number should be 10 digits", comment: "")
        case .invalidMedicarePositionFormat:
            return NSLocalizedString("Position on card should be 1 digit", comment: "")
        case .unableToMapSelectedBank:
            return NSLocalizedString("Internal error with mapping selection", comment: "")
        case .onlyAlphabetCharactersIsAllowed:
            return NSLocalizedString("Only alphabet characters are allowed", comment: "")
        case .onlyNumericCharactersIsAllowed:
            return NSLocalizedString("Only numeric characters are allowed", comment: "")
        case .autoCompleteIsMandatory:
            return NSLocalizedString("Please enter your Company Address", comment: "")
        case .autoCompleteHomeAddressIsMandatory:
            return NSLocalizedString("Please enter your residential address", comment: "")
            
        case .dobIsMandatory:
            return NSLocalizedString("Please enter your date of birth", comment: "")
            
        case .invalidCompanyName:
            return NSLocalizedString("Please enter the Company Name", comment: "")
        case .invalidBBSandAccountNO:
            return NSLocalizedString("Please enter a valid BSB and Account number", comment: "")
        case .associatedEmailPassword:
            return NSLocalizedString("Please enter the email address and password associated with your account", comment: "")
        case .emptyPassportError:
            return NSLocalizedString("Please enter your passport number", comment: "")
        case .invalidPassportError:
            return NSLocalizedString("Please enter your passport number as it appears on your passport", comment: "")
        case .emptyFirstNameError:
            return NSLocalizedString("Please enter your Given Name as it appears on your ID", comment: "")
        case .emptyLastNameError:
            return NSLocalizedString("Please enter your Surname as it appears on your ID", comment: "")
        }
    }
}

extension AuthManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidRegistrationFields:
            return NSLocalizedString("Invalid registration fields", comment: "")
        case .invalidLoginFields:
            //return NSLocalizedString("The email or password you entered is incorrect", comment: "")
            
            return NSLocalizedString("The email address / password combination you entered does not exist", comment: "")
            
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
            return NSLocalizedString("An error has occurred, please ensure email is valid", comment: "")
        case .unableToVerifyEmailVerificationCode:
            return NSLocalizedString("Unable to validate verification code", comment: "")
        case .unableToRequestPasswordResetEmail:
            return NSLocalizedString("Unable to send password reset email", comment: "")
            
            
            
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
    
}

