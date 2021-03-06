//
// PutBankAccountRequest.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct PutBankAccountRequest: Codable {

    public var accountName: String?
    public var bsb: String?
    public var accountNumber: String?
    public var isJointAccount: Bool?

    public init(accountName: String?, bsb: String?, accountNumber: String?, isJointAccount: Bool?) {
        self.accountName = accountName
        self.bsb = bsb
        self.accountNumber = accountNumber
        self.isJointAccount = isJointAccount
    }


}

