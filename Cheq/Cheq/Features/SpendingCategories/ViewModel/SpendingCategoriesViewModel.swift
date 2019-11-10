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
        
        
//        if self.sections.count > 0 {
//            self.sections.removeAll()
//        }
//
//        var section = TableSectionViewModel()
//        spendingCard(spendingOverview, section: &section)
//        upcomingBills(spendingOverview, section: &section)
//        categoryAmounts(spendingOverview, section: &section)
//        recentTransactionList(spendingOverview, section: &section)
//        self.insertSection(section, index: 0)
//        NotificationUtil.shared.notify(UINotificationEvent.reloadTable.rawValue, key: "", value: "")
    }
}
