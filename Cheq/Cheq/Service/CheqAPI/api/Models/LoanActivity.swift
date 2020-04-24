//
// LoanActivity.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct LoanActivity: Codable {

    public enum ModelType: String, Codable { 
        case cashout = "Cashout"
        case repayment = "Repayment"
    }
    public enum Status: String, Codable { 
        case unprocessed = "Unprocessed"
        case pending = "Pending"
        case unsuccessfulAttempt = "UnsuccessfulAttempt"
        case debited = "Debited"
        case credited = "Credited"
        case failed = "Failed"
    }
    public var amount: Double?
    public var fee: Double?
    public var exactFee: Double?
    public var date: String?
    public var cheqPayReference: String?
    public var type: ModelType?
    public var status: Status?
    public var hasMissedRepayment: Bool?
    public var isOverdue: Bool?
    public var loanAgreement: String?
    public var directDebitAgreement: String?
    public var repaymentDate: String?
    public var notes: String?
    public var settlementTimingInfo: String?

    public init(amount: Double?, fee: Double?, exactFee: Double?, date: String?, cheqPayReference: String?, type: ModelType?, status: Status?, hasMissedRepayment: Bool?, isOverdue: Bool?, loanAgreement: String?, directDebitAgreement: String?, repaymentDate: String?, notes: String?, settlementTimingInfo: String?) {
        self.amount = amount
        self.fee = fee
        self.exactFee = exactFee
        self.date = date
        self.cheqPayReference = cheqPayReference
        self.type = type
        self.status = status
        self.hasMissedRepayment = hasMissedRepayment
        self.isOverdue = isOverdue
        self.loanAgreement = loanAgreement
        self.directDebitAgreement = directDebitAgreement
        self.repaymentDate = repaymentDate
        self.notes = notes
        self.settlementTimingInfo = settlementTimingInfo
    }


}

