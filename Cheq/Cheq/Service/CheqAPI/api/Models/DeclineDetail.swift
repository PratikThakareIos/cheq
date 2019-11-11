//
// DeclineDetail.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct DeclineDetail: Codable {

    public enum DeclineReason: String, Codable { 
        case _none = "None"
        case creditAssessment = "CreditAssessment"
        case employmentType = "EmploymentType"
        case jointAccount = "JointAccount"
        case kycFailed = "KycFailed"
        case monthlyPayCycle = "MonthlyPayCycle"
        case noPayCycle = "NoPayCycle"
        case hasWriteOff = "HasWriteOff"
        case hasNameConflict = "HasNameConflict"
        case identityConflict = "IdentityConflict"
    }
    public var declineReason: DeclineReason?
    public var declineDescription: String?

    public init(declineReason: DeclineReason?, declineDescription: String?) {
        self.declineReason = declineReason
        self.declineDescription = declineDescription
    }


}

