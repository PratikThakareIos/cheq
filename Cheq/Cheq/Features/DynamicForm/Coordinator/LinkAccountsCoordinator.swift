//
//  LinkAccountsViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
//import MobileSDK
import Alamofire

class LinkAccountsCoordinator: DynamicFormViewModelCoordinator {
    

    var sectionTitle = "Connect your bank"
    var viewTitle = "Enter your bank account credentials"
    var appTokenResponse : GetAppTokenResponse?
    var jobId = ""
    
    func loadForm() -> Promise<[DynamicFormInput]> {
       
        return Promise<[DynamicFormInput]> () { resolver in
            
            guard AppData.shared.financialInstitutions.count > 0 else { resolver.reject(MoneySoftManagerError.unableToRetrieveFinancialInstitutions); return }
            
            guard let selectedFinancialInstitution = AppData.shared.selectedFinancialInstitution else { resolver.reject(ValidationError.unableToMapSelectedBank); return }
                        
                  // login again in case we have timed out issue
                  AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                      
                      var inputs = [DynamicFormInput]()
                      
                      if let loginIdCaption =  selectedFinancialInstitution.loginIdCaption {
                          let dynamicInputType = DynamicFormInput(type: .text, title: loginIdCaption, value: "")
                          inputs.append(dynamicInputType)
                      }
                      
                      if let passwordCaption =  selectedFinancialInstitution.passwordCaption {
                          let dynamicInputType = DynamicFormInput(type: .password, title: passwordCaption, value: "")
                          inputs.append(dynamicInputType)
                      }
                      
                      if let securityCodeCaption =  selectedFinancialInstitution.securityCodeCaption {
                          let dynamicInputType = DynamicFormInput(type: .password, title: securityCodeCaption, value: "")
                          inputs.append(dynamicInputType)
                      }
                      
                      if let secondaryLoginIdCaption =  selectedFinancialInstitution.secondaryLoginIdCaption {
                          let dynamicInputType = DynamicFormInput(type: .text, title: secondaryLoginIdCaption, value: "")
                          inputs.append(dynamicInputType)
                      }
                      
                      let spacer1 = DynamicFormInput(type: .spacer, title: "", value: "")
                      inputs.append(spacer1)
        
                      let confirmButton = DynamicFormInput(type: .confirmButton, title: "Connect securely", value: "")
                      inputs.append(confirmButton)
                      
                      let spacer = DynamicFormInput(type: .spacer, title: "", value: "")
                      inputs.append(spacer)
                      
                      resolver.fulfill(inputs)
                  }.catch { err in
                      resolver.reject(err)
                  }

            
//            // login again in case we have timed out issue
//            AuthConfig.shared.activeManager.getCurrentUser().then { authUser -> Promise<GetAppTokenResponse> in
//                return  CheqAPIManager.shared.getBasiqConnectionTokenForBankLogin() // call on login button click
//            }.done { appTokenResponse in
               
//                LoggingUtil.shared.cPrint("appTokenResponse = \(appTokenResponse)")
//                self.appTokenResponse = appTokenResponse
//
//                var inputs = [DynamicFormInput]()
//
//                if let loginIdCaption =  selectedFinancialInstitution.loginIdCaption {
//                    let dynamicInputType = DynamicFormInput(type: .text, title: loginIdCaption, value: "")
//                    inputs.append(dynamicInputType)
//                }
//
//                if let passwordCaption =  selectedFinancialInstitution.passwordCaption {
//                    let dynamicInputType = DynamicFormInput(type: .password, title: passwordCaption, value: "")
//                    inputs.append(dynamicInputType)
//                }
//
//                if let securityCodeCaption =  selectedFinancialInstitution.securityCodeCaption {
//                    let dynamicInputType = DynamicFormInput(type: .password, title: securityCodeCaption, value: "")
//                    inputs.append(dynamicInputType)
//                }
//
//                if let secondaryLoginIdCaption =  selectedFinancialInstitution.secondaryLoginIdCaption {
//                    let dynamicInputType = DynamicFormInput(type: .text, title: secondaryLoginIdCaption, value: "")
//                    inputs.append(dynamicInputType)
//                }
//
//                let spacer1 = DynamicFormInput(type: .spacer, title: "", value: "")
//                inputs.append(spacer1)
//
//                let confirmButton = DynamicFormInput(type: .confirmButton, title: "Connect securely", value: "")
//                inputs.append(confirmButton)
//
//                let spacer = DynamicFormInput(type: .spacer, title: "", value: "")
//                inputs.append(spacer)
//
//                resolver.fulfill(inputs)
//            }.catch { err in
//                resolver.reject(err)
//            }
            
            
        }
    }
  
    func submitFormWith(loginId : String?, password : String?, securityCode : String?, secondaryLoginId : String?)->Promise<Bool> {

        var dict : [String:Any] = [:]

        if let loginId = loginId {
             dict["loginId"] = loginId
        }
        if let password = password {
            dict["password"] = password
        }
        if let securityCode = securityCode {
            dict["securityCode"] = securityCode
        }
        if let secondaryLoginId = secondaryLoginId {
            dict["secondaryLoginId"] = secondaryLoginId
        }
        if let institutionID = AppData.shared.selectedFinancialInstitution?._id {
           dict["institution"] = ["id":institutionID]
        }
        
        LoggingUtil.shared.cPrint("\n\n >> submitFormWith dict = \(dict)")
        var activeAuthUser: AuthUser?
        
        return Promise<Bool>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().then { authUser -> Promise<GetAppTokenResponse> in
                activeAuthUser = authUser
                return  CheqAPIManager.shared.getBasiqConnectionTokenForBankLogin() // call on login button click
            }.then { appTokenResponse -> Promise<[String:Any]> in
                
                LoggingUtil.shared.cPrint("appTokenResponse = \(appTokenResponse)")
                self.appTokenResponse = appTokenResponse
                let strMessage = "bankLogin - start calling basiq createconnection - \(Date().timeStamp())"
                let strEvent = "CreateBasiqConnection"
                let log = PostLogRequest(deviceId: UUID().uuidString, type: .info, message: strMessage, event: strEvent, bankName: "")
                LoggingUtil.shared.addLog(log: log)
                                
                let url = URL.init(string: self.appTokenResponse?.apiConnectionUrl ?? "")
                let headers = [ "Content-Type" : "application/json", "Authorization": "Bearer \(self.appTokenResponse?.accessToken ?? "")"]
                return self.callAPI(url: url!, param: dict, headers: headers)
            }.then{ dict -> Promise<BasiqConnectionResponse> in
                
                let basiqConnectionResponse = try! DictionaryDecoder().decode(BasiqConnectionResponse.self, from: dict)
                return Promise<BasiqConnectionResponse>() { res in
                     res.fulfill(basiqConnectionResponse)
                }
            
            }.then{ basiqConnectionResponse -> Promise<Bool> in
                LoggingUtil.shared.cPrint("basiqConnectionResponse = \(basiqConnectionResponse)")
                                
                 let strMessage = "bankLogin - End calling basiq createconnection - jobId \( basiqConnectionResponse.id) - \(Date().timeStamp())"
                 let strEvent = "CreateBasiqConnection"
                 let log = PostLogRequest(deviceId: UUID().uuidString, type: .info, message: strMessage, event: strEvent, bankName: "")
                 LoggingUtil.shared.addLog(log: log)

                self.jobId = basiqConnectionResponse.id ?? ""
                AppData.shared.bankJobId = basiqConnectionResponse.id ?? ""                
                let request = PostConnectionJobRequest.init(jobId: self.jobId, institutionId: AppData.shared.selectedFinancialInstitution?._id ?? "" )
                return CheqAPIManager.shared.postBasiqConnectionJob(req:request)
            }.then{ boolValue -> Promise<AuthUser> in
                return AuthConfig.shared.activeManager.retrieveAuthToken(activeAuthUser!)
            }.then { authUser in
               return AuthConfig.shared.activeManager.setUser(authUser)
            }.done { authUser  in
                LoggingUtil.shared.cPrint("submitFormWith Completed")
                resolver.fulfill(true)
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    
    
//GetConnectionJobResponse
//    {
//      "institutionId": "string",
//      "step": "VerifyingCredentials",
//      "stepStatus": "Pending",
//      "error": "InvalidCredentials",
//      "errorTitle": "string",
//      "errorDetail": "string",
//      "showClose": true,
//      "showReconnect": true,
//      "showChatWithUs": true,
//      "actionRequiredGuidelines": [
//        "string"
//      ]
//    }
    
    func checkConnectionJobStatus() -> Promise<GetConnectionJobResponse> {
        return Promise<GetConnectionJobResponse>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().then { authUser -> Promise<GetConnectionJobResponse> in
                
                let strMessage = "bankLogin - start calling BasiqConnectionJobStatus - jobId \(self.jobId) - \(Date().timeStamp())"
                let strEvent = "BasiqConnectionJobStatus"
                let log = PostLogRequest(deviceId: UUID().uuidString, type: .info, message: strMessage, event: strEvent, bankName: "")
                LoggingUtil.shared.addLog(log: log)

                return  CheqAPIManager.shared.getBasiqConnectionJobStatus(jobId: self.jobId)
            }.done { getConnectionJobResponse  in
                LoggingUtil.shared.cPrint("getConnectionJobResponse = \(getConnectionJobResponse)")
                
               
                let strMessage = "bankLogin - End calling BasiqConnectionJobStatus - jobId \(self.jobId) - step \(getConnectionJobResponse.step) stepStatus \(getConnectionJobResponse.stepStatus) \(Date().timeStamp())"
                let strEvent = "BasiqConnectionJobStatus"
                let log = PostLogRequest(deviceId: UUID().uuidString, type: .info, message: strMessage, event: strEvent, bankName: "")
                LoggingUtil.shared.addLog(log: log)

                                
                resolver.fulfill(getConnectionJobResponse)
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    func nextViewController(){
        var vcInfo = [String: String]()
        vcInfo[NotificationUserInfoKey.storyboardName.rawValue] = StoryboardName.main.rawValue
        vcInfo[NotificationUserInfoKey.storyboardId.rawValue] = MainStoryboardId.tab.rawValue
        NotificationUtil.shared.notify(UINotificationEvent.switchRoot.rawValue, key: NotificationUserInfoKey.vcInfo.rawValue, object: vcInfo)
    }

    
    func callAPI(url:URL, param : [String: Any], headers : [String :Any]?) -> Promise<[String: Any]> {
         
        return Promise<[String: Any]>() { resolver in
            Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers : headers as? HTTPHeaders)
                .validate()
                .responseJSON { response in
    
                    switch response.result {
                    case .success(let json):
                        guard let dictionary = json as? [String: Any] else {
                            //resolver.reject(ActivityError.malformed("not a dictionary"))
                            return
                        }
                        print(dictionary)
                        resolver.fulfill(dictionary)
                    case .failure(let error):
                        resolver.reject(error)
                    }
            }
        }
    }
}

extension LinkAccountsCoordinator {
        
    func submitForm()->Promise<Bool> {
//        if AppData.shared.migratingToNewDevice == true {
//            return self.submitFormForMigration()
//        } else {
//            return self.submitFormForOnboarding()
//        }
        
        return Promise<Bool>() { resolver in
            resolver.fulfill(true)
        }
    }
}


