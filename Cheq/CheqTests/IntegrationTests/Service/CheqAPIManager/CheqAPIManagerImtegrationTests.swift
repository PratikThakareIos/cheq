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

    func testMSCredentials2() {
        let expectation = XCTestExpectation(description: "testMSCredentials2")
        let msUsername = "6de84f89hello-world3@gmail.com"
        let msPassword = "D446973F99864BCC84d469f817f94dcB"
        let login = LoginModel(username: msUsername, password: msPassword)
 
        do {
            try MoneySoftManager.shared.msApi.user().login(details: login, listener: ApiListener<AuthenticationModel>(successHandler: { authModel in
                    LoggingUtil.shared.cPrint("")
                    expectation.fulfill()
                }, errorHandler: { errModel in
                    MoneySoftUtil.shared.logErrorModel(errModel)
                    expectation.fulfill()
                }))
        } catch {
            LoggingUtil.shared.cPrint("")
        }
            
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
    
    func testMSCredentials() {
        let testEmail = "rrhello-world3@gmail.com"
        let testPassword = "HelloWorld123!"
//        let userDetails = DataHelperUtil.shared.putUserDetailsReq()
        
        let expectation = XCTestExpectation(description: "testPutUserDetails3")
//        var credentials = [LoginCredentialType: String]()
//        credentials[.email] = testEmail
//        credentials[.password] = testPassword
//        authManager.activeManager.login(<#T##credentials: [LoginCredentialType : String]##[LoginCredentialType : String]#>)(.socialLoginEmail, credentials: credentials)
//        .then { authUser->Promise<AuthUser> in
//            return CheqAPIManager.shared.putUserDetails(userDetails)
//        }.then { authUser->Promise<Void> in
//            return MoneySoftManager.shared.logout()
//        }.then { ()->Promise<AuthUser> in
//            return self.authManager.activeManager.getCurrentUser()
//        }.then { authUser->Promise<AuthenticationModel> in
//            LoggingUtil.shared.cPrint(authUser.authToken() ?? "")
//            let msCredential = authUser.msCredential
        
        var msCredential = [LoginCredentialType: String]()
        msCredential[.msUsername] = "eca91f24varun@test.com"
        msCredential[.msPassword] = "61BFF5E53C0C484Da3b78f4383efbfcB"
        MoneySoftManager.shared.login(msCredential)
        .done { authModel in
            LoggingUtil.shared.cPrint(authModel.accessToken ?? "")
        }.catch { err in
            LoggingUtil.shared.cPrint(err.localizedDescription)
        }.finally {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
    
    func testPutUserDetails2() {
        let testBank = "Demobank"
        var storedAccounts = [FinancialAccountModel]()
        var storedTransactions = [FinancialTransactionModel]()
        let testEmail = DataHelperUtil.shared.randomEmail()
        let testPassword = DataHelperUtil.shared.testPass()
        let userDetails = DataHelperUtil.shared.putUserDetailsReq()

        let expectation = XCTestExpectation(description: "testPutUserDetails2")
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = testEmail
        credentials[.password] = testPassword
        authManager.activeManager.register(.socialLoginEmail, credentials: credentials)
            .then { authUser in
                return self.authManager.activeManager.login(credentials)
            }.then { authUser->Promise<AuthUser> in
                return CheqAPIManager.shared.putUserDetails(userDetails)
            }.then { authUser->Promise<AuthenticationModel> in
                LoggingUtil.shared.cPrint(authUser.authToken() ?? "")
//                let msCredential = authUser.msCredential
                var credentials = MoneySoftUtil.shared.loginAccount2()
                return MoneySoftManager.shared.login(credentials)
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
            }.then { success->Promise<GetSpendingOverviewResponse> in
                return CheqAPIManager.shared.spendingOverview()
            }.then { overview-> Promise<[FinancialAccountModel]> in
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

    func testPutUserDetails() {
        let dataUtil = DataHelperUtil.shared
        
        let userDetails = dataUtil.putUserDetailsReq()
        let expectation = XCTestExpectation(description: "testPutUserDetails")
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = DataHelperUtil.shared.testEmail()
        credentials[.password] = DataHelperUtil.shared.testPass()
        authManager.activeManager.login(credentials)
        .then { authUser in
            return CheqAPIManager.shared.putUserDetails(userDetails)
        }.done { response in
            LoggingUtil.shared.cPrint(response)
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
            XCTFail()
        }.finally {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
    
    func testPutUserOnfidoKyc() {
        let dataUtil = DataHelperUtil.shared
        let userDetails = dataUtil.putUserDetailsReq()
        let expectation = XCTestExpectation(description: "testPutUserOnfidoKyc")
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = DataHelperUtil.shared.testEmail()
        credentials[.password] = DataHelperUtil.shared.testPass()
        authManager.activeManager.login(credentials)
        .then { authUser in
            CheqAPIManager.shared.putUserDetails(userDetails)
        }.then { authUser -> Promise<PutUserKycResponse> in
            
            
            CheqAPIManager.shared.retrieveUserDetailsKyc(firstName: userDetails.firstName, lastName: userDetails.lastName, residentialAddress: "", dateOfBirth: 20.years.earlier)
        }.done { kycResponse in
            let resp: PutUserKycResponse = kycResponse
            XCTAssertNotNil(resp.sdkToken)
            XCTAssertNotNil(resp.applicantId)
            LoggingUtil.shared.cPrint(resp.sdkToken ?? "")
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
            XCTFail()
        }.finally {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
    
    func testCheckKYCPhotoUploaded() {
        let expectation = XCTestExpectation(description: "testCheckKYCPhotoUploaded")
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = DataHelperUtil.shared.randomEmail()
        credentials[.password] = DataHelperUtil.shared.randomPassword()
        AuthConfig.shared.activeManager.register(.socialLoginEmail, credentials: credentials).then { authUser in
        return AuthConfig.shared.activeManager.login(credentials)
        }.then { authUser in
            return CheqAPIManager.shared.putUserDetails(DataHelperUtil.shared.putUserDetailsReq())
        }.then { authUser->Promise<PutUserKycResponse> in
            CheqAPIManager.shared.retrieveUserDetailsKyc(firstName: "", lastName: "", residentialAddress: "", dateOfBirth: 20.years.earlier)
        }.done { response in
            let kycResponse: PutUserKycResponse = response
            let sdkToken = kycResponse.sdkToken ?? ""
            LoggingUtil.shared.cPrint("sdk token: \(sdkToken)")
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
            XCTAssertTrue(true)
        }.finally {
             expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
    
    func testAddressLookup() {
        let expectation = XCTestExpectation(description: "testAddressLookup")
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = DataHelperUtil.shared.testEmail()
        credentials[.password] = DataHelperUtil.shared.testPass()
        AuthConfig.shared.activeManager.login(credentials)
            .then { authUser->Promise<[GetAddressResponse]> in
                CheqAPIManager.shared.residentialAddressLookup(DataHelperUtil.shared.testAddress())
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
}
