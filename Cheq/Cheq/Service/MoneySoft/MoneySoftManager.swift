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
import FirebaseRemoteConfig

class MoneySoftManager {
    
    static let shared = MoneySoftManager()
   // let msApi: MoneysoftApi
    private init() {
        //MoneysoftApi.configure(MoneySoft.config(uiView: (UIApplication.shared.keyWindow?.rootViewController!.view!)!))
        
       // self.msApi = MoneysoftApi()
    }
    
    
    
    func handleNotification(_ data: [AnyHashable : Any])-> Promise<Bool> {
        return Promise<Bool>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let loginModel = self.buildLoginModel(authUser.msCredential)
                let msApi: MoneysoftApi = MoneysoftApi();
                try msApi.notifications().handleNotification(data: data, config: MoneySoft.bgTaskConfig(), login: loginModel, listener: ApiListener<ApiResponseModel>(successHandler: { resp in
                     resolver.fulfill(true)
                }, errorHandler: { errorModel in
                    MoneySoftUtil.shared.logErrorModel(errorModel)
                    resolver.reject(MoneySoftManagerError.errorFromHandleNotification)
                }))
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    func postNotificationToken()-> Promise<Bool> {
        return Promise<Bool>() { resolver in
            do {
                let fcmToken = CKeychain.shared.getValueByKey(CKey.fcmToken.rawValue)
                let msApi: MoneysoftApi = MoneysoftApi();
                try msApi.notifications().registerToken(fcmToken, listener: ApiListener<ApiResponseModel>(successHandler: { response in
                    resolver.fulfill(true)
                }, errorHandler: { errorModel in
                    MoneySoftUtil.shared.logErrorModel(errorModel)
                    resolver.reject(MoneySoftManagerError.unableToRegisterNotificationToken)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToRegisterNotificationToken)
            }
        }
    }
    
    func getProfile()-> Promise<UserProfileModel> {
        return Promise<UserProfileModel>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
            do {
               
                try msApi.user().profile(listener: ApiListener<UserProfileModel>(successHandler: { profileModel in
                     let profile = profileModel
                    resolver.fulfill(profile)
                }, errorHandler: { errorModel in
                    MoneySoftUtil.shared.logErrorModel(errorModel)
                    resolver.reject(MoneySoftManagerError.unableToRetrieveUserProfile)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToRetrieveUserProfile)
            }
        }
    }
    
    func logout()->Promise<Void> {
        return Promise<Void>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
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
            let msApi: MoneysoftApi = MoneysoftApi();
            let loginModel: LoginModel = buildLoginModel(credentials)
 
            do {
                try msApi.user().login(details: loginModel, listener:ApiListener<AuthenticationModel>(successHandler: { authModel in
                     let model = authModel
                    resolver.fulfill(model)
                }, errorHandler: { errorModel in
                    // throw error for verification code
                    if let err: ApiErrorModel = errorModel, err.code == ErrorCode.REQUIRES_LOGIN_VERIFICATION.rawValue {
                        self.logMoneysoftError(error: errorModel, event: "Login")
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

    func getTransactions(_ transactionFilter: TransactionFilter)-> Promise<[FinancialTransactionModel]> {
        return Promise<[FinancialTransactionModel]>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
            do {
                try msApi.transactions().getTransactions(filter: transactionFilter, listener: ApiListListener<FinancialTransactionModel>(successHandler: { transactions in
                    guard let fetchedTransactions = transactions as? [FinancialTransactionModel] else {
                        resolver.reject(MoneySoftManagerError.unableToRefreshTransactions); return
                    }
                    NotificationUtil.shared.notify(UINotificationEvent.moneysoftEvent.rawValue, key: NotificationUserInfoKey.moneysoftProgress.rawValue, object: MoneySoftLoadingEvents.categorisingYourTransactions)
                    resolver.fulfill(fetchedTransactions)
                }, errorHandler: { errorModel in
                    MoneySoftUtil.shared.logErrorModel(errorModel)
                     self.logMoneysoftError(error: errorModel, event: "Get Transactions")
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
    
    func getAccounts()->Promise<[FinancialAccountModel]> {
        return Promise<[FinancialAccountModel]>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
            do {
                try msApi.financial().getAccounts(listener: ApiListListener<FinancialAccountModel>(successHandler: { accounts in
                    guard let fetchedAccounts = accounts as? [FinancialAccountModel] else { resolver.reject(MoneySoftManagerError.unableToGetAccounts); return }
                    NotificationUtil.shared.notify(UINotificationEvent.moneysoftEvent.rawValue, key: NotificationUserInfoKey.moneysoftProgress.rawValue, object: MoneySoftLoadingEvents.retrievingStatementsFromBank)
                    resolver.fulfill(fetchedAccounts)
                }, errorHandler: { errorModel in
                    MoneySoftUtil.shared.logErrorModel(errorModel)
                      self.logMoneysoftError(error: errorModel, event: "Get Accounts")
                    resolver.reject(MoneySoftManagerError.unableToGetAccounts)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToGetAccounts)
            }
        }
    }
    
    func updateTransactions(_ accounts: [FinancialAccountModel], options: UpdateTransactionOptions)-> Promise<[FinancialTransactionModel]> {
        return Promise<[FinancialTransactionModel]>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
            do {
                try msApi.financial().updateTransactions(financialAccounts: accounts, options: options, listener: ApiListListener<FinancialTransactionModel>(successHandler: { transactions in
                    guard let updatedTransactions = transactions as? [FinancialTransactionModel] else { resolver.reject(MoneySoftManagerError.unableToUpdateTransactions); return }
                    resolver.fulfill(updatedTransactions)
                }, errorHandler: { errorModel in
                    MoneySoftUtil.shared.logErrorModel(errorModel)
                     self.logMoneysoftError(error: errorModel, event: "Update Transactions")
                    resolver.reject(MoneySoftManagerError.unableToUpdateTransactions)
                }))
            } catch { 
                resolver.reject(MoneySoftManagerError.unableToUpdateTransactions)
            }
        }
    }
    
    func refreshAccounts(_ accounts: [FinancialAccountModel], refreshOptions: RefreshAccountOptions)-> Promise<[FinancialAccountModel]> {
        return Promise<[FinancialAccountModel]>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
            do {
                try msApi.financial().refreshAccounts(financialAccounts: accounts, options: refreshOptions, listener: ApiListListener<FinancialAccountModel>(successHandler: { refreshedAccounts in
                    guard let updatedAccounts = refreshedAccounts as? [FinancialAccountModel] else { resolver.reject(MoneySoftManagerError.unableToRefreshAccounts); return }
                    NotificationUtil.shared.notify(UINotificationEvent.moneysoftEvent.rawValue, key: NotificationUserInfoKey.moneysoftProgress.rawValue, object: MoneySoftLoadingEvents.analysingYourBankStatement)
                    resolver.fulfill(updatedAccounts)
                }, errorHandler: { errorModel in
                    MoneySoftUtil.shared.logErrorModel(errorModel)
                     self.logMoneysoftError(error: errorModel, event: "Refresh Accounts")
                    resolver.reject(MoneySoftManagerError.unableToRefreshAccounts)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToRefreshAccounts)
            }
        }
    }
    
    func linkableAccounts(_ credentials: InstitutionCredentialsFormModel)-> Promise<[FinancialAccountLinkModel]> {
        return Promise<[FinancialAccountLinkModel]>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
            do {
                try msApi.financial().getLinkableAccounts(credentials: credentials, listener: ApiListListener<FinancialAccountLinkModel>(successHandler: { linkableAccounts in
                    
                    guard let accounts = linkableAccounts as? [FinancialAccountLinkModel] else { resolver.reject(MoneySoftManagerError.unableToRetreiveLinkableAccounts); return
                    }
                    NotificationUtil.shared.notify(UINotificationEvent.moneysoftEvent.rawValue, key: NotificationUserInfoKey.moneysoftProgress.rawValue, object: MoneySoftLoadingEvents.connectingtoBank)
                    resolver.fulfill(accounts)
                }, errorHandler: { errModel in
                     let err = errModel
                    if err.code == ErrorCode.REQUIRES_MFA.rawValue {
                        let mfaPrompt = err.messages[ErrorKey.MFA_PROMPT.rawValue] ?? ""
                        let mfaErr = MoneySoftManagerError.requireMFA(reason: mfaPrompt)
                        resolver.reject(mfaErr); return
                    }
                    print(errModel.description)
                    print(errModel.messages["message"] ?? "")
                    self.logMoneysoftError(error: errModel, event: "Linkable Accounts")
                    if errModel.messages["message"] == MoneySoftManagerError.wrongUserNameOrPasswordLinkableAccounts.localizedDescription{
                        resolver.reject(MoneySoftManagerError.wrongUserNameOrPasswordLinkableAccounts)
                    }else{
                        resolver.reject(MoneySoftManagerError.unableToRetreiveLinkableAccounts)
                    }
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToRetreiveLinkableAccounts)
            }
            
        }
    }
    
    func linkAccounts(_ linkAccounts: [FinancialAccountLinkModel])-> Promise<[FinancialAccountModel]> {
        return Promise<[FinancialAccountModel]>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
            do {
                try msApi.financial().linkAccounts(accounts: linkAccounts, listener: ApiListListener<FinancialAccountModel>(successHandler: { linkedAccounts in
                    guard let linkedAccts = linkedAccounts as? [FinancialAccountModel] else { resolver.reject(MoneySoftManagerError.unableToLinkAccounts); return  }
                    NotificationUtil.shared.notify(UINotificationEvent.moneysoftEvent.rawValue, key: NotificationUserInfoKey.moneysoftProgress.rawValue, object: MoneySoftLoadingEvents.requestingStatementsForAccounts)
                    resolver.fulfill(linkedAccts)
                }, errorHandler: { errorModel in
                    MoneySoftUtil.shared.logErrorModel(errorModel)
                     self.logMoneysoftError(error: errorModel, event: "Link Accounts")
                    resolver.reject(MoneySoftManagerError.unableToLinkAccounts)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToLoginWithBankCredentials)
            }
        }
    }
    
    func getBankSignInForm(_ financialInstitutionModel: FinancialInstitutionModel)-> Promise<InstitutionCredentialsFormModel> {
        print(financialInstitutionModel.displayName)
        return Promise<InstitutionCredentialsFormModel>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
            do {
                try msApi.financial().getSignInForm(institution: financialInstitutionModel, listener: ApiListener<InstitutionCredentialsFormModel>(successHandler: { formModel in
                     let form = formModel
                    NotificationUtil.shared.notify(UINotificationEvent.moneysoftEvent.rawValue, key: NotificationUserInfoKey.moneysoftProgress.rawValue, object: MoneySoftLoadingEvents.getBankName)
                    resolver.fulfill(form)
                }, errorHandler: { errorModel in
                    MoneySoftUtil.shared.logErrorModel(errorModel)
                    self.logMoneysoftError(error: errorModel, event: "Get Bank SignIn Form",bankName: financialInstitutionModel.name)
                    resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutionSignInForm)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutionSignInForm)
            }
        }
    }
    
    func getInstitutions()-> Promise<[FinancialInstitutionModel]> {
        return Promise<[FinancialInstitutionModel]>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
            do {
               
                try msApi.financial().getInstitutions(listener: ApiListListener<FinancialInstitutionModel>(successHandler: { institutions in
                    if let financialInstitutions = institutions as? [FinancialInstitutionModel] {
                        resolver.fulfill(financialInstitutions)
                    } else {
                        resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutions)
                    }
                }, errorHandler: { errorModel in
                    MoneySoftUtil.shared.logErrorModel(errorModel)
                     self.logMoneysoftError(error: errorModel, event: "Get Institutions")
                    resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutions)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutions)
            }
        }
    }
}

// MARK: disabled account update credentials, unlinking linked accounts
extension MoneySoftManager {
    
    /*
    update account credentials should be pass for accounts that are disabled
    disable state came from getAccounts
    getAccounts gets all the accounts that are linked to the user's entered email/username
    those that are disabled are not available on the device
    each sign in form represents credential for a subset of accounts if we have a list of accounts on various device
    example - I have iphone loggedin using Westpac. So I have 10 accounts. then on iPad, I logged in using and I have 10 same accounts. But these are disabled because MoneySoftSDK don't recognize the initial installing device.
    So now, I will need to Update Account Credentials to supply the valid logins to enable to these 10 accounts on iPad.
    Could think of this as a re-authenticate call.
     */
    func updateAccountCredentials(_ account: FinancialAccountModel, credentialFormModel: InstitutionCredentialsFormModel) -> Promise<Bool> {
        return Promise<Bool>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
            do {
                try msApi.financial().updateAccountCredentials(account: account, credentials: credentialFormModel, listener: ApiListener<FinancialAccountModel>(successHandler: { account in
                    resolver.fulfill(true)
                }, errorHandler: { errorModel  in
                    MoneySoftUtil.shared.logErrorModel(errorModel)
                    self.logMoneysoftError(error: errorModel, event: "Update Account Credentials")
                    resolver.reject(MoneySoftManagerError.unableToUpdateDisabledAccountCredentials)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToUpdateDisabledAccountCredentials)
            }
        }
    }
    
    func forceUnlinkAllAccounts()-> Promise<Bool> {
        return Promise<Bool>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
            do {
                try msApi.financial().forceUnlinkAllAccounts(listener: ApiListener<ApiResponseModel>(successHandler: { responseModel in
                     let response = responseModel
                    if response.success {
                        resolver.fulfill(true)
                    } else {
                        resolver.reject(MoneySoftManagerError.unableToForceUnlinkAllAccounts)
                    }
                }, errorHandler: { errorModel in
                    MoneySoftUtil.shared.logErrorModel(errorModel)
                     self.logMoneysoftError(error: errorModel, event: "Force Unlink All Accounts")
                    resolver.reject(MoneySoftManagerError.unableToForceUnlinkAllAccounts)
                }))
            } catch {
                resolver.reject(MoneySoftManagerError.unableToForceUnlinkAllAccounts)
            }
        }
    }
    
    func unlinkAccounts(_ accounts: [FinancialAccountModel])-> Promise<[FinancialAccountModel]> {
        return Promise<[FinancialAccountModel]>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
            do {
                try msApi.financial().unlinkAccounts(financialAccounts: accounts, listener: ApiListListener<FinancialAccountModel>(successHandler: { removedAccounts in
                    guard let removedAccts = removedAccounts as? [FinancialAccountModel] else { resolver.reject(MoneySoftManagerError.unableToLinkAccounts); return }
                    resolver.fulfill(removedAccts)
                }, errorHandler: { errorModel in
                    MoneySoftUtil.shared.logErrorModel(errorModel)
                     self.logMoneysoftError(error: errorModel, event: "Unlink Accounts")
                    resolver.reject(MoneySoftManagerError.unableToUnlinkAccounts)
                }))
            } catch {
               resolver.reject(MoneySoftManagerError.unableToUnlinkAccounts)
            }
        }
    }
}

// MARK: User Details Management /
extension MoneySoftManager {
//    func putUserDetails(_ loggedInUser: AuthUser, putUserReq: PutUserRequest)->Promise<Bool> {
//        return Promise<Bool>() { resolver in
//            let token = loggedInUser.authToken() ?? ""
//            UsersAPI.putUserWithRequestBuilder(request: putUserReq).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: String("\(HttpHeaderKeyword.bearer.rawValue) \(token)")).execute { _, error in
//                if let err = error { resolver.reject(err); return }
//                resolver.fulfill(true)
//            }
//        }
//    }
    
    func getUserDetails(_ loggedInUser: AuthUser)-> Promise<MoneySoftUser> {
        return Promise<MoneySoftUser>() { resolver in
           // let msApi: MoneysoftApi = MoneysoftApi();
            let token = loggedInUser.authToken() ?? ""
            UsersAPI.getUserWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: String("\(HttpHeaderKeyword.bearer.rawValue) \(token)")).execute() { (response, error) in
                
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
    func getLinkableAccounts(_ credentials: InstitutionCredentialsFormModel, completion: @escaping (Result<[FinancialAccountLinkModel]>)->Void) {
        let msApi: MoneysoftApi = MoneysoftApi();
        do {
            try msApi.financial().getLinkableAccounts(credentials:credentials, listener: ApiListListener<FinancialAccountLinkModel>(successHandler: { linkableAccounts in
                
                guard let accounts = linkableAccounts as? [FinancialAccountLinkModel] else { completion(.failure(MoneySoftManagerError.unableToRetreiveLinkableAccounts)); return
                }
                completion(.success(accounts))
            }, errorHandler: { errModel in
                 let err = errModel
                if err.code == ErrorCode.REQUIRES_MFA.rawValue {
                    let mfaPrompt = err.messages[ErrorKey.MFA_PROMPT.rawValue] ?? ""
                    let mfaErr = MoneySoftManagerError.requireMFA(reason: mfaPrompt)
                    completion(.failure(mfaErr)); return
                }
                 self.logMoneysoftError(error: errModel, event: "Get Linkable Accounts")
                completion(.failure(MoneySoftManagerError.unableToRetreiveLinkableAccounts))
            }))
        } catch {
            completion(.failure(MoneySoftManagerError.unableToRetreiveLinkableAccounts))
        }
    }
}


// MARK: helper method
extension MoneySoftManager {
    func buildLoginModel(_ credentials: Dictionary<LoginCredentialType, String>)->LoginModel {
        var loginModel: LoginModel
        if let otp = credentials[.msOtp] {
            loginModel = LoginModel(username: credentials[.msUsername] ?? "", password: credentials[.msPassword] ?? "", verification: otp)
        } else {
            loginModel = LoginModel(username: credentials[.msUsername] ?? "", password: credentials[.msPassword] ?? "")
        }
        return loginModel
    }
}

// MARK: MoneySoft New SDK
extension MoneySoftManager {

    func refreshAccountsWithNewSDK()->Promise<[FinancialAccountModel]> {
        return Promise<[FinancialAccountModel]>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
            let getAccountsListener: ApiListListener<FinancialAccountModel> = ApiListListener<FinancialAccountModel>(successHandler: {
                (accountsResponse) in
                
                guard let accounts: [FinancialAccountModel] = accountsResponse as? [FinancialAccountModel] else {
                   print("Unable to parse the response.");
                    resolver.reject(MoneySoftManagerError.unableToRefreshAccounts)
                    return;
                }
                print(accounts.count)
                
                let refreshListener: ApiListListener<FinancialAccountModel> = ApiListListener<FinancialAccountModel>(successHandler: {
                    (response) in
                    
                    guard let accounts: [FinancialAccountModel] = response as? [FinancialAccountModel] else {
                        
                        return;
                    }
                    
                    var message: String = "";
                    
                    for account in accounts {
                        message.append("\(account.name) | \(account.balance)");
                    }
                    
                   resolver.fulfill(accounts)
                    
                }, errorHandler: {
                    (error) in
                    resolver.reject(MoneySoftManagerError.unableToRefreshAccounts)
                   print(error)
                    
                });
                
                do {
                  
                    
                    let refreshOptions: RefreshAccountOptions = RefreshAccountOptions();
                    
                    refreshOptions.includeTransactions = true;
                    try msApi.financial().refreshAccounts(financialAccounts: accounts,
                                                          options: refreshOptions,
                                                          listener: refreshListener);
                }
                catch {
                    resolver.reject(MoneySoftManagerError.unableToRefreshAccounts)
                    print(error);
                }
            }, errorHandler: {
                (error) in
                resolver.reject(MoneySoftManagerError.unableToRefreshAccounts)
                print(error)
                
            });
            
            do {
               
                try msApi.financial().getAccounts(listener: getAccountsListener);
            }
            catch {
                resolver.reject(MoneySoftManagerError.unableToRefreshAccounts)
                print(error);
            }
            
        }
    }
    
    
    

      //Step 1
    func getInstitutionsNewSDK()->Promise<[FinancialInstitutionModel]> {
        return Promise<[FinancialInstitutionModel]>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
            let institutionsListener: ApiListListener<FinancialInstitutionModel> = ApiListListener<FinancialInstitutionModel>(successHandler: {
                (institutionsResponse) in
                
                if let institutions = institutionsResponse as? [FinancialInstitutionModel] {
                     resolver.fulfill(institutions)
                }else {
                    print("Nothing to show")
                   resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutions)
                }
                
            }, errorHandler: {
                (error) in
              resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutions)
                print("Error Occured with institutions")
            });
            
            
            
            do {
                  try msApi.financial().getInstitutions(listener: institutionsListener);
            }
            catch {
                resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutions)
                print("Fail to load")
            }
            
           }//Resolver
        }
    
    
    
      //Step 2
    func getLinkableAccountsNewSDK(credentialForm:InstitutionCredentialsFormModel?)->Promise<[FinancialAccountLinkModel]> {
       return Promise<[FinancialAccountLinkModel]>() { resolver in
        let msApi: MoneysoftApi = MoneysoftApi();
        if (credentialForm != nil) {
            
           
            let linkAccountListener: ApiListListener<FinancialAccountLinkModel> = ApiListListener<FinancialAccountLinkModel>(successHandler: {
                (linkResponse) in
                print(linkResponse.count)
         

                  guard let accounts = linkResponse as? [FinancialAccountLinkModel] else { resolver.reject(MoneySoftManagerError.unableToRetreiveLinkableAccounts); return
                             }
                
                  resolver.fulfill(accounts)
                
                
            }, errorHandler: {
                (errorResponse) in
                resolver.reject(MoneySoftManagerError.unableToRetreiveLinkableAccounts)
                
                guard let error: ApiErrorModel = errorResponse else {
                    print("Unable to parse the response.");
                    resolver.reject(MoneySoftManagerError.unableToRetreiveLinkableAccounts)
                    return;
                }
                
                if (error.code == ErrorCode.REQUIRES_MFA.rawValue) {
                    //For now this is no need, but keeping for future reference
                    let mfaVerification: MFAVerificationModel = MFAVerificationModel(institutionId: credentialForm?.providerInstitutionId ?? "",
                                                                                     label: error.messages[ErrorKey.MFA_PROMPT.rawValue],
                                                                                     type: error.messages[ErrorKey.MFA_FIELD_TYPE.rawValue]);
                    
                }
                else {
                   resolver.reject(MoneySoftManagerError.unableToRetreiveLinkableAccounts)
                    print("Error")
                }
            });
            
            do {
                
                try msApi.financial().getLinkableAccounts(credentials: credentialForm!,
                                                          listener: linkAccountListener);
            }
            catch {
                resolver.reject(MoneySoftManagerError.unableToRetreiveLinkableAccounts)
                print(error);
            }
        }
        else {
             resolver.reject(MoneySoftManagerError.unableToRetreiveLinkableAccounts)
        }
      }
    }
    //Step 3
     func linkAccountsNewSDK(accounts: [FinancialAccountLinkModel]?)->Promise<[FinancialAccountModel]> {
         return Promise<[FinancialAccountModel]>() { resolver in
            let msApi: MoneysoftApi = MoneysoftApi();
           if (accounts != nil && accounts!.count > 0) {
               
               
               do {
                   let linkListener: ApiListListener<FinancialAccountModel> = ApiListListener<FinancialAccountModel>(successHandler: {
                       (response) in
                   
                       
                       guard let accounts: [FinancialAccountModel] = response as? [FinancialAccountModel] else {
                            print("Unable to parse the response.")
                           
                           return;
                       }
                      
                       var linkedAccountsMsg: String = "";
                       
                       for account in accounts {
                           linkedAccountsMsg.append("\(account.name) | \(account.balance)\n");
                       }
                       
                       print(linkedAccountsMsg)
                       resolver.fulfill(accounts)
                   }, errorHandler: {
                       (error) in
                      
                       resolver.reject(MoneySoftManagerError.unableToLinkAccounts)
                      print(error)
                   });
                   
                 
                   try msApi.financial().linkAccounts(accounts: accounts!,
                                                      includeTransactions: true,
                                                      listener: linkListener);
               }
               catch {
                   
                   print(error);
                resolver.reject(MoneySoftManagerError.unableToLinkAccounts)
               }
           }
           else {
                  
                    print("No accounts have been selected to link.");
              resolver.reject(MoneySoftManagerError.unableToLinkAccounts)
           }
         }
       }
    
     //Not yet implimented
    
}
// MARK: MoneySoft New SDK Transactions
extension MoneySoftManager {

     func getTransactionsNewSDK(filter: TransactionFilter)->Promise<[FinancialTransactionModel]> {
       return Promise<[FinancialTransactionModel]>() { resolver in
        let msApi: MoneysoftApi = MoneysoftApi();
        let transactionListener: ApiListListener<FinancialTransactionModel> = ApiListListener<FinancialTransactionModel>(successHandler: {
            (response) in
            
            guard let transactions: [FinancialTransactionModel] = response as? [FinancialTransactionModel] else {
                
                print("Unable to parse the response.");
               
                return;
            }
            
            var transactionsMsg: String = "";
            
            for transaction in transactions {
                transactionsMsg.append("\(transaction.name ?? "Unknown Name") | \(transaction.amount) | \(transaction.type.rawValue)\n");
            }
            resolver.fulfill(transactions)
            print(transactionsMsg)
        }, errorHandler: {
            (error) in
            print(error)
             resolver.reject(MoneySoftManagerError.unableToRefreshTransactions)
        });
        
        do {
           
            try msApi.transactions().getTransactions(filter: filter,
                                                     listener: transactionListener);
        }
        catch {
            resolver.reject(MoneySoftManagerError.unableToRefreshTransactions)
            print(error);
        }
      }
    }
    
}
extension MoneySoftManager {
    
    //This method will log all the erros to the backend, where sending the bank name is optional.
    
    func logMoneysoftError(error: ApiErrorModel?, event: String, bankName:String? = nil)  {
        
        let req = PostLogRequest(deviceId: UUID().uuidString, type: .error, message: "Failed with error code :\(String(describing: error?.code)), with description: \(String(describing: error?.description)), and with additional reasons: \( String(describing: error?.messages))", event: event, bankName: bankName)
        CheqAPIManager.shared.PostMoneySoftErrorlogs(requestParam:req)
        .done{ success in
                 AppConfig.shared.hideSpinner {
                    print(success)
                 }
             }.catch { err in
                print(err)
             }
    }
}
enum MoneySoftLoadingEvents {
    
    case connectingtoBank
    case requestingStatementsForAccounts
    case retrievingStatementsFromBank
    case analysingYourBankStatement
    case categorisingYourTransactions
    case loadingYourDashboard
    case getBankName
    
}






