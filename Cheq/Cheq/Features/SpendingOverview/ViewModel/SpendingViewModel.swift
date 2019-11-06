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
        let section = TableSectionViewModel()
        let spendingCard = SpendingCardTableViewCellViewModel()
        section.rows.append(spendingCard)
        let spacer = SpacerTableViewCellViewModel()
        section.rows.append(spacer)
        let upcomingBillsHeader = HeaderTableViewCellViewModel()
        upcomingBillsHeader.title = "Upcoming bills"
        upcomingBillsHeader.showViewAll = true
        section.rows.append(upcomingBillsHeader)
        section.rows.append(spacer)
        let moneySpentHeader = HeaderTableViewCellViewModel()
        moneySpentHeader.title = "Money spent"
        moneySpentHeader.showViewAll = true
        section.rows.append(moneySpentHeader)
        section.rows.append(spacer)
        
        self.addSection(section)
        
        NotificationUtil.shared.notify(UINotificationEvent.reloadTableLayout.rawValue, key: "", value: "")
    }
}
