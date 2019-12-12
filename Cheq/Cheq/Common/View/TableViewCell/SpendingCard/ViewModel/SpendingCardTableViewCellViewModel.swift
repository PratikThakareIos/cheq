//
//  SpendingCardViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 6/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 The viewModel for **SpendingCardTableViewCell** which is used for **Spending Overview**
 */
class SpendingCardTableViewCellViewModel: TableViewCellViewModelProtocol{
    
    /// reuse identifier
    var identifier = "SpendingCardTableViewCell"
    
    /// **SpendingOverviewCard** is a data model from spending overview API
    var data: SpendingOverviewCard = SpendingOverviewCard(allAccountCashBalance: 1000.00, numberOfDaysTillPayday: 5, payCycleStartDate: "15 Sep", payCycleEndDate: "29 Sep", infoIcon: "")
}
