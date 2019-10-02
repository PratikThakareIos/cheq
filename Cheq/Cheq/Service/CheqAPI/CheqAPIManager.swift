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

    func flushWorkTimesToServer()-> Promise<Bool> {
        return Promise<Bool> () { resolver in
            let token = CKeychain.getValueByKey(CKey.authToken.rawValue)
            guard token.isEmpty == false else { return }
            let postWorksheetReq = VDotManager.shared.loadWorksheets()
            LendingAPI.postTimeWithRequestBuilder(request: postWorksheetReq).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute { (response, err) in
                if let error = err {
                    resolver.reject(error)
                    LoggingUtil.shared.cWriteToFile(LoggingUtil.shared.fcmMsgFile, newText: "flushStoredData failed\n")
                    return
                }

                let timeStamp = Date().timeStamp()
                LoggingUtil.shared.cWriteToFile(LoggingUtil.shared.fcmMsgFile, newText: "flushStoredData successfully - \(timeStamp)\n")
                resolver.fulfill(true)
            }
        }
    }

    func employerAddressLookup(_ query: String)-> Promise<[GetEmployerPlaceResponse]> {
        return Promise<[GetEmployerPlaceResponse]>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                LocationsAPI.getAutocompleteWorkAddressWithRequestBuilder(query: query).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute { (response, err) in
                    if let error = err { resolver.reject(error); return }
                    guard let resp: [GetEmployerPlaceResponse] = response?.body else {
                        resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
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
                let employerDetailsReq = PutUserEmployerRequest(employerName: req.employerName, employmentType: req.employmentType ?? PutUserEmployerRequest.EmploymentType.fulltime, address: req.address ?? "", noFixedAddress: req.noFixedAddress ?? false, latitude: req.latitude ?? 0.0, longitude: req.longitude ?? 0.0, postCode: req.postCode ?? "", state: req.state ?? "", country: req.country ?? "")
                UsersAPI.putUserEmployerWithRequestBuilder(request: employerDetailsReq).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute{ (response, err) in
                    
                    if let error = err { resolver.reject(error); return }
                    guard let resp = response?.body else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                    var updatedAuthUser = authUser
                    updatedAuthUser.msCredential[.msUsername] = resp.moneySoftCredential?.msUsername
                    let password = StringUtil.shared.decodeBase64(resp.moneySoftCredential?.msPassword ?? "")
                    updatedAuthUser.msCredential[.msPassword] = password
                    AuthConfig.shared.activeManager.setUser(updatedAuthUser).done{ updateUser in
                        resolver.fulfill(updateUser)
                    }.catch {err in
                            resolver.reject(err)
                    }
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
                        
                        if let error = err { resolver.reject(error); return }
                        guard let resp = response?.body else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                        var updatedAuthUser = authUser
                        updatedAuthUser.msCredential[.msUsername] = resp.moneySoftCredential?.msUsername
                        let password = StringUtil.shared.decodeBase64(resp.moneySoftCredential?.msPassword ?? "")
                        updatedAuthUser.msCredential[.msPassword] = password
                        AuthConfig.shared.activeManager.setUser(updatedAuthUser).done{ updateUser in
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
    
    func putUserDetails(_ req: PutUserDetailRequest)->Promise<AuthUser> {
        
        return Promise<AuthUser>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser()
            .done { authUser in
                let token = authUser.authToken() ?? ""
                let userDetails = req
                
                UsersAPI.putUserDetailWithRequestBuilder(request: userDetails).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in
                   
                    if let error = err { resolver.reject(error); return }
                    guard let resp = response?.body else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                    var updatedAuthUser = authUser
                    updatedAuthUser.msCredential[.msUsername] = resp.moneySoftCredential?.msUsername
                    let password = StringUtil.shared.decodeBase64(resp.moneySoftCredential?.msPassword ?? "")
                    updatedAuthUser.msCredential[.msPassword] = password
                    AuthConfig.shared.activeManager.setUser(updatedAuthUser).done{ updateUser in
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
    
    // try PUT USER KYC, if error, it will do GET USER KYC
    // PUT will get error when we have initiated an application already 
    func retrieveUserDetailsKyc(firstName: String, lastName: String, residentialAddress: String, dateOfBirth: Date)-> Promise<PutUserKycResponse> {
        var oauthToken = ""
        return Promise<PutUserKycResponse>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                oauthToken = authUser.authToken() ?? ""
                UsersAPI.putUserOnfidoKycWithRequestBuilder(firstName: firstName, lastName: lastName, residentialAddress: residentialAddress, dateOfBirth: dateOfBirth).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(oauthToken)").execute{ (response, err) in
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
    
    func checkKYCPhotoUploaded()-> Promise<Bool> {
        return Promise<Bool>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                UsersAPI.putKycCheckPhotoWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute { (response, err) in
                    if let error = err { resolver.reject(error); return }
                    resolver.fulfill(true)
                }
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
}
