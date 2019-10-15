//
//  CheqAPIManagerImtegrationTests.swift
//  CheqTests
//
//  Created by Xuwei Liang on 16/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//
import Foundation
import XCTest
import PromiseKit
import MobileSDK
import DateToolsSwift
@testable import Cheq

class CheqAPIManagerImtegrationTests: XCTestCase {
    
    let authManager = AuthConfig.shared
    var authorizedUser: AuthUser?

    func testMoneySoftAPIEndtoEnd() {
        let testBank = "Demobank"
        var storedAccounts = [FinancialAccountModel]()
        var storedTransactions = [FinancialTransactionModel]()
        let testEmail = TestUtil.shared.randomEmail()
        let testPassword = TestUtil.shared.testPass()
        let userDetails = TestUtil.shared.putUserDetailsReq()

        let expectation = XCTestExpectation(description: "testMoneySoftAPIEndtoEnd")
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = testEmail
        credentials[.password] = testPassword
        authManager.activeManager.register(.socialLoginEmail, credentials: credentials)
            .then { authUser in
                return self.authManager.activeManager.login(credentials)
            }.then { authUser->Promise<Void> in
                CheqAPIManager.shared.requestEmailVerificationCode()
            }.then { ()->Promise<AuthUser> in
                let req = PutUserSingupVerificationCodeRequest(code: "111111")
                return CheqAPIManager.shared.validateEmailVerificationCode(req)
            }.then { authUser->Promise<AuthUser> in
                return self.authManager.activeManager.retrieveAuthToken(authUser)
            }.then { authUser->Promise<AuthUser> in
                return CheqAPIManager.shared.putUserDetails(userDetails)
            }.then { authUser->Promise<GetUserKycResponse> in
                let onfidoKycReq = PutUserOnfidoKycRequest(firstName: userDetails.firstName, lastName: userDetails.lastName, dateOfBirth: 30.years.earlier, residentialAddress: TestUtil.shared.testAddress(), state: TestUtil.shared.testState())
                return CheqAPIManager.shared.retrieveUserDetailsKyc(onfidoKycReq)
            }.then { getUserKycResponse->Promise<AuthUser> in
                XCTAssertNotNil(getUserKycResponse.sdkToken)
                XCTAssertNotNil(getUserKycResponse.applicantId)
                LoggingUtil.shared.cPrint(getUserKycResponse.sdkToken ?? "")
                return self.authManager.activeManager.getCurrentUser()
            }.then { authUser->Promise<AuthenticationModel> in
                LoggingUtil.shared.cPrint(authUser.authToken() ?? "")
                let msCredential = authUser.msCredential
                return MoneySoftManager.shared.login(msCredential)
            }.then { msAuthModel-> Promise<UserProfileModel> in
                return MoneySoftManager.shared.getProfile()
            }.then { profile->Promise<[FinancialInstitutionModel]> in
                MoneySoftManager.shared.getInstitutions()
            }.then { institutions->Promise<InstitutionCredentialsFormModel> in
                let banks: [FinancialInstitutionModel] = institutions
                banks.forEach {
                    let name = $0.name ?? ""
                    LoggingUtil.shared.cPrint(name)
                }
                let selected = banks.first(where: { $0.name == testBank})
                LoggingUtil.shared.cPrint(selected?.name ?? "")
                return MoneySoftManager.shared.getBankSignInForm(selected!)
            }.then { signInForm->Promise<[FinancialAccountLinkModel]> in
                var form = signInForm
                MoneySoftUtil.shared.fillFormWithTestAccount(&form)
                LoggingUtil.shared.cPrint(form)
                return MoneySoftManager.shared.linkableAccounts(form)
            }.then { linkableAccounts in
                return MoneySoftManager.shared.linkAccounts(linkableAccounts)
            }.then { linkedAccounts in
                return MoneySoftManager.shared.getAccounts()
            }.then { fetchedAccounts  -> Promise<Bool> in
                storedAccounts = fetchedAccounts
                let postFinancialAccountReq = DataHelperUtil.shared.postFinancialAccountsReq(fetchedAccounts)
                return CheqAPIManager.shared.postAccounts(postFinancialAccountReq)
            }.then { succcess -> Promise<[FinancialAccountModel]> in
                let refreshOptions = RefreshAccountOptions()
                refreshOptions.includeTransactions = true
                let enabledAccounts = storedAccounts.filter{ $0.disabled == false}
                return MoneySoftManager.shared.refreshAccounts(enabledAccounts, refreshOptions: refreshOptions)
            }.then { refreshedAccounts->Promise<[FinancialTransactionModel]> in
                storedAccounts = refreshedAccounts
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
            }.then { transactions->Promise<Bool> in
                storedTransactions = transactions
                let postFinancialTransactionsReq = DataHelperUtil.shared.postFinancialTransactionsReq(transactions)
                return CheqAPIManager.shared.postTransactions(postFinancialTransactionsReq)
            }.then { success->Promise<AuthUser> in
                return self.authManager.activeManager.getCurrentUser()
            }.then { authUser->Promise<AuthUser> in
                return self.authManager.activeManager.retrieveAuthToken(authUser)
            }.then { success->Promise<GetSpendingOverviewResponse> in
               sleep(15)
               return CheqAPIManager.shared.spendingOverview()
            }.then { overview-> Promise<[FinancialAccountModel]> in
                XCTAssertNotNil(overview.topCategoriesAmount)
                XCTAssertNotNil(overview.upcomingBills)
                XCTAssertNotNil(overview.recentTransactions)
                LoggingUtil.shared.cPrint(overview)

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
                XCTAssertTrue(storedTransactions.count > 0)
            }.catch { err in
                LoggingUtil.shared.cPrint(err)
                XCTFail()
            }.finally {
                XCTAssertTrue(true)
                expectation.fulfill()
            }

        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }

    func testAddressLookup() {
        let expectation = XCTestExpectation(description: "testAddressLookup")
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = TestUtil.shared.randomEmail()
        credentials[.password] = TestUtil.shared.randomPassword()
        AuthConfig.shared.activeManager.register(.socialLoginEmail, credentials: credentials)
            .then { authUser->Promise<[GetAddressResponse]> in
                CheqAPIManager.shared.residentialAddressLookup(TestUtil.shared.testAddress())
            }.done { addressList in
                XCTAssertTrue(addressList.count > 0)
                for current in addressList {
                    LoggingUtil.shared.cPrint(current.address ?? "")
                }
            }.catch { err in
                LoggingUtil.shared.cPrint(err)
                XCTFail()
            }.finally {
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }

    func testEmployerAddressLookup() {
        let expectation = XCTestExpectation(description: "testEmployerAddressLookup")
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = TestUtil.shared.randomEmail()
        credentials[.password] = TestUtil.shared.randomPassword()
        AuthConfig.shared.activeManager.register(.socialLoginEmail, credentials: credentials)
            .then { authUser->Promise<[GetEmployerPlaceResponse]> in
                CheqAPIManager.shared.employerAddressLookup(TestUtil.shared.testAddress())
            }.done { addressList in
                XCTAssertTrue(addressList.count > 0)
                for current in addressList {
                    LoggingUtil.shared.cPrint(current.address ?? "")
                }
            }.catch { err in
                LoggingUtil.shared.cPrint(err)
                XCTFail()
            }.finally {
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }

    func testEmployerNameLookup() {
        let expectation = XCTestExpectation(description: "testEmployerNameLookup")
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = TestUtil.shared.randomEmail()
        credentials[.password] = TestUtil.shared.randomPassword()
        AuthConfig.shared.activeManager.register(.socialLoginEmail, credentials: credentials)
            .then { authUser->Promise<[GetEmployerPlaceResponse]> in
                CheqAPIManager.shared.employerAddressLookup(TestUtil.shared.testEmployerName())
            }.done { addressList in
                XCTAssertTrue(addressList.count > 0)
                for current in addressList {
                    LoggingUtil.shared.cPrint(current.name ?? "")
                }
            }.catch { err in
                LoggingUtil.shared.cPrint(err)
                XCTFail()
            }.finally {
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
}
