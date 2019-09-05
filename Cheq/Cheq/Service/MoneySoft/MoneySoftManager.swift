//
//  MoneySoftManager.swift
//  Cheq
//
//  Created by Xuwei Liang on 2/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import Foundation
import MobileSDK
import PromiseKit

class MoneySoftManager {
    static let shared = MoneySoftManager()
    let msApi: MoneysoftApi
    let API_BASE_URL = "https://api.beta.moneysoft.com.au"
    let API_REFERRER = "https://cheq.beta.moneysoft.com.au"
    
    private init() {
        let config = MoneysoftApiConfiguration.init(apiUrl: API_BASE_URL, apiReferrer: API_REFERRER, view: UIView(), aggregationTimeout: 600)
        MoneysoftApi.configure(config)
        self.msApi = MoneysoftApi()
    }
    
    func getProfile()-> Promise<UserProfileModel> {
        return Promise<UserProfileModel>() { resolver in
            do {
                try msApi.user().profile(listener: ApiListener<UserProfileModel>(successHandler: { profileModel in
                    guard let profile = profileModel else { resolver.reject(MoneySoftManagerError.unableToRetrieveUserProfile); return }
                    resolver.fulfill(profile)
                }, errorHandler: { errorModel in
                    if let err = errorModel {
                        LoggingUtil.shared.cPrint(err.code)
                    }
                    resolver.reject(MoneySoftManagerError.unableToRetrieveUserProfile)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToRetrieveUserProfile)
            }
        }
    }
    
    func logout()->Promise<Void> {
        return Promise<Void>() { resolver in
            do {
                try msApi.user().signOut()
                resolver.fulfill(())
            } catch {
                resolver.reject(MoneySoftManagerError.unknown)
            }
        }
    }
    
    func login(_ credentials: [LoginCredentialType: String])-> Promise<AuthenticationModel> {
        return Promise<AuthenticationModel>() { resolver in
            
            var loginModel: LoginModel
            if let otp = credentials[.msOtp] {
                loginModel = LoginModel(username: credentials[.msUsername] ?? "", password: credentials[.msPassword] ?? "", verification: otp)
            } else {
                loginModel = LoginModel(username: credentials[.msUsername] ?? "", password: credentials[.msPassword] ?? "")
            }
            do {
                try msApi.user().login(details: loginModel, listener:ApiListener<AuthenticationModel>(successHandler: { authModel in
                    guard let model = authModel else { resolver.reject(MoneySoftManagerError.unableToLoginWithCredential);
                        return
                    }
                    
                    resolver.fulfill(model)
                }, errorHandler: { errorModel in
                    // throw error for verification code
                    if let err: ApiErrorModel = errorModel, err.code == ErrorCode.REQUIRES_LOGIN_VERIFICATION.rawValue {
                        resolver.reject(MoneySoftManagerError.require2FAVerificationCode); return
                    }
                    resolver.reject(MoneySoftManagerError.unableToLoginWithCredential)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToLoginWithCredential)
            }  
        }
    }
}

// MARK: Transactions
extension MoneySoftManager {
    func listTransactions(_ accounts: [FinancialAccountModel])-> Promise<[FinancialTransactionModel]> {
        return Promise<[FinancialTransactionModel]>() { resolver in
            do {
                try msApi.financial().refreshTransactions(financialAccounts: accounts, listener: ApiListListener<FinancialTransactionModel>(successHandler: { transactionModels in
                    guard let transactions = transactionModels as? [FinancialTransactionModel] else { resolver.reject(MoneySoftManagerError.unableToRefreshTransactions); return }
                    resolver.fulfill(transactions)
                }, errorHandler: { errorModel in
                    if let err = errorModel {
                        LoggingUtil.shared.cPrint(err.code)
                        LoggingUtil.shared.cPrint(err.messages)
                    }
                    resolver.reject(MoneySoftManagerError.unableToRefreshTransactions)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToRefreshTransactions)
            }
        }
    }
}

// MARK: Operation related to Linking Banks
extension MoneySoftManager {

    func linkableAccounts(_ institutionId: String, credentials: InstitutionCredentialsFormModel)-> Promise<[FinancialAccountLinkModel]> {
        return Promise<[FinancialAccountLinkModel]>() { resolver in
            do {
                try msApi.financial().getLinkableAccounts(institutionId: institutionId, credentials:credentials, listener: ApiListListener<FinancialAccountLinkModel>(successHandler: { linkableAccounts in
                    
                    guard let accounts = linkableAccounts as? [FinancialAccountLinkModel] else { resolver.reject(MoneySoftManagerError.unableToRetreiveLinkableAccounts); return
                    }
                    resolver.fulfill(accounts)
                }, errorHandler: { errModel in
                    if let err = errModel, err.code == ErrorCode.REQUIRES_MFA.rawValue {
                        let mfaPrompt = err.messages[ErrorKey.MFA_PROMPT.rawValue] ?? ""
                        let mfaErr = MoneySoftManagerError.requireMFA(reason: mfaPrompt)
                        resolver.reject(mfaErr); return
                    }
                    resolver.reject(MoneySoftManagerError.unableToRetreiveLinkableAccounts)
                }))
            } catch { 
                resolver.reject(MoneySoftManagerError.unableToRetreiveLinkableAccounts)
            }
        }
    }
    
    func linkAccounts(_ linkAccounts: [FinancialAccountLinkModel])-> Promise<[FinancialAccountModel]> {
        return Promise<[FinancialAccountModel]>() { resolver in
            do {
                try msApi.financial().linkAccounts(accounts: linkAccounts, listener: ApiListListener<FinancialAccountModel>(successHandler: { linkedAccounts in
                    guard let linkedAccts = linkedAccounts as? [FinancialAccountModel] else { resolver.reject(MoneySoftManagerError.unableToLinkAccounts); return  }
                    resolver.fulfill(linkedAccts)
                }, errorHandler: { errorModel in
                    if let err = errorModel {
                        LoggingUtil.shared.cPrint(err.code)
                    }
                    resolver.reject(MoneySoftManagerError.unableToLinkAccounts)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToLoginWithBankCredentials)
            }
        }
    }
    
    func getBankSignInForm(_ financialInstitutionModel: FinancialInstitutionModel)-> Promise<InstitutionCredentialsFormModel> {
        return Promise<InstitutionCredentialsFormModel>() { resolver in
            do {
                try msApi.financial().getSignInForm(institution: financialInstitutionModel, listener: ApiListener<InstitutionCredentialsFormModel>(successHandler: { formModel in
                    guard let form = formModel else { resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutionSignInForm); return }
                    resolver.fulfill(form)
                }, errorHandler: { errorModel in
                    if let err = errorModel { LoggingUtil.shared.cPrint(err.code) }
                    resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutionSignInForm)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutionSignInForm)
            }
        }
    }
    
    func getInstitutions()-> Promise<[FinancialInstitutionModel]> {
        return Promise<[FinancialInstitutionModel]>() { resolver in
            do {
                try msApi.financial().getInstitutions(listener: ApiListListener<FinancialInstitutionModel>(successHandler: { institutions in
                    if let financialInstitutions = institutions as? [FinancialInstitutionModel] {
                        resolver.fulfill(financialInstitutions)
                    } else {
                        resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutions)
                    }
                }, errorHandler: { errorModel in
                    if let err = errorModel {
                        LoggingUtil.shared.cPrint(err.code)
                    }
                    resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutions)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutions)
            }
        }
    }
}

// MARK: disable accounts, unlinking accounts
extension MoneySoftManager

// MARK: User Details Management /
extension MoneySoftManager {
    func putUserDetails(_ loggedInUser: AuthUser, putUserReq: PutUserRequest)->Promise<Bool> {
        return Promise<Bool>() { resolver in
            let token = loggedInUser.authToken() ?? ""
            UsersAPI.putUserWithRequestBuilder(request: putUserReq).addHeader(name: "Authorization", value: String("Bearer \(token)")).execute { _, error in
                if let err = error { resolver.reject(err); return }
                resolver.fulfill(true)
            }
        }
    }
    
    func getUserDetails(_ loggedInUser: AuthUser)-> Promise<MoneySoftUser> {
        return Promise<MoneySoftUser>() { resolver in
            
            let token = loggedInUser.authToken() ?? ""
            UsersAPI.getUserWithRequestBuilder().addHeader(name: "Authorization", value: String("Bearer \(token)")).execute() { (response, error) in
                
                guard let msUser: GetUserResponse = response?.body else { resolver.reject(error ?? MoneySoftManagerError.unableToRetrieveMoneySoftCredential); return}
                let username = msUser.moneySoftCredential?.msUsername ?? ""
                let password = msUser.moneySoftCredential?.msPassword ?? ""
                let moneySoftUser = MoneySoftUser(username: username, passwd: password, otp: "")
                resolver.fulfill(moneySoftUser)
            }
        }
    }
}


// MARK: callback implmentations
extension MoneySoftManager {
    // this is a callback closure wrapper of getting linkableAccounts using moneySoft SDK
    func getLinkableAccounts(_ institutionId: String, credentials: InstitutionCredentialsFormModel, completion: @escaping (Result<[FinancialAccountLinkModel]>)->Void) {
        do {
            try msApi.financial().getLinkableAccounts(institutionId: institutionId, credentials:credentials, listener: ApiListListener<FinancialAccountLinkModel>(successHandler: { linkableAccounts in
                
                guard let accounts = linkableAccounts as? [FinancialAccountLinkModel] else { completion(.failure(MoneySoftManagerError.unableToRetreiveLinkableAccounts)); return
                }
                completion(.success(accounts))
            }, errorHandler: { errModel in
                if let err = errModel, err.code == ErrorCode.REQUIRES_MFA.rawValue {
                    let mfaPrompt = err.messages[ErrorKey.MFA_PROMPT.rawValue] ?? ""
                    let mfaErr = MoneySoftManagerError.requireMFA(reason: mfaPrompt)
                    completion(.failure(mfaErr)); return
                }
                completion(.failure(MoneySoftManagerError.unableToRetreiveLinkableAccounts))
            }))
        } catch {
            completion(.failure(MoneySoftManagerError.unableToRetreiveLinkableAccounts))
        }
    }
}
