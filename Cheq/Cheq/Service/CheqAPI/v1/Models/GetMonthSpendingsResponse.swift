//
// GetMonthSpendingsResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct GetMonthSpendingsResponse: Codable {

    public var accountName: String?
    public var accountNumber: String?
    public var accountBalance: Double?
    public var accountType: String?
    public var assetType: String?
    public var totalSpend: Double?
    public var totalIncome: Double?
    public var dailySpending: [DailySpendings]?
    public var categoryStats: [CategoryStat]?

    public init(accountName: String?, accountNumber: String?, accountBalance: Double?, accountType: String?, assetType: String?, totalSpend: Double?, totalIncome: Double?, dailySpending: [DailySpendings]?, categoryStats: [CategoryStat]?) {
        self.accountName = accountName
        self.accountNumber = accountNumber
        self.accountBalance = accountBalance
        self.accountType = accountType
        self.assetType = assetType
        self.totalSpend = totalSpend
        self.totalIncome = totalIncome
        self.dailySpending = dailySpending
        self.categoryStats = categoryStats
    }


}

