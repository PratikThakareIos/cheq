//
//  HeaderTableViewCellViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum Header: String {
    case activity = "Activity'"
    case recentActivity = "Recent Activity"
    case upcomingBills = "Upcoming bill"
    case moneySpent = "Money spent"
}

class HeaderTableViewCellViewModel: TableViewCellViewModelProtocol {
    var identifier: String = "HeaderTableViewCell"
    var title: String = Header.activity.rawValue
    var showViewAll: Bool = false 
}
