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
        
        
        clearSectionIfNeeded()
        var section = TableSectionViewModel()
        categoryMonthlyStats(spendingCategories.monthAmountStats, section: &section)
        categoryAmounts(spendingCategories, section: &section)
        self.sections = [section]
        NotificationUtil.shared.notify(UINotificationEvent.reloadTable.rawValue, key: "", value: "")
    }
}

extension SpendingCategoriesViewModel {
    
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
