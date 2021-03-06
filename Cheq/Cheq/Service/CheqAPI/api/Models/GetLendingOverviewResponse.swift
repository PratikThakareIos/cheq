//
// GetLendingOverviewResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct GetLendingOverviewResponse: Codable {

    public var bankAccount: BankAccount?
    public var loanSetting: LoanSetting?
    public var borrowOverview: BorrowOverview?
    public var recentBorrowings: RecentBorrowingSummary?
    public var eligibleRequirement: EligibleRequirement?
    public var decline: DeclineDetail?

    public init(bankAccount: BankAccount?, loanSetting: LoanSetting?, borrowOverview: BorrowOverview?, recentBorrowings: RecentBorrowingSummary?, eligibleRequirement: EligibleRequirement?, decline: DeclineDetail?) {
        self.bankAccount = bankAccount
        self.loanSetting = loanSetting
        self.borrowOverview = borrowOverview
        self.recentBorrowings = recentBorrowings
        self.eligibleRequirement = eligibleRequirement
        self.decline = decline
    }
}

public struct BankAccount: Codable {
    public var maskedNumber: String?
    
    public init(maskedNumber: String){
        self.maskedNumber = maskedNumber
    }
}

