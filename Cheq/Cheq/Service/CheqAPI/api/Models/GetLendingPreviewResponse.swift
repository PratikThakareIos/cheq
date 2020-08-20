//
// GetLendingPreviewResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct GetLendingPreviewResponse: Codable {

    public var amount: Double?
    public var fee: Double?
    public var repaymentAmount: Double?
    public var cashoutDate: String?
    public var repaymentDate: String?
    public var abstractLoanAgreement: String?
    public var loanAgreement: String?
    public var directDebitAgreement: String?
    public var companyName: String?
    public var acnAbn: String?
    public var requestCashoutFeedback: Bool?
    public var installments: [InstallmentDetail]?

    public init(amount: Double?, fee: Double?, repaymentAmount: Double?, cashoutDate: String?, repaymentDate: String?, abstractLoanAgreement: String?, loanAgreement: String?, directDebitAgreement: String?, companyName: String?, acnAbn: String?, requestCashoutFeedback: Bool?, installments: [InstallmentDetail]?) {
        self.amount = amount
        self.fee = fee
        self.repaymentAmount = repaymentAmount
        self.cashoutDate = cashoutDate
        self.repaymentDate = repaymentDate
        self.abstractLoanAgreement = abstractLoanAgreement
        self.loanAgreement = loanAgreement
        self.directDebitAgreement = directDebitAgreement
        self.companyName = companyName
        self.acnAbn = acnAbn
        self.requestCashoutFeedback = requestCashoutFeedback
        self.installments = installments
    }


}
