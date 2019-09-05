//
//  MoneySoftUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import MobileSDK

class MoneySoftUtil {
    
    static let shared = MoneySoftUtil()
    private init() {}
    
    func randomPutUserReq()-> PutUserRequest {
        let putUserReq = PutUserRequest(detail: randomPutUserDetailReq(), employer: randomPutUserEmployerRequest(), pushNotification: nil, kyc: randomPutUserKycRequest())
        return putUserReq
    }
    
    func randomPutUserEmployerRequest()-> PutUserEmployerRequest {
        let authUserUtil = AuthUserUtil.shared
        let employer = PutUserEmployerRequest(employerName: authUserUtil.randomString(10), employmentType: .fulltime, address: authUserUtil.randomAddress(), noFixedAddress: false, latitude: 100.0, longitude: 100.0)
        return employer
    }
    
    func randomPutUserDetailReq()-> PutUserDetailRequest {
        let authUserUtil = AuthUserUtil.shared
        let mb = authUserUtil.randomPhone(10)
        let randomAddress =  authUserUtil.randomAddress()
        let detail = PutUserDetailRequest(firstName: authUserUtil.randomString(8), lastName: authUserUtil.randomString(8), mobile: mb, residentialAddress: randomAddress)
        return detail
    }
    
    func randomPostPushNotificationReq()-> PostPushNotificationRequest {
        let authUserUtil = AuthUserUtil.shared
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? authUserUtil.randomString(30)
        let pushNotificationReq = PostPushNotificationRequest(deviceId: deviceId, firebasePushNotificationToken: authUserUtil.randomString(30), applePushNotificationToken: authUserUtil.randomString(30), deviceType: .ios)
        return pushNotificationReq
    }
    
    func randomPutUserKycRequest()-> PutUserKycRequest {
        let authUserUtil = AuthUserUtil.shared
        let putUserKycReq = PutUserKycRequest(dateOfBirth: "10/10/1980", driverLicenceState: "NSW", driverLicenceNumber: authUserUtil.randomPhone(10), passportNumber: authUserUtil.randomPhone(10), passportCountry: "Australia")
        return putUserKycReq
    }
    
    func demoBankFormModel()-> InstitutionCredentialsFormModel {
        let form = InstitutionCredentialsFormModel(financialServiceId: 733, financialInstitutionId: 253, providerInstitutionId: "1201")
        return form
    }
    
    func stgeorgeBankFormModel()-> InstitutionCredentialsFormModel {
        let form = InstitutionCredentialsFormModel(financialServiceId: -1, financialInstitutionId: 239, providerInstitutionId: "1004")
        return form
    }
    
    func fillFormUsingStGeorgeAccount(_ form: inout InstitutionCredentialsFormModel) {
        for promptModel in form.prompts {
            switch(promptModel.type) {
            case .TEXT:
                if promptModel.label == "Card/Access Number" {
                    promptModel.savedValue = "4239530051245679"
                }
                if promptModel.label == "Issue Number" {
                    promptModel.savedValue = "01"
                }
            case .PASSWORD:
                if promptModel.label == "Internet Password" {
                    promptModel.savedValue = "1stliang"
                }
                if promptModel.label == "Security Number" {
                    promptModel.savedValue = "129846"
                }
              
            case .CHECKBOX:
                promptModel.savedValue = "true"
                break
            }
        }
    }
    
    func fillFormWithTestAccount(_ form: inout InstitutionCredentialsFormModel) {
        for promptModel in form.prompts {
            switch(promptModel.type) {
            case .TEXT:
                promptModel.savedValue = "user01"
            case .PASSWORD:
                promptModel.savedValue = "user01"
            case .CHECKBOX:
                promptModel.savedValue = "true"
                break
            }
        }
    }
    
    func loginAccount()->  [LoginCredentialType: String] {
        var login: [LoginCredentialType: String] = [:]
        login[.msUsername] = "cheq_01@usecheq.com"
        login[.msPassword] = "cheq01!"
        return login
    }
}
