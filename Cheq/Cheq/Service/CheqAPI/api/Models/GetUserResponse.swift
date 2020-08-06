//
// GetUserResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct GetUserResponse: Codable {

    public var userDetail: GetUserDetailResponse?
    public var employer: GetUserEmployerResponse?

    public init(userDetail: GetUserDetailResponse?, employer: GetUserEmployerResponse?) {
        self.userDetail = userDetail
        self.employer = employer
    }


}

