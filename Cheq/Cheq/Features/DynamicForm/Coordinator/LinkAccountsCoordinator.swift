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
    
    func submitFormForMigration()->Promise<Bool> {
        return Promise<Bool>() { resolver in
            let form = AppData.shared.financialSignInForm
                AuthConfig.shared.activeManager.getCurrentUser().then { authUser->Promise<Bool> in
                return MoneySoftManager.shared.updateAccountCredentials(AppData.shared.disabledAccount, credentialFormModel: form)
                }.then { success->Promise<[FinancialAccountModel]> in
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
    
    func submitFormForOnboarding()->Promise<Bool> {
        return Promise<Bool>() { resolver in
            let form = AppData.shared.financialSignInForm
            AuthConfig.shared.activeManager.getCurrentUser().then { authUser->Promise<[FinancialAccountLinkModel]> in
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
