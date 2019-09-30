//
//  EmailUtil.swift
//  Cheq
//
//  Created by XUWEI LIANG on 23/8/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import DateToolsSwift
import MobileSDK

class DataHelperUtil {

    static let shared = DataHelperUtil()
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
        let randomSuffix = suffix.randomElement() ?? "gmail.com"
        return "\(randomPrefix)@\(randomSuffix)"
    }

    func randomPassword()-> String {
        return randomString(12)
    }
    
    func postFinancialTransactionsReq(_ transactions: [FinancialTransactionModel])-> [PostFinancialTransactionRequest] {
        let postFinancialTransactionsRequest = transactions.map {
            PostFinancialTransactionRequest(transactionId: $0.transactionId, accountId: $0.accountId, categoryId: $0.categoryId, amount: $0.amount, date: $0.date, isDeleted: $0.isDeleted, isVerified: $0.isVerified, merchant: $0.merchant ?? "", _description: $0.description, type: convertTransactionType($0.type), source: "")
        }
        return postFinancialTransactionsRequest
    }
    
    func convertTransactionType(_ transactionType: MobileSDK.TransactionType)-> String {
        let value = transactionType.rawValue
        return String(value)
    }
    
    func postFinancialAccountsReq(_ accounts: [FinancialAccountModel])-> [PostFinancialAccountRequest] {
        
        let postFinancialAccountsRequest = accounts.map { PostFinancialAccountRequest(financialAccountId: $0.financialAccountId , providerAccountId: $0.providerAccountId ?? "", financialInstitutionId: $0.financialInstitutionId , providerInstitutionId: Int($0.providerInstitutionId ?? "-1"), providerContainerId: $0.providerContainerId ?? "", name: $0.name , nickname: $0.nickname ?? "", number: $0.number, balance: $0.balance, disabled: $0.disabled, type: $0.type.name(), assetType: $0.assetType.name(), source: "") }
        return postFinancialAccountsRequest
    }
    
    func postFinancialInstitutionsRequest(_ institutions: [FinancialInstitutionModel])-> [PostFinancialInstitutionRequest] {
        let postFinancialInstitutionsRequest = institutions.map{ PostFinancialInstitutionRequest(financialInstitutionId: $0.financialInstitutionId, providerInstitutionId: $0.providerInstitutionId, name: $0.name ?? "", alias: $0.alias ?? "", displayName: $0.displayName ?? "", order: $0.order, isActive: $0.isActive(), financialServiceId: -1, isMFA: $0.isMFA(), providerId: -1) }
        return postFinancialInstitutionsRequest
    }

    func postFinancialTransactionsRequest(_ transactions: [FinancialTransactionModel])-> [PostFinancialTransactionRequest] {
        let postFinancialTransactionsRequest = transactions.map {
            PostFinancialTransactionRequest(transactionId: $0.transactionId, accountId: $0.accountId, categoryId: $0.categoryId, amount: $0.amount, date: $0.date, isDeleted: $0.isDeleted, isVerified: $0.isVerified, merchant: $0.merchant ?? "", _description: $0.description, type: convertTransactionType($0.type), source: "")
        }

        return postFinancialTransactionsRequest
    }
    
    func putEmployerDetailsReq()-> PutUserEmployerRequest {
        
        let employerReq = PutUserEmployerRequest(employerName: DataHelperUtil.shared.testEmployerName(), employmentType: .fulltime, address: DataHelperUtil.shared.testEmployeAddress(), noFixedAddress: false, latitude: -33.8653556, longitude: 151.205377, postCode: DataHelperUtil.shared.testPostcode(), state: DataHelperUtil.shared.testState().rawValue, country: DataHelperUtil.shared.testCountry())
        return employerReq
    }
    
    func putUserDetailsReq()-> PutUserDetailRequest {

        let authUserUtil = DataHelperUtil.shared
        let req = PutUserDetailRequest(firstName: authUserUtil.testFirstname(), lastName: authUserUtil.testLastname(), ageRange: authUserUtil.testAgeRange(), mobile: authUserUtil.testMobile(), maritalStatus: .single, numberOfDependents: String(0), state: authUserUtil.testState())

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

    func testState()-> PutUserDetailRequest.State {
        return .nsw
    }
    
    func testCountry()-> String {
        return "Australia"
    }
}
