//
//  TransactionTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 7/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class TransactionTableViewCellViewModel: TableViewCellViewModelProtocol {
    var identifier: String = "TransactionTableViewCell"
    var data: SlimTransactionResponse = SlimTransactionResponse(_description: "", amount: 0.0, date: "", categoryTitle: "", categoryCode: .others, merchant: "", merchantLogoUrl: "", financialAccountName: "", financialInstitutionLogoUrl: "")
    var hideIcon: Bool = false 
}
