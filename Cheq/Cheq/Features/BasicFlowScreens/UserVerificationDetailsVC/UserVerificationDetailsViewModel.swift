//
//  UserVerificationDetailsViewModel.swift
//  Cheq
//
//  Created by Alexey on 13.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

struct UserVerificationDetailsViewModel {
    struct DocInfo {
        let type: KycDocType
        let number: String
        let state: String?
        
        var hasState: Bool {
            state != nil
        }
    }
    
    let name: String
    let dob: String
    let address: String
    
    let docInfo: DocInfo
    
    func onStartVerification() -> Promise<Void> {
        return Promise<Void>() { resolver in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                resolver.fulfill(())
            }
        }
    }
}

extension UserVerificationDetailsViewModel {
    static func fromAppData() -> UserVerificationDetailsViewModel {
        let type = AppData.shared.selectedKycDocType ?? .passport
        let qvm = QuestionViewModel()
        var name = ""
        if qvm.fieldValue(.lastname) != ""{
            name = "\(qvm.fieldValue(.firstname)) \(qvm.fieldValue(.lastname)) \(qvm.fieldValue(.surname))"
        }else{
            name = "\(qvm.fieldValue(.firstname)) \(qvm.fieldValue(.surname))"
        }
        let dob = qvm.fieldValue(.dateOfBirth)
        
        let address = "\(qvm.fieldValue(.kycResidentialUnitNumber)) \(qvm.fieldValue(.kycResidentialStreetNumber)) \(qvm.fieldValue(.kycResidentialStreetName)), \(qvm.fieldValue(.kycResidentialSuburb)), \(qvm.fieldValue(.kycResidentialState)), Australia"
        
        let docInfo: DocInfo
        switch type {
        case .driversLicense:
            docInfo = DocInfo(type: type,
                              number: qvm.fieldValue(.driverLicenceNumber),
                              state: qvm.fieldValue(.driverLicenceState))
        case .passport:
            docInfo = DocInfo(type: type,
                              number: qvm.fieldValue(.passportNumber),
                              state: nil)
        case .medicareCard:
            docInfo = DocInfo(type: type,
                              number: qvm.fieldValue(.medicareNumber),
                              state: nil)
        }
        return UserVerificationDetailsViewModel(name: name,
                                                dob: dob,
                                                address: address,
                                                docInfo: docInfo)
    }
}
