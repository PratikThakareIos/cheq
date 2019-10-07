//
//  AppData.swift
//  Cheq
//
//  Created by Xuwei Liang on 17/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import MobileSDK

// screen name, keep the string the same as the raw value of types creating it
enum ScreenName: String {
    
    // Splash
    case splash = "splash"
    
    // Registration
    case registration = "registration"
    case login = "login"
    
    // about me
    case legalName = "legalName"
    case ageRange = "Age Range"
    case dateOfBirth = "dateOfBirth"
    case contactDetails = "contactDetails"
    case residentialAddress = "residentialAddress"
    case state = "state"
    case maritalStatus = "maritalStatus"
    
    // employment details
    case employmentType = "Employment type"
    case onDemand = "On Demand"
    case companyName = "companyName"
    case companyAddress = "companyAddress"
    
    // bank details
    case financialInstitutions = "Financial Institutions"
    case bankLogin = "Link Accounts"
    case unknown = "unknown"
    
    // intro screens 
    case email = "Check your email"
    case employee = "Employee details"
    case setupBank = "Set up your bank"
    case enableLocation = "Enable location"
    case notification = "Notification"
    case verifyIdentity = "Verify your identity"
    
    init(fromRawValue: String) {
        self = ScreenName(rawValue: fromRawValue) ?? .legalName
    }
}

struct CProgress {
    var aboutMe: Float = 0.0
    var employmentDetails: Float = 0.0
    var linkingBank: Float = 0.0
}

// Singleton to keep track of data across the app
class AppData {
    
    static let shared = AppData()
    private init() { loadOnfidoSDKToken() }
    
    // last active
    var appLastActiveTimestamp = 100.years.earlier

    // instance of current application
    var application: UIApplication? 
    
    // Facebook
    let fbAppId = "2855589534666837"
    let fbAppSecret = "87b757a52a9b7db61fce607278c4aa2e"

    // Bluedot API Key
    var blueDotApiToken: String =  "7b9b43d0-d39d-11e9-82e5-0ad12f17ff82"

    // KYC 
    var onfidoSdkToken: String = "eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjoiZ3ZCWDVSWndxeEFSY2hmaHJPTnp0UTNBajFSaDk4eUV5VzJDQjZRSnZ5YlNrVjZEVTZ6MGEvYitEUUJFXG5vd2lYUnpKWkRlUDhFclgyOUw5R2RUZHA3a0locm81bWY1LzIrTWI4aEI3Ny9yND1cbiIsInV1aWQiOiJIbVFxNVpvWG1XRiIsImV4cCI6MTU2OTIyNzU2NywidXJscyI6eyJvbmZpZG9fYXBpX3VybCI6Imh0dHBzOi8vYXBpLm9uZmlkby5jb20iLCJ0ZWxlcGhvbnlfdXJsIjoiaHR0cHM6Ly90ZWxlcGhvbnkub25maWRvLmNvbSIsImRldGVjdF9kb2N1bWVudF91cmwiOiJodHRwczovL3Nkay5vbmZpZG8uY29tIiwic3luY191cmwiOiJodHRwczovL3N5bmMub25maWRvLmNvbSIsImhvc3RlZF9zZGtfdXJsIjoiaHR0cHM6Ly9pZC5vbmZpZG8uY29tIn19.PLm5Pj78H4WzYJAGDckJznaEsS9nW56Syvj7JTtx8Uk"
    
    var progress = CProgress()

    // moneySoft related data
    var storedAccounts: [FinancialAccountModel] = []
    var financialTransactions: [FinancialTransactionModel] = [] 
    let financialInstitutionsUnused = -1
    var financialInstitutions: [FinancialInstitutionModel] = []
    var selectedFinancialInstitution: FinancialInstitutionModel?
    
    var financialSignInForm: InstitutionCredentialsFormModel = InstitutionCredentialsFormModel(financialServiceId: -1, financialInstitutionId: -1, providerInstitutionId: "")

    // employment flow related data
    var employmentType: EmploymentType = .fulltime
    var onDemandType: OnDemandType = .other
    var employerList = [GetEmployerPlaceResponse]()
    var employerAddressList = [GetEmployerPlaceResponse]()
    var residentialAddressList = [GetAddressResponse]()
    var selectedEmployer: Int = 0
    var selectedEmployerAddress: Int = 0 
    var selectedResidentialAddress: Int = 0

    func saveOnfidoSDKToken(_ sdkToken: String) {
        self.onfidoSdkToken = sdkToken
        UserDefaults.standard.set(onfidoSdkToken, forKey: self.onfidoSdkKey())
        UserDefaults.standard.synchronize()
    }
    
    func loadOnfidoSDKToken() {
       self.onfidoSdkToken =  UserDefaults.standard.string(forKey:  self.onfidoSdkKey()) ?? ""
    }
    
    func onfidoSdkKey()->String {
        return "onfidoSdkToken"
    }
    
    func updateProgressAfterCompleting(_ screenName: ScreenName) {
        switch screenName {
        case .legalName:
            AppData.shared.progress = CProgress(aboutMe: 0.2, employmentDetails: 0.0, linkingBank: 0.0)
        case .dateOfBirth, .ageRange:
            AppData.shared.progress = CProgress(aboutMe: 0.4, employmentDetails: 0.0, linkingBank: 0.0)
        case .contactDetails:
            AppData.shared.progress = CProgress(aboutMe: 0.6, employmentDetails: 0.0, linkingBank: 0.0)
        case .residentialAddress, .state:
            AppData.shared.progress = CProgress(aboutMe: 0.8, employmentDetails: 0.0, linkingBank: 0.0)
        case .maritalStatus:
            AppData.shared.progress = CProgress(aboutMe: 1.0, employmentDetails: 0.0, linkingBank: 0.0)
        case .employmentType:
            AppData.shared.progress = CProgress(aboutMe: 1.0, employmentDetails: 0.25, linkingBank: 0.0)
        case .onDemand:
            AppData.shared.progress = CProgress(aboutMe: 1.0, employmentDetails: 0.5, linkingBank: 0.0)
        case .companyName:
            AppData.shared.progress = CProgress(aboutMe: 1.0, employmentDetails: 0.5, linkingBank: 0.0)
        case .companyAddress:
            AppData.shared.progress = CProgress(aboutMe: 1.0, employmentDetails: 1.0, linkingBank: 0.0)
            
        case .financialInstitutions:
            AppData.shared.progress = CProgress(aboutMe: 1.0, employmentDetails: 1.0, linkingBank: 0.5)
        case .bankLogin:
            AppData.shared.progress = CProgress(aboutMe: 1.0, employmentDetails: 1.0, linkingBank: 1.0)
        case .unknown:
            AppData.shared.progress = CProgress(aboutMe: 0.0, employmentDetails: 0.0, linkingBank: 0.0)
        default: break
        }
    }
}
