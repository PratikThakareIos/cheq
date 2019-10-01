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
        
        let postFinancialAccountsRequest = accounts.map { PostFinancialAccountRequest(financialAccountId: $0.financialAccountId , providerAccountId: $0.providerAccountId ?? "", financialInstitutionId: $0.financialInstitutionId , providerInstitutionId: Int($0.providerInstitutionId ?? "-1"), providerContainerId: $0.providerContainerId ?? "", name: $0.name , nickname: $0.nickname ?? "", number: $0.number, balance: $0.balance, disabled: $0.disabled, type: $0.type.name().uppercased(), assetType: $0.assetType.name().uppercased(), source: "") }
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
}
