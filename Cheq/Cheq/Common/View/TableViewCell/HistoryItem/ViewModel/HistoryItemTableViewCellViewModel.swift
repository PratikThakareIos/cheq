//
//  HistoryItemTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 14/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class HistoryItemTableViewCellViewModel: TableViewCellViewModelProtocol {
    var identifier: String = "HistoryItemTableViewCell"
    var cashDirection: CashDirection = .debit
    var amount: String = "$200"
    var itemTitle: String = "Cash out"
    var itemCaption: String = "Today"
    var fee: String = "fee $10"
    
    
    func imageIcon()->String {
        return self.cashDirection == .debit ? "debit" : "credit"
    }
}
