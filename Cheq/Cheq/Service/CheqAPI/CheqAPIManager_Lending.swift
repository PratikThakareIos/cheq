//
//  CheqAPIManager_Lending.swift
//  Cheq
//
//  Created by Xuwei Liang on 16/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

extension CheqAPIManager {
    
    func lendingOverview()->Promise<GetLendingOverviewResponse> {
        return Promise<GetLendingOverviewResponse>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                LendingAPI.getLendingWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (lendingOverview, err) in
                    if let error = err {
                        resolver.reject(error); return
                    }
                    guard let response = lendingOverview?.body else {
                        resolver.reject(CheqAPIManagerError_Lending.unableToRetrieveLendingOverview); return
                    }
                    
                    resolver.fulfill(response)
                })
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
}
