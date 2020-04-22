//
//  CheqAPIManager_Budgeting.swift
//  Cheq
//
//  Created by Xuwei Liang on 18/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
import DateToolsSwift

extension CheqAPIManager {
    
    func getBugets()->Promise<GetUserBudgetResponse> {

        return Promise<GetUserBudgetResponse>() { resolver in
            
            #if DEMO
            let getUserBudgetResponse = TestUtil.shared.testGetBudgets()
            resolver.fulfill(getUserBudgetResponse)
            #else
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                
                BudgetingAPI.getBudgetsWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (getUserBudgetResponse, err) in
                    if let error = err {
                        LoggingUtil.shared.cPrint(error)
                        resolver.reject(CheqAPIManagerError_Budget.unableToRetrieveBudgets)
                    }
                    
                    guard let response = getUserBudgetResponse?.body else {
                        resolver.reject(CheqAPIManagerError_Budget.unableToRetrieveBudgets); return
                    }
                    resolver.fulfill(response)
                })
            }.catch { err in
                resolver.reject(err)
            }
            #endif
        }
    }
    
    func putBudgets(_ req: PutUserBudgetsRequest)->Promise<Void> {
        
        return Promise<Void>() { resolver in            
            #if DEMO
            resolver.fulfill(())
            #else
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let token = authUser.authToken() ?? ""
                BudgetingAPI.updateUserBudgetWithRequestBuilder(request: req).addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: "\(HttpHeaderKeyword.bearer.rawValue) \(token)").execute({ (response, err) in
                    if let error = err {
                        LoggingUtil.shared.cPrint(error)
                        resolver.reject(CheqAPIManagerError_Budget.unableToPutBudgets)
                    }
                    
                    resolver.fulfill(())
                })
            }.catch { err in
                resolver.reject(err)
            }
            #endif
        }
    }
}
