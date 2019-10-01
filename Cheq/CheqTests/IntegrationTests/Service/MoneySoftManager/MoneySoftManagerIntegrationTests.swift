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
import DateToolsSwift
@testable import Cheq 

class MoneySoftManagerIntegrationTests: XCTestCase {

    let moneySoftManager = MoneySoftManager.shared
    let dataUtil = DataHelperUtil.shared
    let firebaseAuth = FirebaseAuthManager.shared
    
    func testMoneySoftSDK() {
        let testBank = "Demobank"
        var storedAccounts: [FinancialAccountModel] = []
        let expectation = XCTestExpectation(description: "test money soft sdk integrations")
        var login: [LoginCredentialType: String] = MoneySoftUtil.shared.loginAccount()
        login[.email] = dataUtil.randomEmail()
        login[.password] = dataUtil.randomPassword()
        AuthConfig.shared.activeManager.login(login).then { authUser in
            CheqAPIManager.shared.putUserDetails(self.dataUtil.putUserDetailsReq())
        }.then { authUser->Promise<AuthenticationModel> in
            let msLogin = authUser.msCredential
            return MoneySoftManager.shared.login(msLogin)
        }.then { msAuthModel-> Promise<UserProfileModel> in
            MoneySoftManager.shared.getProfile()
        }.then { profile->Promise<[FinancialInstitutionModel]> in
            MoneySoftManager.shared.getInstitutions()
        }.then { institutions->Promise<InstitutionCredentialsFormModel> in
            let banks: [FinancialInstitutionModel] = institutions
            banks.forEach {
                let name = $0.name ?? ""
                LoggingUtil.shared.cPrint(name)
            }
            let selected = banks.first(where: { $0.name == testBank})
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
            transactionFilter.fromDate = 30.days.earlier
            transactionFilter.toDate = Date()
            transactionFilter.count = 1000
            transactionFilter.offset = 0
            return MoneySoftManager.shared.getTransactions(transactionFilter)
        }.then { transactions->Promise<[FinancialAccountModel]> in
            let acct = storedAccounts.first ?? FinancialAccountModel(name: "", number: "", balance: 0, type: .BANK)
            return MoneySoftManager.shared.unlinkAccounts([acct])
        }.then { unlinkedAccounts -> Promise<Bool> in
            XCTAssertTrue(unlinkedAccounts.count == 1)
            return MoneySoftManager.shared.forceUnlinkAllAccounts()
        }.then {  success->Promise<[FinancialAccountModel]> in
           return MoneySoftManager.shared.getAccounts()
        }.done { fetchedAccounts in
             let enabledAccounts = fetchedAccounts.filter{ $0.disabled == false}
            XCTAssertTrue(enabledAccounts.count == 0)
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
        let login: [LoginCredentialType: String] = MoneySoftUtil.shared.loginAccount2()
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
