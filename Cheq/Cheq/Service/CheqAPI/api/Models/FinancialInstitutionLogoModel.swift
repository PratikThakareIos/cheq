//
// FinancialInstitutionLogoModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct FinancialInstitutionLogoModel: Codable {

    public var institutionId: Int?
    public var name: String?
    public var displayName: String?
    public var logoByteArray: Data?
    public var logoContentType: String?

    public init(institutionId: Int?, name: String?, displayName: String?, logoByteArray: Data?, logoContentType: String?) {
        self.institutionId = institutionId
        self.name = name
        self.displayName = displayName
        self.logoByteArray = logoByteArray
        self.logoContentType = logoContentType
    }


}

