//
// GetEmployerPlaceResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct GetEmployerPlaceResponse: Codable {

    public var name: String?
    public var address: String?
    public var suburb: String?
    public var latitude: Double?
    public var longitude: Double?
    public var postCode: String?
    public var state: String?
    public var country: String?

    public init(name: String?, address: String?, suburb: String?, latitude: Double?, longitude: Double?, postCode: String?, state: String?, country: String?) {
        self.name = name
        self.address = address
        self.suburb = suburb
        self.latitude = latitude
        self.longitude = longitude
        self.postCode = postCode
        self.state = state
        self.country = country
    }


}

