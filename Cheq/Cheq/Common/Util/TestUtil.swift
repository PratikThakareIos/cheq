//
//  TestUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 1/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import MobileSDK
import PromiseKit

class TestUtil {
    static let shared = TestUtil()
    private init() {}
    
    let addressSuffix = ["Magaret Street, Sydney NSW 2000", "York Street, Sydney NSW 2000"]
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-"
    let numbers = "0123456789"
    let suffix = ["gmail.com", "hotmail.com", "facebook.com", "cheq.com.au"]
    
    func randomString(_ length: Int)-> String {
        var result = ""
        for _ in 0..<length {
            result.append(letters.randomElement() ?? "a")
        }
        return result
    }
    
    func randomPhone(_ length: Int)-> String {
        var result = ""
        for _ in 0..<length {
            result.append(numbers.randomElement() ?? "a")
        }
        return result
    }
    
    func randomAddress()-> String {
        let addrSuffix = addressSuffix.randomElement() ?? addressSuffix[0]
        let streetNum = randomPhone(3)
        return String("\(streetNum) \(addrSuffix)")
    }
    
    func randomEmail()-> String {
        let randomPrefix = randomString(10)
        let randomSuffix = "testcheq.com.au"
        return "\(randomPrefix)@\(randomSuffix)"
    }
    
    func emailVerificationCode()-> String {
        return "111111"
    }
    
    func randomPassword()-> String {
        return randomString(12)
    }
    
    func putEmployerDetailsReq()-> PutUserEmployerRequest {
        
        let employerReq = PutUserEmployerRequest(employerName: TestUtil.shared.testEmployerName(), employmentType: .fulltime, address: TestUtil.shared.testEmployeAddress(), noFixedAddress: false, latitude: -33.8653556, longitude: 151.205377, postCode: TestUtil.shared.testPostcode(), state: TestUtil.shared.testState().rawValue, country: TestUtil.shared.testCountry())
        return employerReq
    }
    
    func putUserDetailsReq()-> PutUserDetailRequest {
        
        let testUtil = TestUtil.shared
        let req = PutUserDetailRequest(firstName: testUtil.testFirstname(), lastName: testUtil.testLastname(), ageRange: testUtil.testAgeRange(), mobile: testUtil.testMobile(), state: testUtil.testPutUserState())
        return req
    }
    
    func testDynamicInputs()->[DynamicFormInput] {
        let usernameInput = DynamicFormInput(type: .text, title: "Username")
        let password = DynamicFormInput(type: .password, title: "Password")
        let checkBox = DynamicFormInput(type: .checkBox, title: "isOwner")
        let confirm = DynamicFormInput(type: .confirmButton, title: "Confirm")
        let spacer = DynamicFormInput(type: .spacer, title: "spacer")
        return [usernameInput, password, checkBox, confirm, spacer]
    }
    
    func weakPassword()-> String {
        return "12345678"
    }
    
    // TODO
    func validEmail()-> Bool {
        return true
    }
    
    func testEmail()-> String {
        return "xuwei@cheq.com.au"
    }
    
    func testPass()-> String {
        return "cheqPass808"
    }
    
    func testAddress()-> String {
        return String(describing: "60 \(addressSuffix[0])")
    }
    
    func testMobile()-> String {
        return "0405090733"
    }
    
    func testFirstname()-> String {
        return "Bob"
    }
    
    func testLastname()-> String {
        return "Builder"
    }
    
    func testBirthday()-> Date {
        return 25.years.earlier
    }
    
    func testAgeRange()-> PutUserDetailRequest.AgeRange {
        return .from25To34
    }
    
    func dobFormatStyle()->String {
        return "dd/MM/yyyy"
    }
    
    func testEmployerName()-> String {
        return "Cheq Pty Ltd"
    }
    
    func testEmploymentType()-> PutUserEmployerRequest.EmploymentType {
        return .fulltime
    }
    
    func testEmployeAddress()-> String {
        return "60 Margaret Street, Sydney 2000 NSW"
    }
    
    func testPostcode()-> String {
        return "2000"
    }
    
    func testState()->  PutUserOnfidoKycRequest.State {
        return .nsw
    }
    
    func testPutUserState()-> PutUserDetailRequest.State {
        return .nsw
    }
    
    func testCountry()-> String {
        return "Australia"
    }
    
    func autoSetupAccount()->Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
            let testBank = "demobank"
            var storedAccounts = [FinancialAccountModel]()
//            var storedTransactions = [FinancialTransactionModel]()
            var loginCredentials = [LoginCredentialType: String]()
            loginCredentials[.email] = TestUtil.shared.randomEmail()
            loginCredentials[.password] = TestUtil.shared.randomPassword()
            AuthConfig.shared.activeManager.register(.socialLoginEmail, credentials: loginCredentials).then { authUser->Promise<Void> in
                return CheqAPIManager.shared.requestEmailVerificationCode()
            }.then { ()->Promise<AuthUser> in
                let verificationCode = TestUtil.shared.emailVerificationCode()
                let req = PutUserSingupVerificationCodeRequest(code: verificationCode)
                return CheqAPIManager.shared.validateEmailVerificationCode(req)
            }.then { authUser->Promise<AuthUser> in
                return AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
            }.then { authUser->Promise<AuthUser> in
                let userDetails = TestUtil.shared.putUserDetailsReq()
                return CheqAPIManager.shared.putUserDetails(userDetails)
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
                transactionFilter.fromDate = 90.days.earlier
                transactionFilter.toDate = Date() 
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
//                storedTransactions = transactions
                let postFinancialTransactionsReq = DataHelperUtil.shared.postFinancialTransactionsReq(transactions)
                return CheqAPIManager.shared.postTransactions(postFinancialTransactionsReq)
            }.then { success->Promise<AuthUser> in
                return AuthConfig.shared.activeManager.getCurrentUser()
            }.then { authUser->Promise<AuthUser> in
                return AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
            }.done { authUser in
                resolver.fulfill(authUser)
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
}
