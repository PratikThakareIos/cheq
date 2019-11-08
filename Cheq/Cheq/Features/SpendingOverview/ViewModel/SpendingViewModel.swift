//
//  SpendingOverviewViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 30/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

class SpendingViewModel: BaseTableVCViewModel {
    
    override init() {
        super.init()
        self.screenName = .spending
    }
    
    func render(_ spendingOverview: GetSpendingOverviewResponse) {
        
        
        if self.sections.count > 0 {
            self.sections.removeAll()
        }
        
        let top = TopTableViewCellViewModel()
        let bottom = BottomTableViewCellViewModel()
        let spacer = SpacerTableViewCellViewModel()
        let section = TableSectionViewModel()
        let spendingCard = SpendingCardTableViewCellViewModel()
        if let overviewCard = spendingOverview.overviewCard {
            spendingCard.data = overviewCard
            section.rows.append(spendingCard)
           
            section.rows.append(spacer)
        }
        
        if let upcomingBillsResponse = spendingOverview.upcomingBills {
            let upcomingBillsHeader = HeaderTableViewCellViewModel()
            upcomingBillsHeader.title = Header.upcomingBills.rawValue
            upcomingBillsHeader.showViewAll = false
            section.rows.append(upcomingBillsHeader)
            section.rows.append(spacer)
            let upcomingBillsCollection = UpcomingBillsTableViewCellViewModel()
            for upcoming in upcomingBillsResponse {
                let upcomingBill = UpcomingBillCollectionViewCellViewModel()
                upcomingBill.data = upcoming
                upcomingBillsCollection.upcomingBills.append(upcomingBill)
            }

            section.rows.append(upcomingBillsCollection)
            section.rows.append(spacer)
            section.rows.append(InfoNoteTableViewCellViewModel())
            section.rows.append(spacer)
            section.rows.append(spacer)
        }
        
        if let categoryAmountStatResponseList = spendingOverview.topCategoriesAmount {
            let moneySpentHeader = HeaderTableViewCellViewModel()
            moneySpentHeader.title = Header.moneySpent.rawValue
            moneySpentHeader.showViewAll = true
            section.rows.append(moneySpentHeader)
            section.rows.append(spacer)
            section.rows.append(top)
            
            for categoryAmount in categoryAmountStatResponseList {
                let transactionGroup = TransactionGroupTableViewCellViewModel()
                transactionGroup.data = categoryAmount
                section.rows.append(transactionGroup)
            }
            section.rows.append(bottom)
        }
        
        if let recentTransactionList = spendingOverview.recentTransactions {
            let recentTransactionHeader = HeaderTableViewCellViewModel()
            recentTransactionHeader.title = Header.recentActivity.rawValue
            recentTransactionHeader.showViewAll = true
            section.rows.append(recentTransactionHeader)
            section.rows.append(spacer)
            section.rows.append(top)
            
            for _ in recentTransactionList {
                section.rows.append(TransactionGroupTableViewCellViewModel())
            }
            
            section.rows.append(bottom)
            section.rows.append(spacer)
        }
        
        self.insertSection(section, index: 0)
        
        NotificationUtil.shared.notify(UINotificationEvent.reloadTable.rawValue, key: "", value: "")
    }
}
