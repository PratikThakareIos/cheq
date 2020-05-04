//
// GetConnectionJobResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct GetConnectionJobResponse: Codable {

    public enum Step: String, Codable { 
        case verifyingCredentials = "VerifyingCredentials"
        case retrievingAccounts = "RetrievingAccounts"
        case retrievingTransactions = "RetrievingTransactions"
        case categorisation = "Categorisation"
    }
    public enum StepStatus: String, Codable { 
        case pending = "Pending"
        case inProgress = "InProgress"
        case failed = "Failed"
        case success = "Success"
    }
    public enum ModelError: String, Codable { 
        case invalidCredentials = "InvalidCredentials"
        case actionRequiredByBank = "ActionRequiredByBank"
        case maintenanceError = "MaintenanceError"
        case temporaryUnavailable = "TemporaryUnavailable"
    }
    public var institutionId: String?
    public var step: Step?
    public var stepStatus: StepStatus?
    public var error: ModelError?
    public var errorTitle: String?
    public var errorDetail: String?

    public init(institutionId: String?, step: Step?, stepStatus: StepStatus?, error: ModelError?, errorTitle: String?, errorDetail: String?) {
        self.institutionId = institutionId
        self.step = step
        self.stepStatus = stepStatus
        self.error = error
        self.errorTitle = errorTitle
        self.errorDetail = errorDetail
    }
}

