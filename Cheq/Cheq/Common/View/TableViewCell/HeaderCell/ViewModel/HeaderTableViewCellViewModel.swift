//
//  HeaderTableViewCellViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/// enums for HeaderTableViewCellTag, keeping all the tag values together instead of using magic numbers
enum HeaderTableViewCellTag: Int {
    case moneySpent = 1
    case recentActivity = 2
    case recentTransactions = 3
}

/// enums for Header title, update this enum when we need new headers for HeaderTableViewCell
enum Header: String {
    case activity = "Activity"
    case recentActivity = "Recent Activity"
    case upcomingBills = "Upcoming bills"
    case moneySpent = "Money spent"
}


/// ViewModel for **HeaderTableViewCell**
class HeaderTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// reuse identifier
    var identifier: String = "HeaderTableViewCell"
    
    /// default title
    var title: String = Header.activity.rawValue
    
    /// toggle for showing/hiding the **viewAll** link on the right hand side
    var showViewAll: Bool = false
    
    /// default tag, tag value is needed for handler to recognise which Header it needs to handle 
    var tag: Int = HeaderTableViewCellTag.recentActivity.rawValue
}
