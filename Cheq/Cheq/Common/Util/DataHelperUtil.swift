//
//  EmailUtil.swift
//  Cheq
//
//  Created by XUWEI LIANG on 23/8/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import MobileSDK

/**
 DataHelperUtil is a helper class to build request payload and perform data transformation for API calls. When we want to build a complicated request payload, we encapsulate the logics in this class. So that it's resuable later on. Some API request payload requires repeated data transformation logics.
 */
class DataHelperUtil {

    /// Singleton instance of **DateHelperUtil**
    static let shared = DataHelperUtil()
    
    /// private init method
    private init() {}
    
    /**
     Helper method to create **PUT** request to reset password
    - parameter code: email verification code
    - parameter newPassword: new password inserted from the user
    - Returns: Put request payload to tell backend to reset user's password
    */
    func putResetPasswordRequest(_ code: String, newPassword: String)-> PutResetPasswordRequest {
        let req = PutResetPasswordRequest(email: AppData.shared.forgotPasswordEmail, verificationCode: code, newPassword: newPassword)
        return req
    }
    
    /**
     Helper method to request password reset verification email
     - Returns: Post request payload to trigger backend to send an password reset email
     */
    func postForgotPasswordRequest()-> PostForgetPasswordRequest {
        let req = PostForgetPasswordRequest(email: AppData.shared.forgotPasswordEmail)
        return req
    }
    
    /**
     Helper method to **PUT** user details for Onfido KYC validation
     - Returns: **PUT** request payload to put user defailts for Onfido KYC validation
     */
    func retrieveUserDetailsKycReq()-> PutUserOnfidoKycRequest {
        let qVm = QuestionViewModel()
        /// question answer values are loaded up using **QuestionViewModel** method - **loadSaved**
        qVm.loadSaved()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = TestUtil.shared.dobFormatStyle()
        let dob = dateFormatter.date(from: qVm.fieldValue(.dateOfBirth)) ?? Date()
        let cStateString = qVm.fieldValue(.residentialState)
        let state = StateCoordinator.convertCStateToState(cState(fromRawValue: cStateString))
        
        /// Notice that **fieldValue** is used to access the saved answers instead of directly accessing the answer map inside **QuestionViewModel**
        let req = PutUserOnfidoKycRequest(firstName: qVm.fieldValue(.firstname), lastName: qVm.fieldValue(.lastname), dateOfBirth: dob, residentialAddress: qVm.fieldValue(.residentialAddress), suburb: qVm.fieldValue(.residentialSuburb), postCode: qVm.fieldValue(.residentialPostcode), state: state)
        return req 
    }
    
    /**
     Helper method to build a post requet payload for loan
     - Returns: **POST** request payload to trigger a loan application in the backend
     */
    func postLoanRequest()->PostLoanRequest {
        let amount = Int(AppData.shared.amountSelected) ?? 0
        /// **AppData.shared.loanFee** should be value retrieved from backend and stored on AppData
        let fee = Int(AppData.shared.loanFee)
        
        /// ensure the user have gone through the UI flow to accept agreement
        let hasAccepted = AppData.shared.acceptedAgreement
        let req = PostLoanRequest(amount: amount, fee: fee, agreeLoanAgreement: hasAccepted)
        return req 
    }
    
    /**
     Helper method to build a put request payload for updating user employer
     - Returns: **PUT** request payload to trigger a user's employer details
     */
    func putUserEmployerRequest()->PutUserEmployerRequest {
        
        /// To retrieve the stored question answers, first initialise a **QuestionViewModel**
        let qVm = QuestionViewModel()
        
        /// Call the method **loadSaved**, so the saved answer values are loaded onto this **QuestionViewModel** instance.
        qVm.loadSaved()
        
        /// User **fieldValue** method with **QuestionField** enum as argument to accesss the answered values.
        let employmentType = EmploymentType(fromRawValue: qVm.fieldValue(QuestionField.employerType))
        let putReqEmploymentType = MultipleChoiceViewModel.cheqAPIEmploymentType(employmentType)
        let noFixedAddress = employmentType == .onDemand ? true : false
        let req = PutUserEmployerRequest(employerName: qVm.fieldValue(QuestionField.employerName), employmentType: putReqEmploymentType, address: qVm.fieldValue(QuestionField.employerAddress), noFixedAddress: noFixedAddress, latitude: Double(qVm.fieldValue(.employerLatitude)) ?? 0.0, longitude: Double(qVm.fieldValue(.employerLongitude)) ?? 0.0, postCode: qVm.fieldValue(.employerPostcode), state: qVm.fieldValue(.employerState), country: qVm.fieldValue(.employerCountry))
        return req
    }
    
    /**
     Helper method to build a post request payload containing the push notification tokens used by backend's purpose.
     - Returns: **Post** request payload containing the device's registered firebase notification token and apple's push notification token.
     */
    func postPushNotificationRequest()-> PostPushNotificationRequest {
        let fcmToken = CKeychain.shared.getValueByKey(CKey.fcmToken.rawValue)
        let apnsToken = CKeychain.shared.getValueByKey(CKey.apnsToken.rawValue)
        let req = PostPushNotificationRequest(deviceId: UUID().uuidString, firebasePushNotificationToken: fcmToken, applePushNotificationToken: apnsToken, deviceType: .ios)
        return req
    }
    
    /**
     Helper method to build post a request payload containing the transactions retrieved from MoneySoft SDK.
     - parameter transactions: list of **FinancialTransactionModel** from MoneySoft SDK
     - Returns: list of transaction types that is use for posting back to Cheq backend
     */
    func postFinancialTransactionsReq(_ transactions: [FinancialTransactionModel])-> [PostFinancialTransactionRequest] {
        let postFinancialTransactionsRequest = transactions.map {
            PostFinancialTransactionRequest(transactionId: $0.transactionId, accountId: $0.accountId, categoryId: $0.categoryId, amount: $0.amount, date: $0.date, isDeleted: $0.isDeleted, isVerified: $0.isVerified, merchant: $0.merchant ?? "", _description: $0.name ?? "", type: convertTransactionType($0.type), source: "")
        }
        return postFinancialTransactionsRequest
    }
    
    /**
     Helper method converting **MobileSDK.TransactionType** to String
     */
    func convertTransactionType(_ transactionType: MobileSDK.TransactionType)-> String {
        let value = transactionType.rawValue
        return String(value)
    }
    
    /**
     Helper method to build a post request payload with retrieved accounts from MoneySoft SDK.
     - parameter accounts: list of **FinancialAccountModel** retrieved from MoneySoft SDK
     - Returns: list of account types for posting to Cheq backend
     */
    func postFinancialAccountsReq(_ accounts: [FinancialAccountModel])-> [PostFinancialAccountRequest] {
        
        let postFinancialAccountsRequest = accounts.map { PostFinancialAccountRequest(financialAccountId: $0.financialAccountId , providerAccountId: $0.providerAccountId ?? "", financialInstitutionId: $0.financialInstitutionId , providerInstitutionId: Int($0.providerInstitutionId ?? "-1"), providerContainerId: $0.providerContainerId ?? "", name: $0.name , nickname: $0.nickname ?? "", number: $0.number, balance: $0.balance, disabled: $0.disabled, type: $0.type.name().uppercased(), assetType: $0.assetType.name().uppercased(), source: "") }
        return postFinancialAccountsRequest
    }
    
    /**
     Helper method to build a post request payload with retrieved banks from MoneySoft SDK.
     - parameter institutions: list of **FinancialInstitutionModel** retreived from MoneySoft SDK
     - Returns: list of institution types for positng to Cheq backend
     */
    func postFinancialInstitutionsRequest(_ institutions: [FinancialInstitutionModel])-> [PostFinancialInstitutionRequest] {
        let postFinancialInstitutionsRequest = institutions.map{ PostFinancialInstitutionRequest(financialInstitutionId: $0.financialInstitutionId, providerInstitutionId: $0.providerInstitutionId, name: $0.name ?? "", alias: $0.alias ?? "", displayName: $0.displayName ?? "", order: $0.order, isActive: $0.isActive(), financialServiceId: -1, isMFA: $0.isMFA(), providerId: -1) }
        return postFinancialInstitutionsRequest
    }
    

    /**
    Helper method to build post a request payload containing the transactions retrieved from MoneySoft SDK.
    - parameter transactions: list of **FinancialTransactionModel** from MoneySoft SDK
    - Returns: list of transaction types that is use for posting back to Cheq backend
    */
//    func postFinancialTransactionsRequest(_ transactions: [FinancialTransactionModel])-> [PostFinancialTransactionRequest] {
//        let postFinancialTransactionsRequest = transactions.map {
//            PostFinancialTransactionRequest(transactionId: $0.transactionId, accountId: $0.accountId, categoryId: $0.categoryId, amount: $0.amount, date: $0.date, isDeleted: $0.isDeleted, isVerified: $0.isVerified, merchant: $0.merchant ?? "", _description: $0.name, type: convertTransactionType($0.type), source: "")
//        }
//
//        return postFinancialTransactionsRequest
//    }
    
    /**
     Helper method to convert **GetUpcomingBillResponse.CategoryCode** to **CategoryAmountStatResponse.CategoryCode**
     - parameter code: These code types are actually for same purpose, but the backend Swagger definition as of the time of documenting has not been consolidated yet.
     */
    func categoryAmountStateCode(_ code: GetUpcomingBillResponse.CategoryCode)->CategoryAmountStatResponse.CategoryCode {
        let categoryAmountStateCode = CategoryAmountStatResponse.CategoryCode(rawValue: code.rawValue) ?? .benefits
        return categoryAmountStateCode
    }
    
    /**
     Helper method to convert **SlimTransactionResponse.CategoryCode** to **CategoryAmountStatResponse.CategoryCode**
     */
    func categoryAmountStateCodeFromTransaction(_ code: SlimTransactionResponse.CategoryCode)->CategoryAmountStatResponse.CategoryCode {
        let categoryAmountStateCode = CategoryAmountStatResponse.CategoryCode(rawValue: code.rawValue) ?? .benefits
        return categoryAmountStateCode
    }
    
    /**
     Helper method to retrieve the corresponding Spending category icon by **CategoryAmountStatResponse.CategoryCode** 
     */
    func iconFromCategory(_ code: CategoryAmountStatResponse.CategoryCode, largeIcon: Bool)-> String {
        switch code {
        case .benefits:
            return largeIcon ? LargeCategoryEmoji.benefits.rawValue : MediumCategoryEmoji.benefits.rawValue
        case .bills:
            return largeIcon ? LargeCategoryEmoji.billsUtilities.rawValue : MediumCategoryEmoji.billsUtilities.rawValue
        case .employmentIncome:
            return largeIcon ? LargeCategoryEmoji.employmentIncome.rawValue : MediumCategoryEmoji.employmentIncome.rawValue
        case .entertainment:
            return largeIcon ? LargeCategoryEmoji.entertainment.rawValue : MediumCategoryEmoji.entertainment.rawValue
        case .financialServices:
            return largeIcon ? LargeCategoryEmoji.financialServices.rawValue : MediumCategoryEmoji.financialServices.rawValue
        case .fitness:
            return largeIcon ? LargeCategoryEmoji.fitness.rawValue : MediumCategoryEmoji.fitness.rawValue
        case .groceries:
            return largeIcon ? LargeCategoryEmoji.groceries.rawValue : MediumCategoryEmoji.groceries.rawValue
        case .health:
            return largeIcon ? LargeCategoryEmoji.health.rawValue : MediumCategoryEmoji.health.rawValue
        case .household:
            return largeIcon ? LargeCategoryEmoji.homeFamily.rawValue : MediumCategoryEmoji.homeFamily.rawValue
        case .ondemandIncome:
            return largeIcon ? LargeCategoryEmoji.ondemandIncome.rawValue : MediumCategoryEmoji.ondemandIncome.rawValue
        case .others:
            return largeIcon ? LargeCategoryEmoji.other.rawValue : MediumCategoryEmoji.ondemandIncome.rawValue
        case .otherDeposit:
            return largeIcon ? LargeCategoryEmoji.otherDeposits.rawValue : MediumCategoryEmoji.otherDeposits.rawValue
        case .restaurantsAndCafes:
            return largeIcon ? LargeCategoryEmoji.restaurantsCafe.rawValue : MediumCategoryEmoji.restaurantsCafe.rawValue
        case .shopping:
            return largeIcon ? LargeCategoryEmoji.shopping.rawValue : MediumCategoryEmoji.shopping.rawValue
        case .secondaryIncome:
            return largeIcon ? LargeCategoryEmoji.secondaryIncome.rawValue : MediumCategoryEmoji.secondaryIncome.rawValue
        case .tobaccoAndAlcohol:
            return largeIcon ? LargeCategoryEmoji.tobaccoAlcohol.rawValue : MediumCategoryEmoji.tobaccoAlcohol.rawValue
        case .transport:
            return largeIcon ? LargeCategoryEmoji.transport.rawValue : MediumCategoryEmoji.transport.rawValue
        case .travel:
            return largeIcon ? LargeCategoryEmoji.travel.rawValue : MediumCategoryEmoji.travel.rawValue
        case .workAndEducation:
            return largeIcon ? LargeCategoryEmoji.work.rawValue : MediumCategoryEmoji.work.rawValue
        }
    }
}
