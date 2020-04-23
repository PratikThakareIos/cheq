//
//  TransferCardTableViewCellViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 14/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ViewModel for **TransferCardTableViewCell**. **TransferCardTableViewCell** is UI for transfer cards on Lending screens. Update this viewModel and tableview cell accordingly.
 */
class TransferCardTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// Reuse identifier
    var identifier = "TransferCardTableViewCell"
    
    /// Transfer amount is in String, this is assigned to the transfer amount label
    var transferAmount = "$100"
    
    /// Fee amount for the transfer
    var feeAmountText = " + $10 fee"
    
    /// The direction of the transfer will determine the color and icon of the card
    var direction: CashDirection = .credit
    
    /// Description retrieval method, **CashDirection** determines the text
    func descriptionText()-> String {
        let text = self.direction == .credit ? "Will be transferred to your account" : "Will be deducted from your account on"
        return text
    }
    
    /// DateString is a variable to hold the target date of the transfer card
    var dateString = "Today, 17 Sep"
    
    /// Different CashDirection have different icon for the transfer card 
    func imageIcon()->String {
        let iconName = self.direction == .debit ? "debit" : "credit"
        return iconName
    }
}


//* funds clearance time will depend on your bank


//Will be deducted from your account on
//Mon, 23 Sep
