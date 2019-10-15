//
//  CheqAPIManager_Spending.swift
//  Cheq
//
//  Created by XUWEI LIANG on 30/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit 

extension CheqAPIManager {

    func spendingTransactions()->Promise<GetSpendingSpecificCategoryResponse> {
        return Promise<GetSpendingSpecificCategoryResponse>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                SpendingAPI.getSpendingAllTransctionsWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (spendingTransactionsResponse, err) in
                    if let error = err {
                        resolver.reject(error); return
                    }

                    guard let response = spendingTransactionsResponse?.body else {
                        resolver.reject(CheqAPIManagerError_Spending.unableToRetrieveTransactions); return
                    }

                    resolver.fulfill(response)
                })
            }.catch { err in
                resolver.reject(err)
            }
        }
    }

    func spendingOverview()->Promise<GetSpendingOverviewResponse> {
        return Promise<GetSpendingOverviewResponse>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                SpendingAPI.getSpendingOverviewWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({
                    (spendingOverviewResponse, err) in
                    if let error = err {
                        resolver.reject(error); return
                    }

                    guard let response = spendingOverviewResponse?.body else {
                        resolver.reject(CheqAPIManagerError_Spending.unableToRetrieveOverview); return
                    }

                    resolver.fulfill(response)
                })
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
}
