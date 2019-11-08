//
// LoanSetting.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct LoanSetting: Codable {

    public var maximumAmount: Int?
    public var minimalAmount: Int?
    public var incrementalAmount: Int?

    public init(maximumAmount: Int?, minimalAmount: Int?, incrementalAmount: Int?) {
        self.maximumAmount = maximumAmount
        self.minimalAmount = minimalAmount
        self.incrementalAmount = incrementalAmount
    }


}
