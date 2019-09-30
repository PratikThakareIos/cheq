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
    override func load(_ complete: @escaping () -> Void) {
        CheqAPIManager.shared.spendingOverview().done { spendingOverviewResponse in
            let response :GetSpendingOverviewResponse = spendingOverviewResponse
            LoggingUtil.shared.cPrint("transactions : \(response.recentTransactions?.count)")
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
        }
    }
}
