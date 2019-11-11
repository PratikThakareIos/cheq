//
//  SpendingCategoriesViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class SpendingCategoriesViewModel: BaseTableVCViewModel {
    
    override init() {
        super.init()
        self.screenName = .spendingCategories
    }
    
    func render(_ spendingCategories: GetSpendingCategoryResponse) {
        
        
        if self.sections.count > 0 {
            self.sections.removeAll()
        }
        var section = TableSectionViewModel()
        categoryMonthlyStats(spendingCategories, section: &section)
        categoryAmounts(spendingCategories, section: &section)
        self.sections = [section]
        NotificationUtil.shared.notify(UINotificationEvent.reloadTable.rawValue, key: "", value: "")
    }
}

extension SpendingCategoriesViewModel {
    
    func categoryMonthlyStats(_ spendingCategories: GetSpendingCategoryResponse, section: inout TableSectionViewModel) {
        let monthAmountStats = spendingCategories.monthAmountStats
        let barChart = BarChartTableViewCellViewModel()
        let spacer = SpacerTableViewCellViewModel()
        barChart.data = monthAmountStats ?? []
        section.rows.append(barChart)
        section.rows.append(spacer)
    }
    
    func categoryAmounts(_ spendingCategories: GetSpendingCategoryResponse, section: inout TableSectionViewModel) {
        let top = TopTableViewCellViewModel()
        let bottom = BottomTableViewCellViewModel()
        if let categoryAmountStatResponseList = spendingCategories.categoryAmountStats {
            section.rows.append(top)
            for categoryAmount in categoryAmountStatResponseList {
                let transactionGroup = TransactionGroupTableViewCellViewModel()
                transactionGroup.data = categoryAmount
                section.rows.append(transactionGroup)
            }
            section.rows.append(bottom)
        }
    }
}
