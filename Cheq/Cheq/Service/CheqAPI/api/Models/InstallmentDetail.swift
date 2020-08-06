//
// InstallmentDetail.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct InstallmentDetail: Codable {

    public var repaymentAmount: Double?
    public var fee: Double?
    public var repaymentDate: String?

    public init(repaymentAmount: Double?, fee: Double?, repaymentDate: String?) {
        self.repaymentAmount = repaymentAmount
        self.fee = fee
        self.repaymentDate = repaymentDate
    }


}

