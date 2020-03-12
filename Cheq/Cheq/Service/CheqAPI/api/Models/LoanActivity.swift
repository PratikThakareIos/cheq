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
    public var date: String?
    public var cheqPayReference: String?
    public var type: ModelType?
    public var status: Status?
    public var loanAgreement: String?
    public var directDebitAgreement: String?
    public var notes: String?
    public var repaymentDate: String?

    public init(amount: Double?, fee: Double?, date: String?, cheqPayReference: String?, type: ModelType?, status: Status?, loanAgreement: String?, directDebitAgreement: String?, notes: String?, repaymentDate: String?) {
        self.amount = amount
        self.fee = fee
        self.date = date
        self.cheqPayReference = cheqPayReference
        self.type = type
        self.status = status
        self.loanAgreement = loanAgreement
        self.directDebitAgreement = directDebitAgreement
        self.notes = notes
        self.repaymentDate = repaymentDate
    }


}

