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
    public var moneySoftCredential: GetUserMoneySoftResponse?
    public var bluedotCredential: GetUserBluedotResponse?

    public init(userDetail: GetUserDetailResponse?, employer: GetUserEmployerResponse?, moneySoftCredential: GetUserMoneySoftResponse?, bluedotCredential: GetUserBluedotResponse?) {
        self.userDetail = userDetail
        self.employer = employer
        self.moneySoftCredential = moneySoftCredential
        self.bluedotCredential = bluedotCredential
    }


}

