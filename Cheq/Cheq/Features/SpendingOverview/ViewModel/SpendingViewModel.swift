//
//  SpendingOverviewViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 30/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

enum SpendingVCType {
    case overview
    case categories
    case specificCategory
    case transactions
}

class SpendingViewModel: BaseTableVCViewModel {
    
    override init() {
        super.init()
        self.screenName = .spending
    }
    
    func render(_ spendingOverview: GetSpendingOverviewResponse) {
        
        clearSectionIfNeeded()
        var section = TableSectionViewModel()
        spendingCard(spendingOverview, section: &section)
        upcomingBills(spendingOverview, section: &section)
        categoryAmounts(spendingOverview, section: &section)
        recentTransactionList(spendingOverview, section: &section)
        self.sections = [section]

        NotificationUtil.shared.notify(UINotificationEvent.reloadTable.rawValue, key: "", value: "")
    }
}

// MARK: spending card
extension SpendingViewModel {
    func spendingCard(_ spendingOverview: GetSpendingOverviewResponse, section: inout TableSectionViewModel) {
        let spacer = SpacerTableViewCellViewModel()
        let spendingCard = SpendingCardTableViewCellViewModel()
        if let overviewCard = spendingOverview.overviewCard {
            spendingCard.data = overviewCard
            section.rows.append(spendingCard)
            section.rows.append(spacer)
        }
    }
}

// MARK: upcoming bills
extension SpendingViewModel {
    func upcomingBills(_ spendingOverview: GetSpendingOverviewResponse, section: inout TableSectionViewModel) {
        let spacer = SpacerTableViewCellViewModel()
        if let upcomingBillsResponse = spendingOverview.upcomingBills, upcomingBillsResponse.count > 0 {
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
        
        
    }
}

// MARK: category amount
extension SpendingViewModel {
    func categoryAmounts(_ spendingOverview: GetSpendingOverviewResponse, section: inout TableSectionViewModel) {
        let spacer = SpacerTableViewCellViewModel()
        if let categoryAmountStatResponseList = spendingOverview.topCategoriesAmount {
            let moneySpentHeader = HeaderTableViewCellViewModel()
            moneySpentHeader.title = Header.moneySpent.rawValue
            moneySpentHeader.tag = HeaderTableViewCellTag.moneySpent.rawValue
            moneySpentHeader.showViewAll = true
            section.rows.append(moneySpentHeader)
            section.rows.append(spacer)
            categoryAmountsList(categoryAmountStatResponseList, section: &section)
        }
    }
}

//MARK: recent transaction list
extension SpendingViewModel {
    func recentTransactionList(_ spendingOverview: GetSpendingOverviewResponse, section: inout TableSectionViewModel) {
    
        let spacer = SpacerTableViewCellViewModel()
        if let recentTransactionList = spendingOverview.recentTransactions {
            let recentTransactionHeader = HeaderTableViewCellViewModel()
            recentTransactionHeader.tag = HeaderTableViewCellTag.recentTransactions.rawValue
            recentTransactionHeader.title = Header.recentActivity.rawValue
            recentTransactionHeader.showViewAll = true
            section.rows.append(recentTransactionHeader)
            section.rows.append(spacer)
            transactionList(recentTransactionList, hideIcon: false, section: &section)
            section.rows.append(spacer)
        }
    }
}


