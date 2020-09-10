//
//  AppData.swift
//  Cheq
//
//  Created by Xuwei Liang on 17/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import OneSignal
//import MobileSDK

/**
ScreenName enum is where we keep for names of screen that we want to track. Update as we add more viewContollers. Do not hardcode anywhere else for screen names.
 */
enum ScreenName: String {
    
    /// Splash
    case splash = "splash"
    
    /// Registration
    case registration = "registration"
    case login = "login"
    
    /// about me
    case legalName = "legalName"
    case ageRange = "Age Range"
    case dateOfBirth = "dateOfBirth"
    case contactDetails = "contactDetails"
    case residentialAddress = "residentialAddress"
    case state = "state"
    case maritalStatus = "maritalStatus"
    
    /// kyc verification
    case kycSelectDoc = "kycSelectDoc"
    
    /// employment details
    case employmentType = "Employment type"
    case onDemand = "On Demand"
    case companyName = "companyName"
    case companyAddress = "companyAddress"
    
    /// bank details
    case financialInstitutions = "Financial Institutions"
    case bankLogin = "Link Accounts"
    case unknown = "unknown"
    
    /// intro screens
    case email = "Check your email"
    case employee = "Employee details"
    case setupBank = "Set up your bank"
    case enableLocation = "Enable location"
    case notification = "Notification"
    case verifyIdentity = "Verify your identity"
    
    /// lending
    case lending = "Lending"
    
    /// spending
    case spending = "Overview"
    case spendingCategories = "Money spent"
    case spendingCategoryById = "Spending category"
    case spendingTransactions = "Transactions"
    
    // account
    case accountInfo = "Account" 
    
    init(fromRawValue: String) {
        self = ScreenName(rawValue: fromRawValue) ?? .legalName
    }
}

/// Onboarding flow has a progress bar on navigation bar which is made up of 3 navigation bars. CProgress drives the UI for it with 3 Float.
struct CProgress {
    var aboutMe: Float = 0.0
    var employmentDetails: Float = 0.0
    var linkingBank: Float = 0.0
}

/**
Singleton class for keeping track of data across the app so we avoid passing variables between viewModels or viewControllers. Instead, when we fetch certain data which we need to refer to later on, we keep it on **AppData** and then reference the values from **AppData** somewhere else.
*/
class AppData {
    
    /// Singleton instance
    static let shared = AppData()
    
    /// we call **loadOnfidoSDKToken** which loads up any existing onfido sdk token we fetched from previous API call.
    private init() { let _ = loadOnfidoSDKToken() }

    /// instance of current application
    var application: UIApplication?
    
    /// remote config parameter cache time
    var expirationDuration = TimeInterval(3600)
    
    /// spending overview status
    var spendingOverviewReady = false
    
    /// connection Job Status
    var connectionJobStatusReady = false

    /// amount selected from loan setting
    var amountSelected = "0"
    
    /// loan fee and accepted  agreement boolean, we use this when we want to finalise lending
    var loanFee = 0.0
    
    /// this toggle is used to track if agreement has been accepted 
    var acceptedAgreement: Bool = false 
    
    /// forgot password email
    var forgotPasswordEmail = ""
    
    /// Intercom SDK config variables
    let intercomAPIKey = "ios_sdk-5cf54594065095344f1653739fcbe6b5eac1758f"
    let intercomAppId = "i8127kii"
    
    /// Facebook SDK config variables
    let fbAppId = "2855589534666837"
    let fbAppSecret = "cbe55b8da36d66d01237a9fa1ed276c5"

    /// Onfido SDK config variables
    var onfidoSdkToken: String = ""
    
    /// lending description from backend
    var declineDescription: String = ""
    
    /// Instance of CProgress which we globally reference and update. This is useful for our onboarding.
    var progress = CProgress()

    /// Variable to keep track of linked account fetched from MoneySoft SDK.
    //var storedAccounts: [FinancialAccountModel] = []
    
    /// Variable to keep track of transactions fetched from MoneySoft SDK.
    //var financialTransactions: [FinancialTransactionModel] = []
    
    /// Placeholder value for financialInstitutionsId
    let financialInstitutionsUnused = -1
    
    /// **financialInstitutions** is the list we fetched from "/v1/Finances/institutions".
    var financialInstitutions: [GetFinancialInstitution] = []
    
    var resGetFinancialInstitutionResponse: GetFinancialInstitutionResponse?
    
    /// Keep track of the selected institution
    var selectedFinancialInstitution: GetFinancialInstitution?
    
    
    var bankJobId :String?
    
    /// financial login form from MoneySoft SDK
    //var financialSignInForm: InstitutionCredentialsFormModel = InstitutionCredentialsFormModel(financialServiceId: -1, financialInstitutionId: -1, providerInstitutionId: "")
    
    /// use for keeping track of the provider institution id to map which bank user selected
    var existingProviderInstitutionId: String = ""
    
    /// use for keeping track of the financial institution id to map which bank user selected
    var existingFinancialInstitutionId: Int  = -1
    
    /// disabledAccount is used when we check if we need to migrate MoneySoft linked account instead of onboarding
    //var disabledAccount: FinancialAccountModel!
    
    /// bank logo mapping from remote config
    var remoteBankMapping = [String: RemoteBank]()
    
    var remote_appVersionNumberIos: String = ""
    var remote_forceAppVersionUpgradeIos : Bool = false
    var remote_isUnderMaintenance : Bool = false


    
    /// Employment flow related data
    var employmentType: EmploymentType = .fulltime
    
    /// if employment type is **On Demand**, we use this variable to keep track of the selected value
    var onDemandType: OnDemandType = .other
    
    /// employer list fetched from company name lookup
    var employerList = [GetAddressResponse]()
    
    // employee overview details fetched from /v1/Lending/overview
    var employeeOverview : GetLendingOverviewResponse?
    
    // employee timesheet details fetched from /v1/Lending/salarytransactions/recent
    var employeePaycycle : [SalaryTransactionResponse] = [SalaryTransactionResponse]()
   
    /// employer list fetched from company address lookup
    var employerAddressList = [GetAddressResponse]()

    /// residential address list fetched from home address lookup
    var residentialAddressList = [GetAddressResponse]()

    /// kyc address list fetched from home address lookup
    var kycAddressList = [GetAddressResponse]()

    /// selected employer index from **employerList**
    var selectedEmployer: Int = 0
    
    /// selected employer address index from **employerAddressList**
    var selectedEmployerAddress: Int = 0
    
    
    /// seleced home address index from **residentialAddressList**
    var selectedResidentialAddress: Int = 0

    /// seleced address index from **kycAddressList**
    var selectedKYCAddress: Int = 0

    /// selected employer address from **employerAddressList**
    var selectedEmployerAddressString: String = ""
    
    /// Selected category, we track this in SpendingViewController's interactions
    var selectedCategory: CategoryAmountStatResponse? = nil

    /// When we are in LendingViewController, if we launch other onboarding screens, like Employment details, we use this variable to indicate that we are showing it for lending flow instead of onboarding flow
    var completingDetailsForLending = false

    /// Selected KYC verification document type, used to adjust verification questions and result
    var selectedKycDocType: KycDocType?

    /// If we are doing migration of MoneySoft accounts on new device, we set this boolean as true
    var migratingToNewDevice = false 
    
    /// Boolean to indicate app is performing onboarding flow
    var isOnboarding = false
    
    /// When a person fills in employment type as **On Demand** and is **Other**, then we set this flag to true, so our flow knows that we need to further ask for company name by showing company name screen
    var completingOnDemandOther = false

    
    /// Wrapper method to save Onfido SDK Token. Notice that we are using **CKey** to look up the key we want to store against rather than hardcoding the String value.
    func saveOnfidoSDKToken(_ sdkToken: String) {
        self.onfidoSdkToken = sdkToken
        UserDefaults.standard.set(onfidoSdkToken, forKey: CKey.onfidoSdkToken.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    /// Wrapper method to load Onfido SDK Token. Once again, we use reference of key name from **CKey**. Even though we are loading from **UserDefaults** and not keychain.
    func loadOnfidoSDKToken()->String {
        self.onfidoSdkToken =  UserDefaults.standard.string(forKey: CKey.onfidoSdkToken.rawValue) ?? ""
        return self.onfidoSdkToken
    }

    /**
     Given a screen name, we define the progress of our global progress bar on the navigation bar
     
     - Parameter screenName: the screen name of current view controller.
     */
    func updateProgressAfterCompleting(_ screenName: ScreenName) {
        switch screenName {
            
        /// update progress bar on the 1st section to 50% after **legalName** screen
        case .legalName:
            AppData.shared.progress = CProgress(aboutMe: 0.5, employmentDetails: 0.0, linkingBank: 0.0)
        /// progress 1st section to 100% after **contactDetails** screen
        case .contactDetails:
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
            
        ///
        case .unknown:
            AppData.shared.progress = CProgress(aboutMe: 0.0, employmentDetails: 0.0, linkingBank: 0.0)
            
        /// by default, if we don't include the screen name where we want to update **AppData.shared.progress**, we don't do any updates.
        default: break
        }
    }
    
    
    func resetAllData(){
        
         /// spending overview status
          spendingOverviewReady = false
         
         /// connection Job Status
          connectionJobStatusReady = false

         /// amount selected from loan setting
          amountSelected = "0"
         
         /// loan fee and accepted  agreement boolean, we use this when we want to finalise lending
          loanFee = 0.0
         
         /// this toggle is used to track if agreement has been accepted
          acceptedAgreement = false
         
         /// forgot password email
          forgotPasswordEmail = ""
    
         /// lending description from backend
          declineDescription = ""
         
         /// Instance of CProgress which we globally reference and update. This is useful for our onboarding.
          progress = CProgress()

         /// Variable to keep track of linked account fetched from MoneySoft SDK.
          //storedAccounts = []
         
         /// Variable to keep track of transactions fetched from MoneySoft SDK.
          //financialTransactions = []
                  
         /// **financialInstitutions** is the list we fetched from "/v1/Finances/institutions".
          financialInstitutions = []
         
          resGetFinancialInstitutionResponse = nil
         
         /// Keep track of the selected institution
          selectedFinancialInstitution = nil
         
          bankJobId = nil
         
         /// financial login form from MoneySoft SDK
          //financialSignInForm = InstitutionCredentialsFormModel(financialServiceId: -1, financialInstitutionId: -1, providerInstitutionId: "")
         
         /// use for keeping track of the provider institution id to map which bank user selected
          existingProviderInstitutionId = ""
         
         /// use for keeping track of the financial institution id to map which bank user selected
          existingFinancialInstitutionId  = -1

         /// bank logo mapping from remote config
          remoteBankMapping = [String: RemoteBank]()
         
         /// Employment flow related data
          employmentType = .fulltime
         
         /// if employment type is **On Demand**, we use this variable to keep track of the selected value
          onDemandType = .other
         
         /// employer list fetched from company name lookup
          employerList = [GetAddressResponse]()
         
         // employee overview details fetched from /v1/Lending/overview
          employeeOverview  = nil
         
         // employee timesheet details fetched from /v1/Lending/salarytransactions/recent
          employeePaycycle = [SalaryTransactionResponse]()
        
         /// employer list fetched from company address lookup
          employerAddressList = [GetAddressResponse]()
         
         /// residential address list fetched from home address lookup
          residentialAddressList = [GetAddressResponse]()
         
         /// selected employer index from **employerList**
          selectedEmployer = 0
         
         /// selected employer address index from **employerAddressList**
          selectedEmployerAddress = 0
         
         /// seleced home address index from **residentialAddressList**
          selectedResidentialAddress = 0
         
         /// selected employer address from **employerAddressList**
          selectedEmployerAddressString = ""
         
         /// Selected category, we track this in SpendingViewController's interactions
          selectedCategory = nil

         /// When we are in LendingViewController, if we launch other onboarding screens, like Employment details, we use this variable to indicate that we are showing it for lending flow instead of onboarding flow
          completingDetailsForLending = false
         
         /// If we are doing migration of MoneySoft accounts on new device, we set this boolean as true
          migratingToNewDevice = false
         
         /// Boolean to indicate app is performing onboarding flow
          isOnboarding = false
         
         /// When a person fills in employment type as **On Demand** and is **Other**, then we set this flag to true, so our flow knows that we need to further ask for company name by showing company name screen
          completingOnDemandOther = false
    }
    
    /*
      If your system assigns unique identifiers to users, it can be to have to also remember their OneSignal Player Id's as well. To make things easier, OneSignal now allows you to set an external_user_id for your users. Simply call this method, pass in your custom user Id (as a string), and from now on when you send a push notification, you can use include_external_user_ids instead of include_player_ids.
    */
    func oneSignal_setExternalUserId(externalUserId : String){
        
        //let externalUserId = "123456789" // You will supply the external user id to the OneSignal SDK

        // Setting External User Id with Callback Available in SDK Version 2.13.1+
        OneSignal.setExternalUserId(externalUserId, withCompletion: { results in
          // The results will contain push and email success statuses
           LoggingUtil.shared.cPrint("External user id update complete with results: ", results!.description)
          // Push can be expected in almost every situation with a success status, but
          // as a pre-caution its good to verify it exists
          if let pushResults = results!["push"] {
             LoggingUtil.shared.cPrint("Set external user id push status: ", pushResults)
          }
          if let emailResults = results!["email"] {
               LoggingUtil.shared.cPrint("Set external user id email status: ", emailResults)
          }
        })

        //Available in SDK Version 2.13.0-
        //OneSignal.setExternalUserId(myCustomUniqueUserId)
    }
    
    func oneSignal_removeExternalUserId(){
        
        // Removing External User Id with Callback Available in SDK Version 2.13.1+
        OneSignal.removeExternalUserId({ results in
            // The results will contain push and email success statuses
             LoggingUtil.shared.cPrint("External user id update complete with results: ", results!.description)
            // Push can be expected in almost every situation with a success status, but
            // as a pre-caution its good to verify it exists
            if let pushResults = results!["push"] {
                 LoggingUtil.shared.cPrint("Remove external user id push status: ", pushResults)
            }
            // Verify the email is set or check that the results have an email success status
            if let emailResults = results!["email"] {
                 LoggingUtil.shared.cPrint("Remove external user id email status: ", emailResults)
            }
        })

        //Available in SDK Version 2.13.0-
        //OneSignal.removeExternalUserId()
    }
    
}
