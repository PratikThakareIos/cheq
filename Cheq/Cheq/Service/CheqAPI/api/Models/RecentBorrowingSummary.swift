//
// RecentBorrowingSummary.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct RecentBorrowingSummary: Codable {

    public var totalCashRequested: Double?
    public var totalRepaymentAmount: Double?
    public var totalFees: Double?
    public var feesPercent: Double?
    public var repaymentDate: String?
    public var hasOverdueLoans: Bool?

    public init(totalCashRequested: Double?, totalRepaymentAmount: Double?, totalFees: Double?, feesPercent: Double?, repaymentDate: String?, hasOverdueLoans: Bool?) {
        self.totalCashRequested = totalCashRequested
        self.totalRepaymentAmount = totalRepaymentAmount
        self.totalFees = totalFees
        self.feesPercent = feesPercent
        self.repaymentDate = repaymentDate
        self.hasOverdueLoans = hasOverdueLoans
    }


}

