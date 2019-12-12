//
//  HistoryItemTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 14/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ViewModel for **HistoryItemTableViewCell**. This is the table view cell for showing historic transactions on Lending screen. But we are not limited to use it only on Lending screen.
 */
class HistoryItemTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// reuse identifier
    var identifier: String = "HistoryItemTableViewCell"
    
    /// enum to represent the direction of cash
    var cashDirection: CashDirection = .debit
    
    /// amount is in String because we use it for label value
    var amount: String = "$200"
    
    /// itemItem is description header, this is driven by **cashDirection** variable
    var itemTitle: String = "Cash out"
    
    /// caption text for further details about the history item, can be Date string
    var itemCaption: String = "Today"
    
    /// fee value for fee label on table view cell
    var fee: String = "fee $10"
    
    /// image name of **HistoryItemTableViewCell** depending on **cashDirection** 
    func imageIcon()->String {
        return self.cashDirection == .debit ? "debit" : "credit"
    }
}
