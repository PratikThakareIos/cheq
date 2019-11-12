//
//  SpendingSpecificCategoryViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 12/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class SpendingSpecificCategoryViewModel: BaseTableVCViewModel {
    
    var categoryId: Int = AppData.shared.selectedCategoryId
    
    override init() {
        super.init()
        self.screenName = .spending
    }
    
    func render(_ spendingSpecificCategoryResponse: GetSpendingSpecificCategoryResponse) {
        
        
        if self.sections.count > 0 {
            self.sections.removeAll()
        }
        
        var section = TableSectionViewModel()
        categoryMonthlyStats(spendingSpecificCategoryResponse.monthAmountStats, section: &section)
//        categoryAmounts(spendingCategories, section: &section)
        self.sections = [section]
        NotificationUtil.shared.notify(UINotificationEvent.reloadTable.rawValue, key: "", value: "")
    }
}
