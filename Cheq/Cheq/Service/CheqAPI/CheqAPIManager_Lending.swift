//
//  CheqAPIManager_Lending.swift
//  Cheq
//
//  Created by Xuwei Liang on 16/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire

//manish
//resolveNameConflict()


extension CheqAPIManager {
    
    func borrow()->Promise<Void> {
        return Promise<Void>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                let req = DataHelperUtil.shared.postLoanRequest() 
                LendingAPI.postBorrowWithRequestBuilder(request: req).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in
                    if let error = err {
                        LoggingUtil.shared.cPrint(error)
                        resolver.reject(CheqAPIManagerError_Lending.unableToProcessBorrow)
                        NotificationUtil.shared.notify(UINotificationEvent.swipeReset.rawValue, key: "", value: "")
                        return
                    }
                    
                    resolver.fulfill(())
                })
            }.catch { err in
                LoggingUtil.shared.cPrint(err)
                resolver.reject(CheqAPIManagerError_Lending.unableToProcessBorrow)
                NotificationUtil.shared.notify(UINotificationEvent.swipeReset.rawValue, key: "", value: "")
            }
        }
    }
    
    func loanPreview()->Promise<GetLendingPreviewResponse> {
        return Promise<GetLendingPreviewResponse>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                let borrowAmount = Int(AppData.shared.amountSelected) ?? 0
                LendingAPI.getBorrowPreviewWithRequestBuilder(amount: borrowAmount).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in
                    if let error = err {
                        LoggingUtil.shared.cPrint(error)
                        resolver.reject(CheqAPIManagerError_Lending.unableToRetrieveLoanPreview)
                        return
                    }
                    
                    guard let loanPreview = response?.body else { resolver.reject(CheqAPIManagerError_Lending.unableToRetrieveLoanPreview)
                        return
                    }
                    
                    resolver.fulfill(loanPreview)
                })
            }.catch { err in
                LoggingUtil.shared.cPrint(err)
                resolver.reject(CheqAPIManagerError_Lending.unableToRetrieveLoanPreview)
            }
        }
    }
    
    func lendingOverview()->Promise<GetLendingOverviewResponse> {
    
        return Promise<GetLendingOverviewResponse>() { resolver in
            #if DEMO
            let lendingOverview = TestUtil.shared.testLendingOverview()
            resolver.fulfill(lendingOverview)
            #else
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                LendingAPI.getLendingWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (lendingOverview, err) in
                    if let error = err {
                        LoggingUtil.shared.cPrint(error)
                        resolver.reject(CheqAPIManagerError_Lending.unableToRetrieveLendingOverview); return
                    }
                    guard let response = lendingOverview?.body else {
                        resolver.reject(CheqAPIManagerError_Lending.unableToRetrieveLendingOverview); return
                    }
                    AppData.shared.employeeOverview = response
                    resolver.fulfill(response)
                })
            }.catch { err in
                //TODO - remove fulfill mock data code
                LoggingUtil.shared.cPrint(err)
                resolver.reject(CheqAPIManagerError_Lending.unableToRetrieveLendingOverview)
            }
            #endif
        }
    }
    
//    func resolveNameConflict()->Promise<AuthUser> {
//        return Promise<AuthUser>() { resolver in
//            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
//                let token = authUser.authToken() ?? ""
//
//               LendingAPI.resolveNameConflictWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute { (response, err) in
//                    if let error = err {
//                        LoggingUtil.shared.cPrint(error)
//                        resolver.reject(CheqAPIManagerError_Lending.unableToResolveNameConflict)
//                        return
//                    }
//
//                    resolver.fulfill(authUser)
//                }
//
//            }.catch { err in
//                resolver.reject(err)
//            }
//        }
//    }
    
    
    func updateDirectDebitBankAccount()->Promise<AuthUser> {
       
        return Promise<AuthUser>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                let qvm = QuestionViewModel()
                qvm.loadSaved()
                let account = "\(qvm.fieldValue(.firstname)) \(qvm.fieldValue(.lastname))"
                 LoggingUtil.shared.cPrint(account)
                let isJoint = Bool(qvm.fieldValue(.bankIsJoint))
                let putBankAccountRequest = PutBankAccountRequest(accountName:account, bsb: qvm.fieldValue(.bankBSB), accountNumber: qvm.fieldValue(.bankAccNo), isJointAccount: isJoint)
                 LoggingUtil.shared.cPrint(putBankAccountRequest)
                LendingAPI.putBankAccountWithRequestBuilder(request: putBankAccountRequest).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute { (response, err) in
                  
                    LoggingUtil.shared.cPrint(response)
                    LoggingUtil.shared.cPrint(err)
        
                    if let error = err {
                        if let code = error.code() {
                               if code == 400 {
                                   resolver.reject(CheqAPIManagerError.errorInvalidBSB)
                                   return
                               } else {
                                   resolver.reject(error)
                                   return
                               }
                        }
                    }
                    resolver.fulfill(authUser)
                }
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    
//
//    func updateDirectDebitBankAccount()->Promise<Any> {
//        return Promise<Any>() { resolver in
//
//            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
//
//                let qvm = QuestionViewModel()
//                qvm.loadSaved()
//                let account = "\(qvm.fieldValue(.firstname)) \(qvm.fieldValue(.lastname))"
//                 LoggingUtil.shared.cPrint(account)
//                let isJoint = Bool(qvm.fieldValue(.bankIsJoint))
//                let putBankAccountRequest = PutBankAccountRequest(accountName:account, bsb: qvm.fieldValue(.bankBSB), accountNumber: qvm.fieldValue(.bankAccNo), isJointAccount: isJoint)
//                LoggingUtil.shared.cPrint(putBankAccountRequest)
//
//
//                let path = "/v1/Lending/bankaccount"
//                let URLString = SwaggerClientAPI.basePath + path
//                let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: putBankAccountRequest)
//                //let url = URLComponents(string: URLString)
//
//
//                let token = authUser.authToken() ?? ""
//                let headers = [ "Content-Type" : "application/json", HttpHeaderKeyword.authorization.rawValue: "\(HttpHeaderKeyword.bearer.rawValue) \(token)"]
//
//                Alamofire.request(URLString, method: .put, parameters: parameters,encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
//                     LoggingUtil.shared.cPrint(response)
//
//
//                        switch response.result {
//                                case .success(let json):
//                                    LoggingUtil.shared.cPrint(json)
//                                    resolver.fulfill(json)
//
//                                case .failure(let error):
//                                    LoggingUtil.shared.cPrint(error)
//                                    resolver.reject(error)
//                        }
//                   }
//
////
////                Alamofire.request(URLString, method: .put, parameters: parameters, headers : headers)
////                    .validate().responseJSON { response in
////
////                                switch response.result {
////                                case .success(let json):
////
////                                    LoggingUtil.shared.cPrint(json)
////
//////                                    guard let dictionary = json as? [String: Any] else {
//////                                        //resolver.reject(ActivityError.malformed("not a dictionary"))
//////                                        return
//////                                    }
////                                    resolver.fulfill(json)
////                                case .failure(let error):
////                                    LoggingUtil.shared.cPrint(error)
////                                    resolver.reject(error)
////                                }
////                  }
//
//            }.catch { err in
//                resolver.reject(err)
//            }
//        }
//    }
    
    func callAPI(url:URL, param : [String: Any], headers : [String :Any]?) -> Promise<[String: Any]> {

        return Promise<[String: Any]>() { resolver in
            Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers : headers as? HTTPHeaders)
                .validate()
                .responseJSON { response in
    
                    switch response.result {
                    case .success(let json):
                        
                        LoggingUtil.shared.cPrint(json)
                          
                        guard let dictionary = json as? [String: Any] else {
                            //resolver.reject(ActivityError.malformed("not a dictionary"))
                            return
                        }
                        resolver.fulfill(dictionary)
                    case .failure(let error):
                        LoggingUtil.shared.cPrint(error)
                        resolver.reject(error)
                    }
            }
        }
    }
    
    
    func getSalaryPayCycleTimeSheets() -> Promise<[SalaryTransactionResponse]>  {
        return Promise<[SalaryTransactionResponse]>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                LendingAPI.getIncomingTransactionsWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (timeSheets, err) in
                    if let error = err {
                        LoggingUtil.shared.cPrint(error)
                        resolver.reject(CheqAPIManagerError_Lending.unableToGetTimeSheets); return
                    }
                    guard let response = timeSheets?.body else {
                        resolver.reject(CheqAPIManagerError_Lending.unableToGetTimeSheets); return
                    }
                    AppData.shared.employeePaycycle = response
                   
                    resolver.fulfill(response)
                })
            }.catch { err in
                //TODO - remove fulfill mock data code
                LoggingUtil.shared.cPrint(err)
                resolver.reject(CheqAPIManagerError_Lending.unableToGetTimeSheets)
            }
        }
    }
    
    func postSalaryTransactions(req : PostSalaryTransactionsRequest)->Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                LendingAPI.postSalaryTransactionsWithRequestBuilder(salaryTransactions: req).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute { (response, err) in
                    
                    if let error = err {
                        LoggingUtil.shared.cPrint(error)
                        resolver.reject(CheqAPIManagerError_Lending.unableToPutBankDetails);
                        return
                    }
                    resolver.fulfill(authUser)
                }
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    
    func PostMoneySoftErrorlogs(requestParam:PostLogRequest?) ->Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
                   AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                       let token = authUser.authToken() ?? ""
                     
                       LoggingAPI.postLogWithRequestBuilder(request: requestParam).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute { (response, err) in
                           
                           if let error = err {
                               LoggingUtil.shared.cPrint(error)
                               
                               resolver.reject(AuthManagerError.unknown);
                               return
                               
                           }
                           resolver.fulfill(authUser)
                       }
                   }.catch { err in
                       resolver.reject(err)
                   }
            }
    }
    
}


 
