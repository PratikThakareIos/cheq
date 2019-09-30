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
}

enum QuestionField: String {

    // about me
    case firstname = "firstname"
    case lastname = "lastname"
    case dateOfBirth = "dateOfBirth"
    case contactDetails = "mobile"
    case residentialAddress = "residentialAddress"
    case residentialPostcode = "residentialPostcode"
    case residentialState = "residentialState"
    case residentialCountry = "residentialCountry"
    
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
    case employerLatitude = "employerLatitude"
    case employerLongitude = "employerLongitude"
}

class QuestionViewModel: BaseViewModel {

    var sectionTitle = "About me"
    var type: QuestionType = .legalName
    var savedAnswer: [String: String] = [:]
    
    override init() {
        super.init()
        self.loadSaved()
    }
    
    func viewModelKey()-> String {
        return "questionViewModel"
    }
    
    func question()-> String {
        switch(type) {
        case .legalName:
            return "Enter your legal name as it appears on your ID"
        case .dateOfBirth:
            return "What is your date of birth?"
        case .contactDetails:
            return "What is your contact details?"
        case .residentialAddress:
            return "What is your residential address?"
        case .companyName:
            return "What is your employer's company name?"
        case .companyAddress:
            return "What is your employer's address"
        case .maritalStatus:
            return "What is your living status?"
        }
    }
    
    func numOfTextFields()->Int {
        switch(type) {
        case .legalName, .maritalStatus:
            return 2
        case .dateOfBirth, .contactDetails, .residentialAddress, .companyAddress, .companyName:
            return 1
        }
    }
    
    func placeHolder(_ index: Int)->String {
        switch(type) {
        case .legalName:
            let result = (index == 0) ? "First name" : "Last name"
            return result 
        case .dateOfBirth:
            return "Date of birth"
        case .contactDetails:
            return "0410 000 000"
        case .residentialAddress, .companyAddress:
            return "123 Example Street"
        case .companyName:
            return "Company name"
        case .maritalStatus:
            let result = (index == 0) ? "Status" : "Number of dependents"
            return result 
        }
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
    }
    
    func fieldValue(_ questionField: QuestionField)-> String {
        if (self.savedAnswer.count == 0) { loadSaved() }
        return self.savedAnswer[questionField.rawValue] ?? ""
    }
}

extension QuestionViewModel {
    func putUserDetailsRequest()-> PutUserDetailRequest {
        self.loadSaved()
        let putUserDetailsReq = PutUserDetailRequest(firstName: self.fieldValue(.firstname), lastName: self.fieldValue(.lastname), ageRange: self.ageRange(), mobile: self.fieldValue(.contactDetails), maritalStatus: self.maritalStatus(), numberOfDependents: self.numOfDependent(), state: self.residentialState())
        return putUserDetailsReq
    }
    
    func dateOfBirth()->Date {
        let dob = Date(dateString:DataHelperUtil.shared.dobFormatStyle(), format: self.fieldValue(.dateOfBirth))
        return dob
    }

    func ageRange()-> PutUserDetailRequest.AgeRange {
        return convertAgeRange(self.fieldValue(.ageRange))
    }
    
    func convertAgeRange(_ ageRange: String)-> PutUserDetailRequest.AgeRange {
        return AgeRangeCoordinator.ageRangeToPutUserDetailsReqAgeRange(ageRange)
    }
    
    func numOfDependent()->String {
        return self.fieldValue(.dependents)
    }

    func maritalStatus()-> PutUserDetailRequest.MaritalStatus {
        let value = self.fieldValue(.maritalStatus)
        if value == PutUserDetailRequest.MaritalStatus.single.rawValue {
            return .single
        } else {
            return .couple
        }
    }

    func residentialState()-> PutUserDetailRequest.State {
        let state = self.fieldValue(.residentialState)
        let localEnum = cState(fromRawValue: state)
        return StateCoordinator.convertCStateToState(localEnum)
    }
}
