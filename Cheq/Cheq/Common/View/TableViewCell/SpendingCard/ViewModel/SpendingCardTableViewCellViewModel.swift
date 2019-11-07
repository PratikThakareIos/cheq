//
//  SpendingCardViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 6/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class SpendingCardTableViewCellViewModel: TableViewCellViewModelProtocol{
    
    var identifier = "SpendingCardTableViewCell"
    var data: SpendingOverviewCard = SpendingOverviewCard(allAccountCashBalance: 1000.00, numberOfDaysTillPayday: 5, payCycleStartDate: "15 Sep", payCycleEndDate: "29 Sep", infoIcon: "")
}
