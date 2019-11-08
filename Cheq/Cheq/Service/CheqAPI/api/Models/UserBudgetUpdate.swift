//
// UserBudgetUpdate.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct UserBudgetUpdate: Codable {

    public var budgetId: Int?
    public var hide: Bool?
    public var newEstimatedBudget: Int?

    public init(budgetId: Int?, hide: Bool?, newEstimatedBudget: Int?) {
        self.budgetId = budgetId
        self.hide = hide
        self.newEstimatedBudget = newEstimatedBudget
    }


}
