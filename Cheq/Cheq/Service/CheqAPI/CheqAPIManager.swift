//
//  CheqAPIManager.swift
//  Cheq
//
//  Created by Xuwei Liang on 13/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation
import PromiseKit
import DateToolsSwift

class CheqAPIManager {
    static let shared = CheqAPIManager()
    private init () {
    }
    
    func resetPassword(_ code: String, newPassword: String)->Promise<Void> {
        return Promise<Void>() { resolver in
            let req = DataHelperUtil.shared.putResetPasswordRequest(code, newPassword: newPassword)
            UsersAPI.resetPasswordWithRequestBuilder(request: req).execute( { (response, err) in
                if let error = err { resolver.reject(error); return }
                resolver.fulfill(())
            })
        }
    }
    
    func forgotPassword()->Promise<Void> {
        return Promise<Void>() { resolver in
            let req = DataHelperUtil.shared.postForgotPasswordRequest()
            UsersAPI.forgetPasswordWithRequestBuilder(request: req).execute { (response, err) in
                if let error = err {
                    LoggingUtil.shared.cPrint(error)
                    resolver.reject(AuthManagerError.unableToRequestPasswordResetEmail); return
                }
                resolver.fulfill(())
            }
        }
    }

    func postNotificationToken(_ req: PostPushNotificationRequest)->Promise<Bool> {
        return Promise<Bool>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                UsersAPI.postPushNotificationTokenWithRequestBuilder(request: req).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute{ (response, err) in
                    resolver.fulfill(true)
                }
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    func postAccounts(_ accounts: [PostFinancialAccountRequest])->Promise<Bool> {
        return Promise<Bool>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                FinancesAPI.postAccountsWithRequestBuilder(accounts: accounts).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in
                    if let error = err {
                        resolver.reject(error); return
                    }
                    resolver.fulfill(true)
                })
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    func postBanks(_ institutions: [PostFinancialInstitutionRequest])->Promise<Bool> {
        return Promise<Bool>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                FinancesAPI.postFinancialInstitutionsWithRequestBuilder(institutions: institutions).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in
                    
                    if let error = err {
                        resolver.reject(error); return
                    }
                    resolver.fulfill(true)
                })
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    func postTransactions(_ transactions: [PostFinancialTransactionRequest])->Promise<Bool> {
        return Promise<Bool>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                FinancesAPI.postTransactionsWithRequestBuilder(transactions: transactions).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in

                    if let error = err {
                        resolver.reject(error); return
                    }
                    resolver.fulfill(true)
                })
            }.catch { err in
                resolver.reject(err)
            }
        }
    }

    //manish
//    func flushWorkTimesToServer()-> Promise<Bool> {
//        return Promise<Bool> () { resolver in
//            let token = CKeychain.shared.getValueByKey(CKey.authToken.rawValue)
//            guard token.isEmpty == false else { return }
//            let postWorksheetReq = VDotManager.shared.loadWorksheets()
//            LendingAPI.postTimeWithRequestBuilder(request: postWorksheetReq).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute { (response, err) in
//                if let error = err {
//                    resolver.reject(error)
//                    LoggingUtil.shared.cWriteToFile(LoggingUtil.shared.fcmMsgFile, newText: "flushStoredData failed\n")
//                    return
//                }
//
//                let timeStamp = Date().timeStamp()
//                LoggingUtil.shared.cWriteToFile(LoggingUtil.shared.fcmMsgFile, newText: "flushStoredData successfully - \(timeStamp)\n")
//                resolver.fulfill(true)
//            }
//        }
//    }

    func employerAddressLookup(_ query: String)-> Promise<[GetEmployerPlaceResponse]> {
        return Promise<[GetEmployerPlaceResponse]>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                LoggingUtil.shared.cPrint("query : \(query)")
                LocationsAPI.getAutocompleteWorkAddressWithRequestBuilder(query: query).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute { (response, err) in
                    if let error = err { resolver.reject(error); return }
                    guard let resp: [GetEmployerPlaceResponse] = response?.body else {
                        resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                    resp.forEach({ LoggingUtil.shared.cPrint($0.address) })
                    resolver.fulfill(resp)
                }
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    func residentialAddressLookup(_ query: String)-> Promise<[GetAddressResponse]> {
        return Promise<[GetAddressResponse]>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser()
                .done { authUser in
                    let token = authUser.authToken() ?? ""
                    LocationsAPI.getAutocompleteAddressWithRequestBuilder(query: query).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute { (response, err) in
                        if let error = err { resolver.reject(error); return }
                        guard let resp: [GetAddressResponse] = response?.body else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                        // will be using longitude, latitude when fetching employer list afterward
                        resolver.fulfill(resp)
                    }
                }.catch { err in
                    resolver.reject(err)
                }
        }
    }
    
    func putUserEmployer(_ req: PutUserEmployerRequest)->Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser()
            .done { authUser in
                let token = authUser.authToken() ?? ""
                let employerDetailsReq = PutUserEmployerRequest(employerName: req.employerName, employmentType: req.employmentType ?? PutUserEmployerRequest.EmploymentType.fulltime, workingLocation: .fromMultipleLocations, latitude: req.latitude ?? 0.0, longitude: req.longitude ?? 0.0, address:  req.address ?? "", state: req.state ?? "", country: req.country ?? "", postCode: req.postCode ?? "")
                    
                UsersAPI.putUserEmployerWithRequestBuilder(request: employerDetailsReq).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute{ (response, err) in
                    
                    
                    if let error = err { resolver.reject(error); return }
                    let statusCode = response?.statusCode ?? 0
                    guard statusCode >= 200, statusCode < 209 else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                    
                    resolver.fulfill(authUser)
                }
            }.catch { err in
                resolver.reject(err)
            }
        }
    }

    func getUserDetails()-> Promise<AuthUser> {        
        return Promise<AuthUser>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser()
            .done { authUser in
                    let token = authUser.authToken() ?? ""
                    UsersAPI.getUserWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in
                        
                        // http code 400 indicates bad req, we will indicate user needs to do onboarding again
                        if response?.statusCode == 400 {
                            resolver.reject(CheqAPIManagerError.onboardingRequiredFromGetUserDetails)
                            return
                        }
                        
                        if let code = err?.code() {
                            if code == 400 {
                                resolver.reject(CheqAPIManagerError.onboardingRequiredFromGetUserDetails)
                                return
                            } else {
                                resolver.reject(CheqAPIManagerError.errorFromGetUserDetails)
                                return
                            }
                        }

                        guard let resp = response?.body else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                                            
                        let viewModel = QuestionViewModel()
                        
                        //Manish
                        if let userDetail =  resp.userDetail {
                            viewModel.save(QuestionField.firstname.rawValue, value: userDetail.firstName ?? "")
                            viewModel.save(QuestionField.lastname.rawValue, value: userDetail.lastName ?? "")
                            viewModel.save(QuestionField.dateOfBirth.rawValue, value: userDetail.dateOfBirth ?? "")
                            viewModel.save(QuestionField.contactDetails.rawValue, value: userDetail.mobile ?? "")
                            viewModel.save(QuestionField.residentialAddress.rawValue, value: userDetail.residentialAddress ?? "")
                        }
                        
                        viewModel.save(QuestionField.employerName.rawValue, value: resp.employer?.employerName ?? "")
                        viewModel.save(QuestionField.employerAddress.rawValue, value: resp.employer?.address ?? "")
                        
                        AuthConfig.shared.activeManager.setUser(authUser).done{ updateUser in
                            resolver.fulfill(updateUser)
                        }.catch {err in
                            resolver.reject(err)
                        }
                    })
            }.catch {err in
                resolver.reject(err)
            }
        }
    }
    
    func putUser(_ authUser: AuthUser)->Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
            let token = authUser.authToken() ?? ""
            UsersAPI.putUserWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in
                if let error = err { resolver.reject(error); return }
                resolver.fulfill(authUser)
            })
        }
    }
    
    func putUserDetails(_ req: PutUserDetailRequest)->Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser()
            .done { authUser in
                let token = authUser.authToken() ?? ""
                let userDetails = req
                
                UsersAPI.putUserDetailWithRequestBuilder(request: userDetails).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in
                   
                    if let error = err { resolver.reject(error); return }
                    guard let resp = response?.body else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                    
//                    var updatedAuthUser = authUser
//                    updatedAuthUser.msCredential[.msUsername] = resp.moneySoftCredential?.msUsername
//                    let password = StringUtil.shared.decodeBase64(resp.moneySoftCredential?.msPassword ?? "")
//                    updatedAuthUser.msCredential[.msPassword] = password
                    
                    AuthConfig.shared.activeManager.setUser(authUser).done{ updateUser in
                        resolver.fulfill(updateUser)
                    }.catch {err in
                        resolver.reject(err)
                    }
                })
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    func putKycCheck()->Promise<Void> {
        return Promise<Void>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let oauthToken = authUser.authToken() ?? ""
                UsersAPI.putKycCheckWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(oauthToken)").execute { (resp, err) in
                    if err != nil {
                        resolver.reject(CheqAPIManagerError.unableToPerformKYCNow)
                        return
                    }
                    resolver.fulfill(())
                }
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    // try PUT USER KYC, if error, it will do GET USER KYC
    // PUT will get error when we have initiated an application already
    func retrieveUserDetailsKyc(_ req: PutUserOnfidoKycRequest)-> Promise<GetUserKycResponse> {
        var oauthToken = ""
        return Promise<GetUserKycResponse>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                oauthToken = authUser.authToken() ?? ""
                UsersAPI.putUserOnfidoKycWithRequestBuilder(request: req).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(oauthToken)").execute{ (response, err) in
                    if err != nil {
                        // if we got an error we will do a getUserDetailsKYC incase we have existing application
                        UsersAPI.getUserOnfidoKycWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(oauthToken)").execute { (response, getKycErr) in
                            if let getKycError = getKycErr { resolver.reject(getKycError); return }
                            guard let resp = response?.body else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                            resolver.fulfill(resp)
                        }
                        return
                    }
                    guard let resp = response?.body else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                    resolver.fulfill(resp)
                }
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    func getUserActions()-> Promise<GetUserActionResponse> {
        return Promise<GetUserActionResponse>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser()
            .done { authUser in
                    let token = authUser.authToken() ?? ""
                UsersAPI.getUserActionsWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in
                    
                    // http code 400 indicates bad req, we will indicate user needs to do onboarding again
                    if response?.statusCode == 400 {
                        resolver.reject(CheqAPIManagerError.onboardingRequiredFromGetUserDetails)
                        return
                    }
                   
                    if let code = err?.code() {
                        if code == 400 {
                            resolver.reject(CheqAPIManagerError.onboardingRequiredFromGetUserDetails)
                            return
                        } else {
                            resolver.reject(CheqAPIManagerError.errorFromGetUserDetails)
                            return
                        }
                    }
                    guard let resp = response?.body else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                    resolver.fulfill(resp)
                })
            }.catch {err in
                resolver.reject(err)
            }
        }
    }
    
    
    func getFinancesInstitutionsList()->Promise<GetFinancialInstitutionResponse> {
        return Promise<GetFinancialInstitutionResponse>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                FinancesAPI.getFinancialInstitutionsWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in

                    if let error = err {
                        LoggingUtil.shared.cPrint(error)
                        resolver.reject(error);
                        return
                    }
                    guard let resp = response?.body else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                    resolver.fulfill(resp)
                    
                })
            }.catch { err in
                LoggingUtil.shared.cPrint(err)
                resolver.reject(err)
            }
        }
    }
    
    
    /// call the following endpoint to get the app token    /v1/Finances/connections/token
    
    func getBasiqConnectionTokenForBankLogin()->Promise<GetAppTokenResponse> {
        return Promise<GetAppTokenResponse>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                FinancesAPI.getBasiqConnectionTokenWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in

                    if let error = err {
                        LoggingUtil.shared.cPrint(error)
                        resolver.reject(error);
                        return
                    }
                    guard let resp = response?.body else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                    resolver.fulfill(resp)
                    
                })
            }.catch { err in
                LoggingUtil.shared.cPrint(err)
                resolver.reject(err)
            }
        }
    }
    

    func postBasiqConnectionJob(req:PostConnectionJobRequest)->Promise<Bool> {
        return Promise<Bool>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                FinancesAPI.postBasiqConnectionJobWithRequestBuilder(request: req).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in
                    if let error = err {
                        resolver.reject(error); return
                    }
                    resolver.fulfill(true)
                })
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
   
    ///v1/Finances/connections/jobs/{jobId}/status
    func getBasiqConnectionJobStatus(jobId: String)->Promise<GetConnectionJobResponse> {
         return Promise<GetConnectionJobResponse>() { resolver in
             AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                 let token = authUser.authToken() ?? ""
                 FinancesAPI.getJobStatusWithRequestBuilder(jobId: jobId).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in

                     if let error = err {
                         LoggingUtil.shared.cPrint(error)
                         resolver.reject(error);
                         return
                     }
                     guard let resp = response?.body else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                     resolver.fulfill(resp)
                     
                 })
             }.catch { err in
                 LoggingUtil.shared.cPrint(err)
                 resolver.reject(err)
             }
         }
     }
    
    
    /// "/v1/Finances/connections/update"
    func getBasiqConnectionForUpdate()->Promise<GetConnectionUpdateResponse> {
         return Promise<GetConnectionUpdateResponse>() { resolver in
             AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                 let token = authUser.authToken() ?? ""
                 FinancesAPI.getBasiqConnectionForUpdateWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in

                     if let error = err {
                         LoggingUtil.shared.cPrint(error)
                         resolver.reject(error);
                         return
                     }
                     guard let resp = response?.body else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                     resolver.fulfill(resp)
                 })
             }.catch { err in
                 LoggingUtil.shared.cPrint(err)
                 resolver.reject(err)
             }
         }
     }
    
    
   
     func getJobIdAfterRefreshConnection()->Promise<GetRefreshConnectionResponse> {
         return Promise<GetRefreshConnectionResponse>() { resolver in
             AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                 let token = authUser.authToken() ?? ""
                 FinancesAPI.refreshConnectionWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in

                     if let error = err {
                         LoggingUtil.shared.cPrint(error)
                         resolver.reject(error);
                         return
                     }
                     guard let resp = response?.body else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                     resolver.fulfill(resp)
                 })
             }.catch { err in
                 LoggingUtil.shared.cPrint(err)
                 resolver.reject(err)
             }
         }
     }
    
    func updateFCMTokenToServer() {
        let fcmToken = CKeychain.shared.getValueByKey(CKey.fcmToken.rawValue)
        let apns = CKeychain.shared.getValueByKey(CKey.apnsToken.rawValue)
        let req = PostPushNotificationRequest(deviceId: UIDevice.current.identifierForVendor?.uuidString, firebasePushNotificationToken: fcmToken, applePushNotificationToken: apns, deviceType: .ios)
        let _ = CheqAPIManager.shared.postNotificationToken(req)
    }
}
