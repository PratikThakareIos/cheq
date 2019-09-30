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
            guard let selectedFinancialInstitution = AppData.shared.financialInstitutions.first(where: { $0.name == AppData.shared.selectedFinancialInstitution }) else { resolver.reject(ValidationError.unableToMapSelectedBank); return }
            MoneySoftManager.shared.getBankSignInForm(selectedFinancialInstitution).done { signInForm in
                
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
    
    func submitForm()->Promise<Bool> {
        return Promise<Bool>() { resolver in
            let form = AppData.shared.financialSignInForm
            MoneySoftManager.shared.linkableAccounts(form).then { linkableAccounts in
            return MoneySoftManager.shared.linkAccounts(linkableAccounts)
            }.then { linkedAccounts in
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

    func nextViewController()->UIViewController {
        let storyboard = UIStoryboard(name: StoryboardName.spending.rawValue, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: SpendingStoryboardId.overview.rawValue)
        return vc
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
