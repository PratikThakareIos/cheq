//
//  MoneySoftManagerIntegrationTests.swift
//  CheqTests
//
//  Created by Xuwei Liang on 3/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import XCTest
import PromiseKit
import Firebase
import MobileSDK
@testable import Cheq 

class MoneySoftManagerIntegrationTests: XCTestCase {

    let moneySoftManager = MoneySoftManager.shared
    let authUserUtil = AuthUserUtil.shared
    let firebaseAuth = FirebaseAuthManager.shared
    
    func testMoneySoftSDK() {
        let expectation = XCTestExpectation(description: "test money soft sdk integrations")
        let login: [LoginCredentialType: String] = MoneySoftUtil.shared.loginAccount()
        MoneySoftManager.shared.login(login)
        .then { msAuthModel-> Promise<UserProfileModel> in
            MoneySoftManager.shared.getProfile()
        }.then { profile->Promise<[FinancialInstitutionModel]> in
            MoneySoftManager.shared.getInstitutions()
        }.then { institutions->Promise<InstitutionCredentialsFormModel> in
            let banks: [FinancialInstitutionModel] = institutions
            banks.forEach {
                let name = $0.name ?? ""
                LoggingUtil.shared.cPrint(name)
            }
            let selected = banks.first(where: { $0.name == "Demobank"})
            return MoneySoftManager.shared.getBankSignInForm(selected!)
        }.then { signInForm->Promise<[FinancialAccountLinkModel]> in
            var form = signInForm
            MoneySoftUtil.shared.fillFormWithTestAccount(&form)
            return MoneySoftManager.shared.linkableAccounts(form)
        }.then { linkableAccounts in
            return MoneySoftManager.shared.linkAccounts(linkableAccounts)
        }.then { linkedAccounts in
            return MoneySoftManager.shared.getAccounts() 
            }.then { fetchedAccounts  -> Promise<[FinancialAccountModel]> in
            let refreshOptions = RefreshAccountOptions()
            refreshOptions.includeTransactions = true
            let enabledAccounts = fetchedAccounts.filter{ $0.disabled == false}
            return MoneySoftManager.shared.refreshAccounts(enabledAccounts, refreshOptions: refreshOptions)
        }.then { refreshedAccounts->Promise<[FinancialTransactionModel]> in
            let transactionFilter = TransactionFilter()
            transactionFilter.count = 1000
            transactionFilter.offset = 0
            return MoneySoftManager.shared.getTransactions(transactionFilter)
            }.then { transactions -> Promise<[FinancialTransactionModel]> in
            let transactionFilter = TransactionFilter()
            transactionFilter.fromDate = Date()
            transactionFilter.toDate = Date()
            transactionFilter.count = 1000
            transactionFilter.offset = 0
            return MoneySoftManager.shared.getTransactions(transactionFilter)
        }.done { transactions in
            LoggingUtil.shared.cPrint(transactions.count)
            XCTAssertTrue(transactions.count > 0)
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
            XCTFail()
        }.finally {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
    
    func testMoneySoftCredentials() {
        let expectation = XCTestExpectation(description: "test money soft sdk integrations")
        let login: [LoginCredentialType: String] = MoneySoftUtil.shared.loginAccount()
        MoneySoftManager.shared.login(login)
        .then { msAuthModel-> Promise<UserProfileModel> in
            MoneySoftManager.shared.getProfile()
        }.then { profile->Promise<[FinancialInstitutionModel]> in
            MoneySoftManager.shared.getInstitutions()
        }.then { institutions->Promise<InstitutionCredentialsFormModel> in
            let banks: [FinancialInstitutionModel] = institutions
            banks.forEach {
                let name = $0.name ?? ""
                LoggingUtil.shared.cPrint(name)
            }
            let selected = banks.first(where: { $0.name == "St.George Bank"})
            return MoneySoftManager.shared.getBankSignInForm(selected!)
        }.done { credentialsFormModel in
            let form: InstitutionCredentialsFormModel = credentialsFormModel
            LoggingUtil.shared.cPrint(form)
            XCTAssertTrue(true)
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
            XCTFail()
        }.finally {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
}
