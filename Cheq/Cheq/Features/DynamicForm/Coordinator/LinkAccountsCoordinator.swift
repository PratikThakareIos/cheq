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

class LinkAccountsCoordinator: DynamicFormViewModelCoordinator {
    
    var sectionTitle = "Setup bank details"
    var viewTitle = "Login to link your accounts"
    
    func loadForm() -> Promise<[DynamicFormInput]> {
        return Promise<[DynamicFormInput]> () { resolver in
            guard AppData.shared.financialInstitutions.count > 0 else { resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutions); return }
            guard let selectedFinancialInstitution = AppData.shared.selectedFinancialInstitution else { resolver.reject(ValidationError.unableToMapSelectedBank); return }
            
            // login again in case we have timed out issue 
            AuthConfig.shared.activeManager.getCurrentUser().then { authUser->Promise<InstitutionCredentialsFormModel> in
                return MoneySoftManager.shared.getBankSignInForm(selectedFinancialInstitution)
            }.done { signInForm in
                
                // we store the form instance 
                AppData.shared.financialSignInForm = signInForm
                let form: InstitutionCredentialsFormModel = signInForm
                var inputs = [DynamicFormInput]()
                for prompt in form.prompts {
                    let dynamicInputType = DynamicFormInput(type: self.convertInstitutionCredentialPromptType(prompt), title: prompt.label, value: "")
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
            let userInitiatedQueue = DispatchQueue.global(qos: .background)
            printForm(form)
                AuthConfig.shared.activeManager.getCurrentUser().then(on: userInitiatedQueue, flags: .enforceQoS) { authUser->Promise<[FinancialAccountModel]> in
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
    
    func submitFormForOnboarding()->Promise<Bool> {
        return Promise<Bool>() { resolver in
            let form = AppData.shared.financialSignInForm
            let userInitiatedQueue = DispatchQueue.global(qos: .background)
            AuthConfig.shared.activeManager.getCurrentUser().then(on: userInitiatedQueue, flags: .enforceQoS) { authUser->Promise<[FinancialAccountLinkModel]> in
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

    func nextViewController(){
        var vcInfo = [String: String]()
        vcInfo[NotificationUserInfoKey.storyboardName.rawValue] = StoryboardName.main.rawValue
        vcInfo[NotificationUserInfoKey.storyboardId.rawValue] = MainStoryboardId.tab.rawValue
        NotificationUtil.shared.notify(UINotificationEvent.switchRoot.rawValue, key: NotificationUserInfoKey.vcInfo.rawValue, object: vcInfo)
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
