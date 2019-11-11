//
// PutUserOnfidoKycRequest.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct PutUserOnfidoKycRequest: Codable {

    public enum State: String, Codable { 
        case nsw = "NSW"
        case qld = "QLD"
        case sa = "SA"
        case tas = "TAS"
        case vic = "VIC"
        case wa = "WA"
        case act = "ACT"
        case nt = "NT"
    }
    public var firstName: String
    public var lastName: String
    public var dateOfBirth: Date?
    public var residentialAddress: String?
    public var suburb: String?
    public var postCode: String?
    public var state: State?

    public init(firstName: String, lastName: String, dateOfBirth: Date?, residentialAddress: String?, suburb: String?, postCode: String?, state: State?) {
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.residentialAddress = residentialAddress
        self.suburb = suburb
        self.postCode = postCode
        self.state = state
    }


}

