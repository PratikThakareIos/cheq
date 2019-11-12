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
    
    func spendingCategoryById(_ id: Int)->Promise<GetSpendingSpecificCategoryResponse> {
        return Promise<GetSpendingSpecificCategoryResponse>() { resolver in
            
            let spendingSpecificCategoryResponse = TestUtil.shared.testSpendingCategoryById()
            resolver.fulfill(spendingSpecificCategoryResponse)
            
//            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
//                let token = authUser.authToken() ?? ""
//                SpendingAPI.getSpendingSpecificCategoryStatsWithRequestBuilder(_id: id).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (getSpendingSpecificCategoryResponse, err) in
//                    if let error = err {
//                        resolver.reject(error); return
//                    }
//                    guard let response = getSpendingSpecificCategoryResponse?.body else {
//                        resolver.reject(CheqAPIManagerError_Spending.unableToRetrieveCategoryById); return
//                    }
//                    resolver.fulfill(response)
//                })
//            }.catch { err in
//                resolver.reject(err)
//            }
        }
    }

    func spendingTransactions()->Promise<GetSpendingSpecificCategoryResponse> {
        return Promise<GetSpendingSpecificCategoryResponse>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                SpendingAPI.getSpendingAllTransactionsWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (spendingTransactionsResponse, err) in
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
    
    func spendingCategories()->Promise<GetSpendingCategoryResponse> {
        return Promise<GetSpendingCategoryResponse>() { resolver in
            
            // TODO: REMOVE LATER
            let spendingCategoriesResponse: GetSpendingCategoryResponse = TestUtil.shared.testSpendingCategories()
            resolver.fulfill(spendingCategoriesResponse)
            return
            
//            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
//                let token = authUser.authToken() ?? ""
//                SpendingAPI.getSpendingCategoryStatsWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (spendingCategoriesResponse, err) in
//                    if let error = err {
//                        resolver.reject(error); return
//                    }
//
//                    guard let response = spendingCategoriesResponse?.body else {
//                        resolver.reject(CheqAPIManagerError_Spending.unableToRetrieveOverview)
//                        return
//                    }
//
//                    resolver.fulfill(response)
//                })
//            }.catch { err in
//                resolver.reject(err)
//            }
        }
    }

    func spendingOverview()->Promise<GetSpendingOverviewResponse> {
        return Promise<GetSpendingOverviewResponse>() { resolver in
            
            // TODO: REMOVE LATER
            let getSpendingOverviewResponse: GetSpendingOverviewResponse = TestUtil.shared.testSpendingOverview()
            resolver.fulfill(getSpendingOverviewResponse)
            return
            
        
//            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
//                let token = authUser.authToken() ?? ""
//                SpendingAPI.getSpendingOverviewWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({
//                    (spendingOverviewResponse, err) in
//                    if let error = err {
//                        resolver.reject(error); return
//                    }
//
//                    guard let response = spendingOverviewResponse?.body else {
//                        resolver.reject(CheqAPIManagerError_Spending.unableToRetrieveOverview); return
//                    }
//
//                    resolver.fulfill(response)
//                })
//            }.catch { err in
//                resolver.reject(err)
//            }
        }
    }
}
