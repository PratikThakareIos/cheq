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
    
    // kyc verification
    case kycSelectDoc = "kycSelectDoc"
    
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
    
    // lending
    case lending = "Lending"
    
    // spending
    case spending = "Overview"
    case spendingCategories = "Money Spent"
    case spendingCategoryById = "Spending Category"
    case spendingTransactions = "All Transactions"
    
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
    private init() { let _ = loadOnfidoSDKToken() }

    // instance of current application
    var application: UIApplication?
    
    // remote config parameter cache time
    var expirationDuration = TimeInterval(3600)
    
    // amount selected from loan setting
    var amountSelected = "0"
    var loanFee = 0.0
    var acceptedAgreement: Bool = false 
    
    // forgot password email
    var forgotPasswordEmail = ""
    
    // Intercom
    let intercomAPIKey = "ios_sdk-5cf54594065095344f1653739fcbe6b5eac1758f"
    let intercomAppId = "i8127kii"
    
    // Facebook
    let fbAppId = "2855589534666837"
    let fbAppSecret = "cbe55b8da36d66d01237a9fa1ed276c5"

    // Bluedot API Key
//    var blueDotApiToken: String =  "7b9b43d0-d39d-11e9-82e5-0ad12f17ff82"

    // KYC 
    var onfidoSdkToken: String = ""
    
    // lending description from backend
    var declineDescription: String = ""
    
    var progress = CProgress()

    // moneySoft related data
    var storedAccounts: [FinancialAccountModel] = []
    var financialTransactions: [FinancialTransactionModel] = [] 
    let financialInstitutionsUnused = -1
    var financialInstitutions: [FinancialInstitutionModel] = []
    var selectedFinancialInstitution: FinancialInstitutionModel?
    
    // bank logo mapping from remote config
    var remoteBankMapping = [String: RemoteBank]()
    
    // use for keeping the provider institution id to map which bank user selected
    var existingProviderInstitutionId: String = ""
    var existingFinancialInstitutionId: Int  = -1
    var disabledAccount: FinancialAccountModel! 
    
    
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
    var selectedEmployerAddressString: String = ""
    
    // spending scenarios
    var selectedCategory: CategoryAmountStatResponse? = nil

    // lending scenarios
    var completingDetailsForLending = false
    
    // migration of accounts on new device scenario
    var migratingToNewDevice = false 
    
    // is onboarding
    var isOnboarding = false
    
    
    var completingOnDemandOther = false

    func saveOnfidoSDKToken(_ sdkToken: String) {
        self.onfidoSdkToken = sdkToken
        UserDefaults.standard.set(onfidoSdkToken, forKey: CKey.onfidoSdkToken.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func loadOnfidoSDKToken()->String {
        self.onfidoSdkToken =  UserDefaults.standard.string(forKey: CKey.onfidoSdkToken.rawValue) ?? ""
        return self.onfidoSdkToken
    }

    func updateProgressAfterCompleting(_ screenName: ScreenName) {
        switch screenName {
            
        // about me
        case .legalName:
            AppData.shared.progress = CProgress(aboutMe: 0.5, employmentDetails: 0.0, linkingBank: 0.0)
//        case .dateOfBirth, .ageRange:
//            AppData.shared.progress = CProgress(aboutMe: 0.5, employmentDetails: 0.0, linkingBank: 0.0)
        case .contactDetails:
            AppData.shared.progress = CProgress(aboutMe: 1.0, employmentDetails: 0.0, linkingBank: 0.0)
//        case .residentialAddress, .state:
//            AppData.shared.progress = CProgress(aboutMe: 1.0, employmentDetails: 0.0, linkingBank: 0.0)
//        case .maritalStatus:
//            AppData.shared.progress = CProgress(aboutMe: 1.0, employmentDetails: 0.0, linkingBank: 0.0)
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
