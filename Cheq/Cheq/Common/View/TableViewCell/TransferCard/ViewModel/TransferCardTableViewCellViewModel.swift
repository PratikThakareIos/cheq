//
//  TransferCardTableViewCellViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 14/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class TransferCardTableViewCellViewModel: TableViewCellViewModelProtocol {
    var identifier = "TransferCardTableViewCell"
    var transferAmount = "$100"
    var feeAmountText = " + $10 fee"
    var direction: CashDirection = .credit
    func descriptionText()-> String {
        let text = self.direction == .credit ? "Will be deposited to your account" : "Will be deducted from your account"
        return text
    }
    
    var dateString = "Today, 17 Sep"
    
    func imageIcon()->String {
        let iconName = self.direction == .debit ? "debit" : "credit"
        return iconName
    }
}
