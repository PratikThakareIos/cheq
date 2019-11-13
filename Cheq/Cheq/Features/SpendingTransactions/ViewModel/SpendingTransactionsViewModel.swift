//
//  SpendingTransactionsViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 13/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class SpendingTransactionsViewModel: BaseTableVCViewModel {
    
    override init() {
        super.init()
        self.screenName = .spendingTransactions
    }
    
    func render(_ transactionsResponse: GetSpendingSpecificCategoryResponse) {
        
        let spacer = SpacerTableViewCellViewModel()
        var section = TableSectionViewModel()
        categoryMonthlyStats(transactionsResponse.monthAmountStats, section: &section)
        for dailyTransaction: DailyTransactionsResponse in transactionsResponse.dailyTransactions ?? [] {
            let header = HeaderTableViewCellViewModel()
            header.showViewAll = false
            header.title = dailyTransaction.date ?? ""
            section.rows.append(header)
            section.rows.append(spacer)
            transactionList(dailyTransaction.transactions ?? [], hideIcon: true,  section: &section)
            section.rows.append(spacer)
        }
        self.sections = [section]
        NotificationUtil.shared.notify(UINotificationEvent.reloadTable.rawValue, key: "", value: "")
    }
}
