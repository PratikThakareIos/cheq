//
//  BaseTableVCViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 19/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class BaseTableVCViewModel {
    var screenName: ScreenName = .unknown
    var sections = [TableSectionViewModel]()
    
    @objc func load(_ complete: @escaping () -> Void) { complete() }
    
    func addSection(_ section: TableSectionViewModel) {
        self.sections.append(section)
    }
    
    func insertSection(_ section: TableSectionViewModel, index: Int) {
        self.sections.insert(section, at: index)
    }
    
    func clearSectionIfNeeded() {
        if self.sections.count > 0 {
            self.sections.removeAll()
        }
    }
}

// common rendering methods
extension BaseTableVCViewModel {
    func categoryMonthlyStats(_ monthAmountStatus: [MonthAmountStatResponse]?, section: inout TableSectionViewModel) {
        guard let stats = monthAmountStatus, stats.count > 0 else { return }
        let barChart = BarChartTableViewCellViewModel()
        let spacer = SpacerTableViewCellViewModel()
        barChart.data = stats
        section.rows.append(barChart)
        section.rows.append(spacer)
    }
    
    func transactionList(_ transactionList: [SlimTransactionResponse], hideIcon: Bool, section: inout TableSectionViewModel) {
        let top = TopTableViewCellViewModel()
        let bottom = BottomTableViewCellViewModel()
        var index = 0
        section.rows.append(top)
        for transaction: SlimTransactionResponse in transactionList {
            let recentTransaction = TransactionTableViewCellViewModel()
            recentTransaction.data = transaction
            recentTransaction.hideIcon = hideIcon
            section.rows.append(recentTransaction)
            if index < transactionList.count - 1 {
                section.rows.append(LineSeparatorTableViewCellViewModel())
            }
            index = index + 1
        }
        
        section.rows.append(bottom)
    }
    
    func categoryAmountsList(_ categories: [CategoryAmountStatResponse], section: inout TableSectionViewModel) {
        let top = TopTableViewCellViewModel()
        let bottom = BottomTableViewCellViewModel()
        section.rows.append(top)
        for categoryAmount in categories {
            let transactionGroup = TransactionGroupTableViewCellViewModel()
            transactionGroup.data = categoryAmount
            section.rows.append(transactionGroup)
        }
        section.rows.append(bottom)
    }
}
