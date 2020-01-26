//
//  TransactionGroupTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 7/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
ViewModel for **TransactionGroupTableViewCell**
 */
class TransactionGroupTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// reuse identifier
    var identifier: String = "TransactionGroupTableViewCell"
    
    /// **CategoryAmountStatResponse** is data model from Spending API 
    var data = CategoryAmountStatResponse(categoryId: 0, categoryTitle: "", categoryCode: .others, categoryAmount: 0.0, totalAmount: 0.0)
}
