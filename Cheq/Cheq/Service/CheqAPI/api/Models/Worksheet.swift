//
// Worksheet.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct Worksheet: Codable {

    public var atWork: Bool?
    public var dateTime: Date?
    public var distanceMeters: Int?

    public init(atWork: Bool?, dateTime: Date?, distanceMeters: Int?) {
        self.atWork = atWork
        self.dateTime = dateTime
        self.distanceMeters = distanceMeters
    }


}

