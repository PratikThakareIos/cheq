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
    private init () { }
    
    func putUserDetails(_ firstName: String, lastName: String, dateOfBirth: Date, mobile: String, residentialAddress: String)->Promise<AuthUser> {

        return Promise<AuthUser>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser()
            .done { authUser in
                let userDetails = PutUserDetailRequest(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, mobile: mobile, residentialAddress: residentialAddress)
                let token = authUser.authToken() ?? ""
                UsersAPI.putUserDetailWithRequestBuilder(request: userDetails).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in
                   
                    if let error = err { resolver.reject(error); return }
                    guard let resp = response?.body else { resolver.reject(CheqAPIManagerError.unableToParseResponse); return }
                    var updatedAuthUser = authUser
                    updatedAuthUser.msCredential[.msUsername] = resp.moneySoftCredential?.msUsername
                    updatedAuthUser.msCredential[.msPassword] = resp.moneySoftCredential?.msPassword
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
    func retrieveUserDetailsKyc()-> Promise<PutUserKycResponse> {
        var oauthToken = ""
        return Promise<PutUserKycResponse>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                oauthToken = authUser.authToken() ?? ""
                UsersAPI.putUserOnfidoKycWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(oauthToken)").execute{ (response, err) in
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
