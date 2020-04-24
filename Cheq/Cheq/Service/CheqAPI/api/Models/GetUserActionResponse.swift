//
// GetUserActionResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct GetUserActionResponse: Codable {

    public enum UserAction: String, Codable { 
        case _none = "None"
        case accountReactivation = "AccountReactivation"
        case actionRequiredByBank = "ActionRequiredByBank"
        case bankNotSupported = "BankNotSupported"
        case invalidCredentials = "InvalidCredentials"
        case requireMigration = "RequireMigration"
        case missingAccount = "MissingAccount"
        case requireBankLinking = "RequireBankLinking"
    }
    public var userAction: UserAction?
    public var title: String?
    public var detail: String?
    public var link: String?

    public init(userAction: UserAction?, title: String?, detail: String?, link: String?) {
        self.userAction = userAction
        self.title = title
        self.detail = detail
        self.link = link
    }


}

