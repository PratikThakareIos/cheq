//
// GetUserEmployerResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct GetUserEmployerResponse: Codable {

    public enum EmploymentType: String, Codable { 
        case fulltime = "Fulltime"
        case parttime = "Parttime"
        case casual = "Casual"
        case selfEmployed = "SelfEmployed"
        case contractor = "Contractor"
        case onDemand = "OnDemand"
    }
    public var employerName: String?
    public var employmentType: EmploymentType?
    public var address: String?
    public var noFixedAddress: Bool?
    public var latitude: Double?
    public var longitude: Double?

    public init(employerName: String?, employmentType: EmploymentType?, address: String?, noFixedAddress: Bool?, latitude: Double?, longitude: Double?) {
        self.employerName = employerName
        self.employmentType = employmentType
        self.address = address
        self.noFixedAddress = noFixedAddress
        self.latitude = latitude
        self.longitude = longitude
    }


}
