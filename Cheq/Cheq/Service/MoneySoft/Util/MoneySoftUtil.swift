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
        let testUtil = TestUtil.shared
        let employer = PutUserEmployerRequest(employerName: testUtil.testEmployerName(), employmentType: testUtil.testEmploymentType(), address: testUtil.testEmployeAddress(), noFixedAddress: false, latitude: 0.0, longitude: 0.0, postCode: testUtil.testPostcode(), state: testUtil.testState().rawValue, country: testUtil.testCountry())
        return employer
    }
    
    func demoBankFormModel()-> InstitutionCredentialsFormModel {
        let form = InstitutionCredentialsFormModel(financialServiceId: 733, financialInstitutionId: 253, providerInstitutionId: "1201")
        return form
    }
    
    func stgeorgeBankFormModel()-> InstitutionCredentialsFormModel {
        let form = InstitutionCredentialsFormModel(financialServiceId: -1, financialInstitutionId: 239, providerInstitutionId: "1004")
        return form
    }

    func fillFormWithStGeorgeAccount(_ form: inout InstitutionCredentialsFormModel) {
        for promptModel in form.prompts {
            switch(promptModel.index) {
            case 1: promptModel.savedValue = "4239530051245679"
            case 2: promptModel.savedValue = "129846"
            case 3: promptModel.savedValue = "1stliang"
            case 4: promptModel.savedValue =  "1"

            default:
                break
            }
        }
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
