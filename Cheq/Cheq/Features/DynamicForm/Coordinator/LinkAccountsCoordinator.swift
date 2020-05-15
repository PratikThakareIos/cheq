//
//  LinkAccountsViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
import MobileSDK
import Alamofire

class LinkAccountsCoordinator: DynamicFormViewModelCoordinator {
  
    var sectionTitle = "Setup bank details"
    var viewTitle = "Login to link your accounts"
    var appTokenResponse : GetAppTokenResponse?
    var jobId = ""
    
    func loadForm() -> Promise<[DynamicFormInput]> {
       
        return Promise<[DynamicFormInput]> () { resolver in
            
            guard AppData.shared.financialInstitutions.count > 0 else { resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutions); return }
            
            guard let selectedFinancialInstitution = AppData.shared.selectedFinancialInstitution else { resolver.reject(ValidationError.unableToMapSelectedBank); return }
   
            // login again in case we have timed out issue
            AuthConfig.shared.activeManager.getCurrentUser().then { authUser -> Promise<GetAppTokenResponse> in
                return  CheqAPIManager.shared.getBasiqConnectionTokenForBankLogin()
            }.done { appTokenResponse in
                
                LoggingUtil.shared.cPrint("appTokenResponse = \(appTokenResponse)")
                self.appTokenResponse = appTokenResponse
                
                var inputs = [DynamicFormInput]()
                
                if let loginIdCaption =  selectedFinancialInstitution.loginIdCaption {
                    let dynamicInputType = DynamicFormInput(type: .text, title: loginIdCaption, value: "")
                    inputs.append(dynamicInputType)
                }
                
                if let passwordCaption =  selectedFinancialInstitution.passwordCaption {
                    let dynamicInputType = DynamicFormInput(type: .password, title: passwordCaption, value: "")
                    inputs.append(dynamicInputType)
                }
                
                if let securityCodeCaption =  selectedFinancialInstitution.securityCodeCaption {
                    let dynamicInputType = DynamicFormInput(type: .password, title: securityCodeCaption, value: "")
                    inputs.append(dynamicInputType)
                }
                
                if let secondaryLoginIdCaption =  selectedFinancialInstitution.secondaryLoginIdCaption {
                    let dynamicInputType = DynamicFormInput(type: .text, title: secondaryLoginIdCaption, value: "")
                    inputs.append(dynamicInputType)
                }

                let confirmButton = DynamicFormInput(type: .confirmButton, title: "Link Accounts", value: "")
                inputs.append(confirmButton)
                
                let spacer = DynamicFormInput(type: .spacer, title: "", value: "")
                inputs.append(spacer)
                
                resolver.fulfill(inputs)
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
  
    func submitFormWith(loginId : String?, password : String?, securityCode : String?, secondaryLoginId : String?, isUpdateConnection :Bool)->Promise<Bool> {

        var dict : [String:Any] = [:]

        if let loginId = loginId {
             dict["loginId"] = loginId
        }
        if let password = password {
            dict["password"] = password
        }
        if let securityCode = securityCode {
            dict["securityCode"] = securityCode
        }
        if let secondaryLoginId = secondaryLoginId {
            dict["secondaryLoginId"] = secondaryLoginId
        }
        if let institutionID = AppData.shared.selectedFinancialInstitution?._id {
           dict["institution"] = ["id":institutionID]
        }
        
        LoggingUtil.shared.cPrint("\n\n >> submitFormWith dict = \(dict)")
        var activeAuthUser: AuthUser?
        
        return Promise<Bool>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().then { authUser -> Promise<[String:Any]> in
                activeAuthUser = authUser
                let url = URL.init(string: self.appTokenResponse?.apiConnectionUrl ?? "")
                let headers = [ "Content-Type" : "application/json", "Authorization": "Bearer \(self.appTokenResponse?.accessToken ?? "")"]
                return self.callAPI(url: url!, param: dict, headers: headers)
            }.then{ dict -> Promise<BasiqConnectionResponse> in
                let basiqConnectionResponse = try! DictionaryDecoder().decode(BasiqConnectionResponse.self, from: dict)
                return Promise<BasiqConnectionResponse>() { res in
                     res.fulfill(basiqConnectionResponse)
                }
            }.then{ basiqConnectionResponse -> Promise<Bool> in
                LoggingUtil.shared.cPrint("basiqConnectionResponse = \(basiqConnectionResponse)")
                self.jobId = basiqConnectionResponse.id ?? ""
                AppData.shared.bankJobId = basiqConnectionResponse.id ?? ""                
                let request = PostConnectionJobRequest.init(jobId: self.jobId, institutionId: AppData.shared.selectedFinancialInstitution?._id ?? "", isUpdateConnection: isUpdateConnection)
                return CheqAPIManager.shared.postBasiqConnectionJob(req:request)
            }.then{ boolValue -> Promise<AuthUser> in
                return AuthConfig.shared.activeManager.retrieveAuthToken(activeAuthUser!)
            }.then { authUser in
               return AuthConfig.shared.activeManager.setUser(authUser)
            }.done { authUser  in
                LoggingUtil.shared.cPrint("submitFormWith Completed")
                resolver.fulfill(true)
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    
    
//GetConnectionJobResponse
//    {
//      "institutionId": "string",
//      "step": "VerifyingCredentials",
//      "stepStatus": "Pending",
//      "error": "InvalidCredentials",
//      "errorTitle": "string",
//      "errorDetail": "string",
//      "showClose": true,
//      "showReconnect": true,
//      "showChatWithUs": true,
//      "actionRequiredGuidelines": [
//        "string"
//      ]
//    }
    
    func checkConnectionJobStatus() -> Promise<GetConnectionJobResponse> {
        return Promise<GetConnectionJobResponse>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().then { authUser -> Promise<GetConnectionJobResponse> in
                return  CheqAPIManager.shared.getBasiqConnectionJobStatus(jobId: self.jobId)
            }.done { getConnectionJobResponse  in
                LoggingUtil.shared.cPrint("getConnectionJobResponse = \(getConnectionJobResponse)")
                resolver.fulfill(getConnectionJobResponse)
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    func nextViewController(){
        var vcInfo = [String: String]()
        vcInfo[NotificationUserInfoKey.storyboardName.rawValue] = StoryboardName.main.rawValue
        vcInfo[NotificationUserInfoKey.storyboardId.rawValue] = MainStoryboardId.tab.rawValue
        NotificationUtil.shared.notify(UINotificationEvent.switchRoot.rawValue, key: NotificationUserInfoKey.vcInfo.rawValue, object: vcInfo)
    }

    
    func callAPI(url:URL, param : [String: Any], headers : [String :Any]?) -> Promise<[String: Any]> {
        return Promise<[String: Any]>() { resolver in
            Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers : headers as? HTTPHeaders)
                .validate()
                .responseJSON { response in
    
                    switch response.result {
                    case .success(let json):
                        guard let dictionary = json as? [String: Any] else {
                            //resolver.reject(ActivityError.malformed("not a dictionary"))
                            return
                        }
                        print(dictionary)
                        resolver.fulfill(dictionary)
                    case .failure(let error):
                        resolver.reject(error)
                    }
            }
        }
    }
}

extension LinkAccountsCoordinator {
    func convertInstitutionCredentialPromptType(_ prompt: MobileSDK.InstitutionCredentialPromptModel)->DynamicFormTextFieldType {
        switch prompt.type {
        case .TEXT:
            return .text
        case .PASSWORD:
            return .password
        case .CHECKBOX:
            return .checkBox
        }
    }
}

extension LinkAccountsCoordinator {
    
    //    func loadForm() -> Promise<[DynamicFormInput]> {
    //
    //        return Promise<[DynamicFormInput]> () { resolver in
    //            guard AppData.shared.financialInstitutions.count > 0 else { resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutions); return }
    //            guard let selectedFinancialInstitution = AppData.shared.selectedFinancialInstitution else { resolver.reject(ValidationError.unableToMapSelectedBank); return }
    //
    //            // login again in case we have timed out issue
    //            AuthConfig.shared.activeManager.getCurrentUser().then { authUser->Promise<InstitutionCredentialsFormModel> in
    //                return MoneySoftManager.shared.getBankSignInForm(selectedFinancialInstitution)
    //            }.done { signInForm in
    //
    //                // we store the form instance
    //                AppData.shared.financialSignInForm = signInForm
    //                let form: InstitutionCredentialsFormModel = signInForm
    //                var inputs = [DynamicFormInput]()
    //                for prompt in form.prompts {
    //                    let dynamicInputType = DynamicFormInput(type: self.convertInstitutionCredentialPromptType(prompt), title: prompt.label, value: "")
    //                    inputs.append(dynamicInputType)
    //                }
    //                let confirmButton = DynamicFormInput(type: .confirmButton, title: "Link Accounts", value: "")
    //                inputs.append(confirmButton)
    //                let spacer = DynamicFormInput(type: .spacer, title: "", value: "")
    //                inputs.append(spacer)
    //                resolver.fulfill(inputs)
    //            }.catch { err in
    //                resolver.reject(err)
    //            }
    //        }
    //    }
    
    func printForm(_ form: InstitutionCredentialsFormModel) {
        LoggingUtil.shared.cPrint("form")
        LoggingUtil.shared.cPrint("financial institution id - \(form.financialInstitutionId)")
        LoggingUtil.shared.cPrint("provider institution id - \(form.providerInstitutionId)")
        LoggingUtil.shared.cPrint("prompts - \(form.prompts.description)")
        LoggingUtil.shared.cPrint("financial service id - \(form.financialServiceId)")
    }
    
    func printAuthUser(_ authUser: AuthUser) {
        LoggingUtil.shared.cPrint("authUser moneysoft username \(String(describing: authUser.msCredential[.msUsername]))")
        LoggingUtil.shared.cPrint("authUser moneysoft password \(String(describing: authUser.msCredential[.msPassword]))")
    }
    
    func submitFormForMigration()->Promise<Bool> {
        return Promise<Bool>() { resolver in
            let form = AppData.shared.financialSignInForm
            let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
            printForm(form)
                AuthConfig.shared.activeManager.getCurrentUser().then(on: concurrentQueue) { authUser->Promise<[FinancialAccountModel]> in
                    self.printAuthUser(authUser)
                    return MoneySoftManager.shared.getAccounts()
                }.then { fetchedAccounts-> Promise<Bool> in
                    AppData.shared.storedAccounts = fetchedAccounts
                    let postFinancialAccountsReq = DataHelperUtil.shared.postFinancialAccountsReq(AppData.shared.storedAccounts)
                    return CheqAPIManager.shared.postAccounts(postFinancialAccountsReq)
                }.then { sucesss->Promise<Bool> in
                    // if there is disableAccount, we try to update the status using updateAccountCredentials
                    // which will update the credential in the PDV
                    let fetchedAccounts = AppData.shared.storedAccounts
                    let disabledAccounts = fetchedAccounts.filter{ $0.disabled == true}
                    if disabledAccounts.count > 0, let disableAccount = disabledAccounts.first {
                        return MoneySoftManager.shared.updateAccountCredentials(disableAccount, credentialFormModel: form)
                    } else {
                        return Promise<Bool>() { res in
                            res.fulfill(true)
                        }
                    }
                }.then { success-> Promise<[FinancialAccountModel]> in
                    return MoneySoftManager.shared.getAccounts()
                }.then { accounts->Promise<[FinancialAccountModel]> in
                    AppData.shared.storedAccounts = accounts
                    let refreshOptions = RefreshAccountOptions()
                    refreshOptions.includeTransactions = true
                    return MoneySoftManager.shared.refreshAccounts(AppData.shared.storedAccounts, refreshOptions: refreshOptions)
                }.then { refreshedAccounts->Promise<[FinancialTransactionModel]> in
                    let transactionFilter = TransactionFilter()
                    transactionFilter.fromDate = nil
                    transactionFilter.toDate = Date()
                    transactionFilter.count = 1000
                    transactionFilter.offset = 0
                    return MoneySoftManager.shared.getTransactions(transactionFilter)
                }.then { transactions->Promise<Bool> in
                    for elems in transactions {
                        print(elems.date)
                    }
                    LoggingUtil.shared.cPrint("transaction count: \(transactions.count)")
                    AppData.shared.financialTransactions = transactions
                    let postFinancialTransactionsReq = DataHelperUtil.shared.postFinancialTransactionsRequest(transactions)
                    return CheqAPIManager.shared.postTransactions(postFinancialTransactionsReq)
                }.done { success in
                    resolver.fulfill(true)
                }.catch { err in
                    resolver.reject(err)
                }
        }
    }
    
    func submitFormForOnboarding()->Promise<Bool> {
        return Promise<Bool>() { resolver in
            let form = AppData.shared.financialSignInForm
            let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
            AuthConfig.shared.activeManager.getCurrentUser().then(on: concurrentQueue) { authUser->Promise<[FinancialAccountLinkModel]> in
                    return MoneySoftManager.shared.linkableAccounts(form)
                }.then { linkableAccounts-> Promise<[FinancialAccountModel]> in
                    return MoneySoftManager.shared.linkAccounts(linkableAccounts)
                }.then { linkedAccounts-> Promise<[FinancialAccountModel]> in
                    return MoneySoftManager.shared.getAccounts()
                }.then { fetchedAccounts-> Promise<Bool> in
                    AppData.shared.storedAccounts = fetchedAccounts
                    let postFinancialAccountsReq = DataHelperUtil.shared.postFinancialAccountsReq(AppData.shared.storedAccounts)
                    return CheqAPIManager.shared.postAccounts(postFinancialAccountsReq)
                }.then { success->Promise<[FinancialAccountModel]> in
                    let refreshOptions = RefreshAccountOptions()
                    refreshOptions.includeTransactions = true
                    let fetchedAccounts = AppData.shared.storedAccounts
                    let enabledAccounts = fetchedAccounts.filter{ $0.disabled == false}
                    return MoneySoftManager.shared.refreshAccounts(enabledAccounts, refreshOptions: refreshOptions)
                }.then { refreshedAccounts->Promise<[FinancialTransactionModel]> in
                    let transactionFilter = TransactionFilter()
                    transactionFilter.fromDate = 3.months.earlier
                    transactionFilter.toDate = Date()
                    transactionFilter.count = 10000
                    transactionFilter.offset = 0
                    return MoneySoftManager.shared.getTransactions(transactionFilter)
                }.then { transactions->Promise<Bool> in
                    LoggingUtil.shared.cPrint("transaction count: \(transactions.count)")
                    AppData.shared.financialTransactions = transactions
                    let postFinancialTransactionsReq = DataHelperUtil.shared.postFinancialTransactionsRequest(transactions)
                    return CheqAPIManager.shared.postTransactions(postFinancialTransactionsReq)
                }.done { success in
                    resolver.fulfill(true)
                }.catch { err in
                    resolver.reject(err)
            
                }
        }
    }
    
    func submitForm()->Promise<Bool> {
        if AppData.shared.migratingToNewDevice == true {
            return self.submitFormForMigration()
        } else {
            return self.submitFormForOnboarding()
        }
    }
}
