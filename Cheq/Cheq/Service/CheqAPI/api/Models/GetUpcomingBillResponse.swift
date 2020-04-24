//
// GetUpcomingBillResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct GetUpcomingBillResponse: Codable {

    public enum RecurringFrequency: String, Codable { 
        case weekly = "Weekly"
        case fortnightly = "Fortnightly"
        case monthly = "Monthly"
        case bimonthly = "Bimonthly"
        case quarterly = "Quarterly"
        case halfYearly = "HalfYearly"
        case yearly = "Yearly"
    }
    public enum CategoryCode: String, Codable { 
        case benefits = "Benefits"
        case bills = "Bills"
        case employmentIncome = "EmploymentIncome"
        case entertainment = "Entertainment"
        case financialServices = "FinancialServices"
        case fitness = "Fitness"
        case groceries = "Groceries"
        case health = "Health"
        case household = "Household"
        case ondemandIncome = "OndemandIncome"
        case others = "Others"
        case otherDeposit = "OtherDeposit"
        case restaurantsAndCafes = "RestaurantsAndCafes"
        case shopping = "Shopping"
        case secondaryIncome = "SecondaryIncome"
        case tobaccoAndAlcohol = "TobaccoAndAlcohol"
        case transport = "Transport"
        case travel = "Travel"
        case workAndEducation = "WorkAndEducation"
    }
    public var _description: String?
    public var merchant: String?
    public var merchantLogoUrl: String?
    public var amount: Double?
    public var dueDate: String?
    public var daysToDueDate: Int?
    public var recurringFrequency: RecurringFrequency?
    public var categoryCode: CategoryCode?
    public var categoryTitle: String?

    public init(_description: String?, merchant: String?, merchantLogoUrl: String?, amount: Double?, dueDate: String?, daysToDueDate: Int?, recurringFrequency: RecurringFrequency?, categoryCode: CategoryCode?, categoryTitle: String?) {
        self._description = _description
        self.merchant = merchant
        self.merchantLogoUrl = merchantLogoUrl
        self.amount = amount
        self.dueDate = dueDate
        self.daysToDueDate = daysToDueDate
        self.recurringFrequency = recurringFrequency
        self.categoryCode = categoryCode
        self.categoryTitle = categoryTitle
    }

    public enum CodingKeys: String, CodingKey { 
        case _description = "description"
        case merchant
        case merchantLogoUrl
        case amount
        case dueDate
        case daysToDueDate
        case recurringFrequency
        case categoryCode
        case categoryTitle
    }


}

