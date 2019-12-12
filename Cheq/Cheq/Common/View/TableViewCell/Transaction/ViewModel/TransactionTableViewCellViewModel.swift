//
//  TransactionTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 7/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ViewModel for **TransactionTableViewCell**
 */
class TransactionTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// reuse identifeir
    var identifier: String = "TransactionTableViewCell"
    
    /// data is **SlimTransactionResponse** which is a model class from Cheq API
    var data: SlimTransactionResponse = SlimTransactionResponse(_description: "", amount: 0.0, date: "", categoryTitle: "", categoryCode: .others, merchant: "", merchantLogoUrl: "", financialAccountName: "", financialInstitutionLogoUrl: "")
    
    /// on transaction screen for one category, we don't need to show category icon 
    var hideIcon: Bool = false 
}
