//
// SalaryTransactionResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct SalaryTransactionResponse: Codable {

    public var transactionId: Int?
    public var amount: Double?
    public var date: Date?
    public var _description: String?
    public var isSalary: Bool?

    public init(transactionId: Int?, amount: Double?, date: Date?, _description: String?, isSalary: Bool?) {
        self.transactionId = transactionId
        self.amount = amount
        self.date = date
        self._description = _description
        self.isSalary = isSalary
    }

    public enum CodingKeys: String, CodingKey { 
        case transactionId
        case amount
        case date
        case _description = "description"
        case isSalary
    }


}

