//
// CreateUserForAssemblyDemo.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct CreateUserForAssemblyDemo: Codable {

    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var dateOfBirth: String?
    public var address: String?
    public var suburb: String?
    public var state: String?
    public var postCode: String?
    public var driverLicense: String?
    public var driverLicenseState: String?
    public var passport: String?
    public var bsb: String?
    public var accountName: String?
    public var accountNumber: String?
    public var bankName: String?

    public init(firstName: String?, lastName: String?, email: String?, dateOfBirth: String?, address: String?, suburb: String?, state: String?, postCode: String?, driverLicense: String?, driverLicenseState: String?, passport: String?, bsb: String?, accountName: String?, accountNumber: String?, bankName: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.dateOfBirth = dateOfBirth
        self.address = address
        self.suburb = suburb
        self.state = state
        self.postCode = postCode
        self.driverLicense = driverLicense
        self.driverLicenseState = driverLicenseState
        self.passport = passport
        self.bsb = bsb
        self.accountName = accountName
        self.accountNumber = accountNumber
        self.bankName = bankName
    }


}

