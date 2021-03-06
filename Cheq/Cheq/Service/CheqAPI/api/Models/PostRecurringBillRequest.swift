//
// PostRecurringBillRequest.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct PostRecurringBillRequest: Codable {

    public enum RecurringFrequency: String, Codable { 
        case weekly = "Weekly"
        case fortnightly = "Fortnightly"
        case monthly = "Monthly"
        case bimonthly = "Bimonthly"
        case quarterly = "Quarterly"
        case halfYearly = "HalfYearly"
        case yearly = "Yearly"
    }
    public var _description: String?
    public var merchant: String?
    public var amount: Double?
    public var startDate: Date?
    public var endDate: Date?
    public var recurringFrequency: RecurringFrequency?

    public init(_description: String?, merchant: String?, amount: Double?, startDate: Date?, endDate: Date?, recurringFrequency: RecurringFrequency?) {
        self._description = _description
        self.merchant = merchant
        self.amount = amount
        self.startDate = startDate
        self.endDate = endDate
        self.recurringFrequency = recurringFrequency
    }

    public enum CodingKeys: String, CodingKey { 
        case _description = "description"
        case merchant
        case amount
        case startDate
        case endDate
        case recurringFrequency
    }


}

