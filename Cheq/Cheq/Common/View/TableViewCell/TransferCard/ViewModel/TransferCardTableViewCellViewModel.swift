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
    var descriptionText = "Will be deposited to your account"
    var dateString = "Today, 17 Sep"
}
