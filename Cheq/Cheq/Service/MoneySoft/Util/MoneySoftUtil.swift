//
//  MoneySoftUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

struct MoneySoftUtil {
    
    func randomPutUserReq()-> PutUserRequest {
        let putUserReq = PutUserRequest(detail: randomPutUserDetailReq(), employer: randomPutUserEmployerRequest(), pushNotification: nil, kyc: randomPutUserKycRequest())
        return putUserReq
    }
    
    func randomPutUserEmployerRequest()-> PutUserEmployerRequest {
        let authUserUtil = AuthUserUtil()
        let employer = PutUserEmployerRequest(employerName: authUserUtil.randomString(10), employmentType: .fulltime, address: authUserUtil.randomAddress(), noFixedAddress: false, latitude: 100.0, longitude: 100.0)
        return employer
    }
    
    func randomPutUserDetailReq()-> PutUserDetailRequest {
        let authUserUtil = AuthUserUtil()
        let mb = authUserUtil.randomPhone(10)
        let randomAddress =  authUserUtil.randomAddress()
        let detail = PutUserDetailRequest(firstName: authUserUtil.randomString(8), lastName: authUserUtil.randomString(8), mobile: mb, residentialAddress: randomAddress)
        return detail
    }
    
    func randomPostPushNotificationReq()-> PostPushNotificationRequest {
        let authUserUtil = AuthUserUtil()
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? authUserUtil.randomString(30)
        let pushNotificationReq = PostPushNotificationRequest(deviceId: deviceId, firebasePushNotificationToken: authUserUtil.randomString(30), applePushNotificationToken: authUserUtil.randomString(30), deviceType: .ios)
        return pushNotificationReq
    }
    
    func randomPutUserKycRequest()-> PutUserKycRequest {
        let authUserUtil = AuthUserUtil()
        let putUserKycReq = PutUserKycRequest(dateOfBirth: "10/10/1980", driverLicenceState: "NSW", driverLicenceNumber: authUserUtil.randomPhone(10), passportNumber: authUserUtil.randomPhone(10), passportCountry: "Australia")
        return putUserKycReq
    }
}
