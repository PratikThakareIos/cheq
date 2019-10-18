//
//  OnfidoManager.swift
//  Cheq
//
//  Created by Xuwei Liang on 12/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation
import PromiseKit

class OnfidoManager {
    static let shared = OnfidoManager()
    private init() { }
    
    // get current user only works when we have already logged in firebase
    // so there is an assumption that we will only use OnfidoManager after we logged in
    func fetchSdkToken()-> Promise<GetUserKycResponse> {
        return AuthConfig.shared.activeManager.getCurrentUser()
                .then { authUser->Promise<GetUserKycResponse> in
                    return Promise<GetUserKycResponse>() { resolver in
                        
                        let req = DataHelperUtil.shared.retrieveUserDetailsKycReq()
                        CheqAPIManager.shared.retrieveUserDetailsKyc(req).done { response in
                            resolver.fulfill(response)
                        }.catch { err in
                            resolver.reject(err)
                        }
                    }
        }
    }
}
