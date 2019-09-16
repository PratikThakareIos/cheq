//
// UserBudget.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct UserBudget: Codable {

    public var _id: Int?
    public var cheqCategoryTitle: String?
    public var categoryIconUrl: String?
    public var spendingBudget: Double?
    public var actualSpending: Double?
    public var canDelete: Bool?

    public init(_id: Int?, cheqCategoryTitle: String?, categoryIconUrl: String?, spendingBudget: Double?, actualSpending: Double?, canDelete: Bool?) {
        self._id = _id
        self.cheqCategoryTitle = cheqCategoryTitle
        self.categoryIconUrl = categoryIconUrl
        self.spendingBudget = spendingBudget
        self.actualSpending = actualSpending
        self.canDelete = canDelete
    }

    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case cheqCategoryTitle
        case categoryIconUrl
        case spendingBudget
        case actualSpending
        case canDelete
    }


}

