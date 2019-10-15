//
//  SpendingOverviewViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 30/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

class SpendingOverviewViewModel: BaseViewModel {
    
    var upcomingBills = [GetUpcomingBillResponse]()
    var topCategoriesAmount = [CategoryAmountStatResponse]()
    var recentTransactions = [SlimTransactionResponse]()
    
    override func load(_ complete: @escaping () -> Void) {
        CheqAPIManager.shared.spendingOverview().done { spendingOverviewResponse in
            let response :GetSpendingOverviewResponse = spendingOverviewResponse
            self.upcomingBills = response.upcomingBills ?? []
            self.topCategoriesAmount = response.topCategoriesAmount ?? []
            self.recentTransactions = response.recentTransactions ?? []
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
        }.finally {
            complete()
        }
    }
}
