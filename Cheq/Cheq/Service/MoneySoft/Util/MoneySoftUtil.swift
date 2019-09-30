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
    
    func randomPutUserEmployerRequest()-> PutUserEmployerRequest {
        let dataUtil = DataHelperUtil.shared
        let employer = PutUserEmployerRequest(employerName: dataUtil.testEmployerName(), employmentType: dataUtil.testEmploymentType(), address: dataUtil.testEmployeAddress(), noFixedAddress: false, latitude: 0.0, longitude: 0.0, postCode: dataUtil.testPostcode(), state: dataUtil.testState().rawValue, country: dataUtil.testCountry())
        return employer
    }
    
    func randomPostPushNotificationReq()-> PostPushNotificationRequest {
        let dataUtil = DataHelperUtil.shared
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? dataUtil.randomString(30)
        let pushNotificationReq = PostPushNotificationRequest(deviceId: deviceId, firebasePushNotificationToken: dataUtil.randomString(30), applePushNotificationToken: dataUtil.randomString(30), deviceType: .ios)
        return pushNotificationReq
    }
    
    func demoBankFormModel()-> InstitutionCredentialsFormModel {
        let form = InstitutionCredentialsFormModel(financialServiceId: 733, financialInstitutionId: 253, providerInstitutionId: "1201")
        return form
    }
    
    func stgeorgeBankFormModel()-> InstitutionCredentialsFormModel {
        let form = InstitutionCredentialsFormModel(financialServiceId: -1, financialInstitutionId: 239, providerInstitutionId: "1004")
        return form
    }
    
    // update this for testing different banks
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

    func loginAccount2()-> [LoginCredentialType: String] {
        var login: [LoginCredentialType: String] = [:]
        login[.msUsername] = "eca91f24varun@test.com"
        login[.msPassword] = "61BFF5E53C0C484Da3b78f4383efbfcB"
        return login 
    }

    func loginAccount3()-> [LoginCredentialType: String] {
        var login: [LoginCredentialType: String] = [:]
        login[.msUsername] = "7259de58testx@gmail.com"
        login[.msPassword] = "ACD7F2402B34444Cbbfe38538ab3c1fA"
        return login
    }
    
    func logErrorModel(_ apiErrorModel: ApiErrorModel?) {
        guard let err = apiErrorModel else { return }
        LoggingUtil.shared.cPrint("error code: \(err)")
        let provider = EnumerationManager.labelForErrorKey(.PROVIDER)
        let mfaFieldKey = EnumerationManager.labelForErrorKey(.MFA_FIELD_TYPE)
        let mfaPromptKey = EnumerationManager.labelForErrorKey(.MFA_PROMPT)
        let messageKey = EnumerationManager.labelForErrorKey(.MESSAGE)
        let keys = [provider, mfaFieldKey, mfaPromptKey, messageKey]
        keys.forEach {
            if let message = err.messages[$0] {
                LoggingUtil.shared.cPrint("\($0):\(message)")
            }
        }
        
    }
}
