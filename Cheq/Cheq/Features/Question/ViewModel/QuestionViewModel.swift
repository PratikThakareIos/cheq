//
//  QuestionViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 16/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

// question screens
enum QuestionType: String {
    case legalName = "legalName"
    case dateOfBirth = "dateOfBirth"
    case contactDetails = "contactDetails"
    case residentialAddress = "residentialAddress"
    case maritalStatus = "maritalStatus"
    case companyName = "companyName"
    case companyAddress = "companyAddress"
    case bankAccount = "bankAccount"
    case verifyName = "verifyName"
    
    case driverLicenseState
    case driverLicense
    case driverLicenseName

    case passport
    case passportName

    case medicare
    case medicareName
    
    case frankieKycAddress
    case frankieKycAddressConfirm

}

enum QuestionField: String {

    // about me
    case firstname = "firstname"
    case lastname = "lastname"
    case fullLegalName = "fullLegalName"
    case dateOfBirth = "dateOfBirth"
    case contactDetails = "mobile"
    case residentialAddress = "residentialAddress"
    case residentialPostcode = "residentialPostcode"
    case residentialSuburb = "residentialSuburb"
    case residentialState = "residentialState"
    case residentialCountry = "residentialCountry"
    case unitNumber = "unitNo"
    //case homeAddress = "homeAddress"

    // kyc
    case kycDocSelect = "KycDocSelect"
    
    //age range
    case ageRange = "ageRange"
    // about me - marital status
    case maritalStatus = "maritalStatus"
    case dependents = "dependents"
    
    // employment details
    case employerName = "employerName"
    case employerType = "employerType"
    case employerAddress = "employerAddress"
    case employerPostcode = "employerPostcode"
    case employerState = "employerState"
    case employerCountry = "employerCountry"

    // bank details
    case bankName = "bankName"
    case accountName = "accountName"
    case bankBSB = "bankBSB"
    case bankAccNo = "bankAccNo"
    case bankIsJoint = "isJointAccount"
    
    case driverLicenceState

    case kycResidentialUnitNumber
    case kycResidentialStreetNumber

    case kycResidentialPostcode
    case kycResidentialSuburb
    case kycResidentialState
    case kycResidentialStreetName
    case kycResidentialStreetType
    case kycResidentialCountry

}

class QuestionViewModel: BaseViewModel {

    var coordinator: QuestionCoordinatorProtocol = LegalNameCoordinator()
    var savedAnswer: [String: String] = [:]
    
    override init() {
        super.init()
        self.loadSaved()
    }
    
    func viewModelKey()-> String {
        return "questionViewModel"
    }
    
    func question()-> String {
       return coordinator.question
    }
    
    func numOfTextFields()->Int {
        return coordinator.numOfTextFields
    }

    func numOfCheckbox()->Int {
        return coordinator.numOfCheckBox
    }
    
    func numOfImageContainer()->Int {
        return coordinator.numOfImageContainer
    }
    
    func placeHolder(_ index: Int)->String {
        return coordinator.placeHolder(index)
    }

    func isEditable(at index: Int) -> Bool {
        return coordinator.isEditable(at: index)
    }

    func save(_ key: String, value: String) {
        if self.savedAnswer.count == 0 { loadSaved() }
        savedAnswer[key] = value
        self.save()
    }
    
    func save() {
        UserDefaults.standard.set(savedAnswer, forKey: self.viewModelKey())
        UserDefaults.standard.synchronize()
    }
    
    func loadSaved() {
        self.savedAnswer = UserDefaults.standard.value(forKey: self.viewModelKey()) as? [String : String] ?? [:]
        
        #if DEMO
        self.savedAnswer[QuestionField.firstname.rawValue] = "John"
        self.savedAnswer[QuestionField.lastname.rawValue] = "Smith"
        self.savedAnswer[QuestionField.contactDetails.rawValue] = "0411223344"
        let email = CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue)
        if email.isEmpty {
            let _ = CKeychain.shared.setValue(CKey.loggedInEmail.rawValue, value: "john.smith@cheq.com.au")
        }
        #endif
    }
    
    func clearAllSavedData(){
        UserDefaults.standard.set([:], forKey: self.viewModelKey())
    }
    
    func fieldValue(_ questionField: QuestionField)-> String {
        if (self.savedAnswer.count == 0) { loadSaved() }
        return self.savedAnswer[questionField.rawValue] ?? ""
    }
}

extension QuestionViewModel {
    
    func putUserDetailsRequest()-> PutUserDetailRequest {
        self.loadSaved()
        let putUserDetailsReq = PutUserDetailRequest(firstName: self.fieldValue(.firstname), lastName: self.fieldValue(.lastname), mobile: self.fieldValue(.contactDetails))
        return putUserDetailsReq
    }
    
    func dateOfBirth()->Date {
        let dob = Date(dateString:TestUtil.shared.dobFormatStyle(), format: self.fieldValue(.dateOfBirth))
        return dob
    }

//    func ageRange()-> PutUserDetailRequest.AgeRange {
//        return convertAgeRange(self.fieldValue(.ageRange))
//    }
//
//    func convertAgeRange(_ ageRange: String)-> PutUserDetailRequest.AgeRange {
//        return AgeRangeCoordinator.ageRangeToPutUserDetailsReqAgeRange(ageRange)
//    }
    
    func numOfDependent()->String {
        return self.fieldValue(.dependents)
    }

    func maritalStatus()-> MaritalStatus {
        let value = self.fieldValue(.maritalStatus)
        if value == MaritalStatus.single.rawValue {
            return .single
        } else {
            return .couple
        }
    }
    
}

extension QuestionViewModel {
    static func coordinatorFor (_ questionType: QuestionType)-> QuestionCoordinatorProtocol {
        var coordinator: QuestionCoordinatorProtocol = LegalNameCoordinator()
        switch questionType {
        case .legalName:
            coordinator = LegalNameCoordinator()
        case .dateOfBirth:
            coordinator = DateOfBirthCoordinator()
        case .contactDetails:
            coordinator = MobileNumberCoordinator()
        case .residentialAddress:
            coordinator = ResidentialAddressCoordinator()
        case .companyName:
            coordinator = CompanyNameCoordinator()
        case .companyAddress:
            coordinator = CompanyAddressCoordinator()
        case .maritalStatus:
            coordinator = MaritalStatusCoordinator()
        case .bankAccount:
            coordinator = BankAccountCoordinator()
        case .verifyName:
            coordinator = VerifyNameCoordinator()
        case .driverLicenseState:
            coordinator = DriverLicenceStateCoordinator()
        case .driverLicense:
            coordinator = DriverLicenceCoordinator()
        case .driverLicenseName:
            coordinator = DriverLicenceNameCoordinator()
        case .passport:
            coordinator = PassportCoordinator()
        case .passportName:
            coordinator = PassportNameCoordinator()
        case .medicare:
            coordinator = MedicareCoordinator()
        case .medicareName:
            coordinator = MedicareNameCoordinator()
        case .frankieKycAddress:
            coordinator = FrankieKycAddressCoordinator()
        case .frankieKycAddressConfirm:
            coordinator = FrankieKycAddressConfirmCoordinator()
        }
        return coordinator
    }
}
