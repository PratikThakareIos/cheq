//
//  TransactionGroupTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 7/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class TransactionGroupTableViewCellViewModel: TableViewCellViewModelProtocol {
    var identifier: String = "TransactionGroupTableViewCell"
    var data = CategoryAmountStatResponse(categoryId: 0, categoryTitle: "", categoryCode: .others, categoryAmount: 0.0, totalAmount: 0.0)
}
