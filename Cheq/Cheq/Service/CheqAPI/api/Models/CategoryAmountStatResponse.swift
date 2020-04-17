//
// CategoryAmountStatResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct CategoryAmountStatResponse: Codable {

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
    
    public var categoryId: Int?
    public var categoryTitle: String?
    public var categoryCode: CategoryCode?
    public var categoryAmount: Double?
    public var totalAmount: Double?

    public init(categoryId: Int?, categoryTitle: String?, categoryCode: CategoryCode?, categoryAmount: Double?, totalAmount: Double?) {
        self.categoryId = categoryId
        self.categoryTitle = categoryTitle
        self.categoryCode = categoryCode
        self.categoryAmount = categoryAmount
        self.totalAmount = totalAmount
    }


}

