//
// PutUserKycRequest.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct PutUserKycRequest: Codable {

    public var dateOfBirth: String?
    public var driverLicenceState: String?
    public var driverLicenceNumber: String?
    public var passportNumber: String?
    public var passportCountry: String?

    public init(dateOfBirth: String?, driverLicenceState: String?, driverLicenceNumber: String?, passportNumber: String?, passportCountry: String?) {
        self.dateOfBirth = dateOfBirth
        self.driverLicenceState = driverLicenceState
        self.driverLicenceNumber = driverLicenceNumber
        self.passportNumber = passportNumber
        self.passportCountry = passportCountry
    }


}

