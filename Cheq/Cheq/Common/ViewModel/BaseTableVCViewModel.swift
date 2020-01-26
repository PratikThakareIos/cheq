//
//  BaseTableVCViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 19/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 This is a very important viewModel class as it is subclassed by viewModels of all the  subclasses of **CTableViewController** as ViewModel. **BaseTableVCViewModel** provides the interface for which **CTableViewController** expects to render viewModel.
 */
class BaseTableVCViewModel {
    
    /// Screen name for tracking user's navigation, uses **ScreenName** enum. Update if neccessary.
    var screenName: ScreenName = .unknown
    
    /// Sections is made up Array of **TableSectionViewModel**
    var sections = [TableSectionViewModel]()
    
    /// Load async task method interface with completion callback. This can be override by subclasses.
    @objc func load(_ complete: @escaping () -> Void) { complete() }
    
    /// Adding section with viewModel is a abstracted from the details of accessing the actual sections Array
    func addSection(_ section: TableSectionViewModel) {
        self.sections.append(section)
    }
    
    /// Abstracting the Insert of section by index to the Array of sections
    func insertSection(_ section: TableSectionViewModel, index: Int) {
        self.sections.insert(section, at: index)
    }
    
    /// There are cases where we need to clear the sections and popuplate it again, this method is called and hides the details of checking if the **sections** Array have more than one item.
    func clearSectionIfNeeded() {
        if self.sections.count > 0 {
            self.sections.removeAll()
        }
    }
}

extension BaseTableVCViewModel {
    
    
    /**
     There are API models coming back which is common across several viewControllers. Common rendering methods are extracted to the extension of **BaseTableVCViewModel** so we don't have to repeat the same logic on subclasses. By means of rendering, we accomplish this adding the corresponding viewModels to section or section to the Array of sections. Because all viewModels subclassing **BaseTableVCViewModel**, **CTableViewController** will know how to handle the calculated data structure in the end. **CategoryMonthlyStats** builds the bar chart tableviewCell UI with an Array of **MonthAmountStatResponse** and reference to which section we add to.
     - parameter monthAmountStatus: Array of **MonthAmountStatResponse** where each is a representation of barView
     - parameter section: reference of section which the method will edit for
    */
    func categoryMonthlyStats(_ monthAmountStatus: [MonthAmountStatResponse]?, section: inout TableSectionViewModel) {
        guard let stats = monthAmountStatus, stats.count > 0 else { return }
        let barChart = BarChartTableViewCellViewModel()
        let spacer = SpacerTableViewCellViewModel()
        barChart.data = stats
        section.rows.append(barChart)
        section.rows.append(spacer)
    }
    
    /**
     This method creates parses an Array of transaction models and create viewModels that represents transaction list in **CTableViewController**.
     - parameter transactionList: Array of **SlimTransactionResponse** from **Spending** API but could come from **Lending** screen as well.
     - parameter hideIcon: when we reach a single category filtered screen on **Spending** tab, we don't need the repeated transaction icons next to the transactions. So the **hideIcon** can be set to true.
     - parameter section: reference of the section that this method will be updating
     */
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
    
    /**
     This method creates the viewModels to render the list of "Category Group" from a list of **CategoryAmountStatResponse** models.
     - parameter categories: Array of **CategoryAmountStatResponse**
     - parameter section: reference of **TableSectionViewModel** to be updated 
     */
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
