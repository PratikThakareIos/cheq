//
//  TransactionModalViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 14/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class TransactionModalViewModel {
    var data: SlimTransactionResponse = SlimTransactionResponse(_description: "", amount: 0.0, date: "", categoryTitle: "", categoryCode: .others, merchant: "", merchantLogoUrl: "", financialAccountName: "", financialInstitutionLogoUrl: "")
}
