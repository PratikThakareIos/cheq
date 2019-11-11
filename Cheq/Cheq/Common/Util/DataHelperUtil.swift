//
//  EmailUtil.swift
//  Cheq
//
//  Created by XUWEI LIANG on 23/8/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import MobileSDK

class DataHelperUtil {

    static let shared = DataHelperUtil()
    private init() {}
    
    func putResetPasswordRequest(_ code: String, newPassword: String)-> PutResetPasswordRequest {
        let req = PutResetPasswordRequest(email: AppData.shared.forgotPasswordEmail, verificationCode: code, newPassword: newPassword)
        return req
    }
    
    func postForgotPasswordRequest()-> PostForgetPasswordRequest {
        let req = PostForgetPasswordRequest(email: AppData.shared.forgotPasswordEmail)
        return req
    }
    
    func retrieveUserDetailsKycReq()-> PutUserOnfidoKycRequest {
        let qVm = QuestionViewModel()
        qVm.loadSaved()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = TestUtil.shared.dobFormatStyle()
        let dob = dateFormatter.date(from: qVm.fieldValue(.dateOfBirth)) ?? Date()
        let cStateString = qVm.fieldValue(.residentialState)
        let state = StateCoordinator.convertCStateToState(cState(fromRawValue: cStateString))
        
        let req = PutUserOnfidoKycRequest(firstName: qVm.fieldValue(.firstname), lastName: qVm.fieldValue(.lastname), dateOfBirth: dob, residentialAddress: qVm.fieldValue(.residentialAddress), suburb: qVm.fieldValue(.residentialSuburb), postCode: qVm.fieldValue(.residentialPostcode), state: state)
        return req 
    }
    
    func postLoanRequest()->PostLoanRequest {
        let amount = Int(AppData.shared.amountSelected) ?? 0
        let fee = Int(AppData.shared.loanFee) // should get back from backend
        let hasAccepted = AppData.shared.acceptedAgreement
        
        let req = PostLoanRequest(amount: amount, fee: fee, agreeLoanAgreement: hasAccepted)
        return req 
    }
    
    func putUserEmployerRequest()->PutUserEmployerRequest {
        let qVm = QuestionViewModel()
        qVm.loadSaved()
        let employmentType = EmploymentType(fromRawValue: qVm.fieldValue(QuestionField.employerType))
        let putReqEmploymentType = MultipleChoiceViewModel.cheqAPIEmploymentType(employmentType)
        let noFixedAddress = employmentType == .onDemand ? true : false
        let req = PutUserEmployerRequest(employerName: qVm.fieldValue(QuestionField.employerName), employmentType: putReqEmploymentType, address: qVm.fieldValue(QuestionField.employerAddress), noFixedAddress: noFixedAddress, latitude: Double(qVm.fieldValue(.employerLatitude)) ?? 0.0, longitude: Double(qVm.fieldValue(.employerLongitude)) ?? 0.0, postCode: qVm.fieldValue(.employerPostcode), state: qVm.fieldValue(.employerState), country: qVm.fieldValue(.employerCountry))
        return req
    }
    
    func postPushNotificationRequest()-> PostPushNotificationRequest {
        let fcmToken = CKeychain.shared.getValueByKey(CKey.fcmToken.rawValue)
        let apnsToken = CKeychain.shared.getValueByKey(CKey.apnsToken.rawValue)
        let req = PostPushNotificationRequest(deviceId: UUID().uuidString, firebasePushNotificationToken: fcmToken, applePushNotificationToken: apnsToken, deviceType: .ios)
        return req
    }
    
    func postFinancialTransactionsReq(_ transactions: [FinancialTransactionModel])-> [PostFinancialTransactionRequest] {
        let postFinancialTransactionsRequest = transactions.map {
            PostFinancialTransactionRequest(transactionId: $0.transactionId, accountId: $0.accountId, categoryId: $0.categoryId, amount: $0.amount, date: $0.date, isDeleted: $0.isDeleted, isVerified: $0.isVerified, merchant: $0.merchant ?? "", _description: $0.name ?? "", type: convertTransactionType($0.type), source: "")
        }
        return postFinancialTransactionsRequest
    }
    
    func convertTransactionType(_ transactionType: MobileSDK.TransactionType)-> String {
        let value = transactionType.rawValue
        return String(value)
    }
    
    func postFinancialAccountsReq(_ accounts: [FinancialAccountModel])-> [PostFinancialAccountRequest] {
        
        let postFinancialAccountsRequest = accounts.map { PostFinancialAccountRequest(financialAccountId: $0.financialAccountId , providerAccountId: $0.providerAccountId ?? "", financialInstitutionId: $0.financialInstitutionId , providerInstitutionId: Int($0.providerInstitutionId ?? "-1"), providerContainerId: $0.providerContainerId ?? "", name: $0.name , nickname: $0.nickname ?? "", number: $0.number, balance: $0.balance, disabled: $0.disabled, type: $0.type.name().uppercased(), assetType: $0.assetType.name().uppercased(), source: "") }
        return postFinancialAccountsRequest
    }
    
    func postFinancialInstitutionsRequest(_ institutions: [FinancialInstitutionModel])-> [PostFinancialInstitutionRequest] {
        let postFinancialInstitutionsRequest = institutions.map{ PostFinancialInstitutionRequest(financialInstitutionId: $0.financialInstitutionId, providerInstitutionId: $0.providerInstitutionId, name: $0.name ?? "", alias: $0.alias ?? "", displayName: $0.displayName ?? "", order: $0.order, isActive: $0.isActive(), financialServiceId: -1, isMFA: $0.isMFA(), providerId: -1) }
        return postFinancialInstitutionsRequest
    }

    func postFinancialTransactionsRequest(_ transactions: [FinancialTransactionModel])-> [PostFinancialTransactionRequest] {
        let postFinancialTransactionsRequest = transactions.map {
            PostFinancialTransactionRequest(transactionId: $0.transactionId, accountId: $0.accountId, categoryId: $0.categoryId, amount: $0.amount, date: $0.date, isDeleted: $0.isDeleted, isVerified: $0.isVerified, merchant: $0.merchant ?? "", _description: $0.name, type: convertTransactionType($0.type), source: "")
        }

        return postFinancialTransactionsRequest
    }
    
    func categoryAmountStateCode(_ code: GetUpcomingBillResponse.CategoryCode)->CategoryAmountStatResponse.CategoryCode {
        let categoryAmountStateCode = CategoryAmountStatResponse.CategoryCode(rawValue: code.rawValue) ?? .benefits
        return categoryAmountStateCode
    }
    
    func categoryAmountStateCodeFromTransaction(_ code: SlimTransactionResponse.CategoryCode)->CategoryAmountStatResponse.CategoryCode {
        let categoryAmountStateCode = CategoryAmountStatResponse.CategoryCode(rawValue: code.rawValue) ?? .benefits
        return categoryAmountStateCode
    }
    
    func iconFromCategory(_ code: CategoryAmountStatResponse.CategoryCode)-> String {
        switch code {
        case .benefits:
            return LargeCategoryEmoji.benefits.rawValue
        case .bills:
            return LargeCategoryEmoji.billsUtilities.rawValue
        case .employmentIncome:
            return LargeCategoryEmoji.employmentIncome.rawValue
        case .entertainment:
            return LargeCategoryEmoji.entertainment.rawValue
        case .financialServices:
            return LargeCategoryEmoji.financialServices.rawValue
        case .fitness:
            return LargeCategoryEmoji.billsUtilities.rawValue
        case .groceries:
            return LargeCategoryEmoji.groceries.rawValue
        case .health:
            return LargeCategoryEmoji.health.rawValue
        case .household:
            return LargeCategoryEmoji.homeFamily.rawValue
        case .ondemandIncome:
            return LargeCategoryEmoji.ondemandIncome.rawValue
        case .others:
            return LargeCategoryEmoji.other.rawValue
        case .otherDeposit:
            return LargeCategoryEmoji.otherDeposits.rawValue
        case .restaurantsAndCafes:
            return LargeCategoryEmoji.restaurantsCafe.rawValue
        case .shopping:
            return LargeCategoryEmoji.shopping.rawValue
        case .secondaryIncome:
            return LargeCategoryEmoji.secondaryIncome.rawValue
        case .tobaccoAndAlcohol:
            return LargeCategoryEmoji.tobaccoAlcohol.rawValue
        case .transport:
            return LargeCategoryEmoji.transport.rawValue
        case .travel:
            return LargeCategoryEmoji.travel.rawValue
        case .workAndEducation:
            return LargeCategoryEmoji.work.rawValue
        }
    }
}
