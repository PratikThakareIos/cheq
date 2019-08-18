//
// PutUserRequest.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct PutUserRequest: Codable {

    public var firstName: String
    public var middleName: String?
    public var lastName: String
    public var mobileNumber: String
    public var residentialAddress: String?
    public var employer: PutUserEmployerRequest?
    public var pushNotification: PostPushNotificationRequest?
    public var kyc: PutUserKycRequest?

    public init(firstName: String, middleName: String?, lastName: String, mobileNumber: String, residentialAddress: String?, employer: PutUserEmployerRequest?, pushNotification: PostPushNotificationRequest?, kyc: PutUserKycRequest?) {
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.mobileNumber = mobileNumber
        self.residentialAddress = residentialAddress
        self.employer = employer
        self.pushNotification = pushNotification
        self.kyc = kyc
    }


}
