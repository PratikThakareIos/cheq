//
// DailyTransactionsResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct DailyTransactionsResponse: Codable {

    public var date: String?
    public var transactions: [SlimTransactionResponse]?

    public init(date: String?, transactions: [SlimTransactionResponse]?) {
        self.date = date
        self.transactions = transactions
    }


}

