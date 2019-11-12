//
//  SpendingSpecificCategoryViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 12/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class SpendingSpecificCategoryViewModel: BaseTableVCViewModel {
    
    override init() {
        super.init()
        self.screenName = .spending
    }
    
    func render(_ spendingSpecificCategoryResponse: GetSpendingSpecificCategoryResponse) {
        
        
        if self.sections.count > 0 {
            self.sections.removeAll()
        }
        
        let spacer = SpacerTableViewCellViewModel()
        var section = TableSectionViewModel()
        categoryMonthlyStats(spendingSpecificCategoryResponse.monthAmountStats, section: &section)
        for dailyTransaction: DailyTransactionsResponse in spendingSpecificCategoryResponse.dailyTransactions ?? [] {
            let header = HeaderTableViewCellViewModel()
            header.showViewAll = false
            header.title = dailyTransaction.date ?? ""
            section.rows.append(header)
            section.rows.append(spacer)
            transactionList(dailyTransaction.transactions ?? [], section: &section)
            section.rows.append(spacer)
        }
        self.sections = [section]
        NotificationUtil.shared.notify(UINotificationEvent.reloadTable.rawValue, key: "", value: "")
    }
}
