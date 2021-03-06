//
// SpendingOverviewCard.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct SpendingOverviewCard: Codable {

    public var allAccountCashBalance: Double?
    public var numberOfDaysTillPayday: Int?
    public var payCycleStartDate: String?
    public var payCycleEndDate: String?
    public var infoIcon: String?

    public init(allAccountCashBalance: Double?, numberOfDaysTillPayday: Int?, payCycleStartDate: String?, payCycleEndDate: String?, infoIcon: String?) {
        self.allAccountCashBalance = allAccountCashBalance
        self.numberOfDaysTillPayday = numberOfDaysTillPayday
        self.payCycleStartDate = payCycleStartDate
        self.payCycleEndDate = payCycleEndDate
        self.infoIcon = infoIcon
    }


}

