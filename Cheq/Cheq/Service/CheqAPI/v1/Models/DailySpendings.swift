//
// DailySpendings.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct DailySpendings: Codable {

    public var date: String?
    public var spending: [GetSpendingResponse]?

    public init(date: String?, spending: [GetSpendingResponse]?) {
        self.date = date
        self.spending = spending
    }


}

