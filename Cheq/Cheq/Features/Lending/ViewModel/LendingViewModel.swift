//
//  LendingViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum WithdrawalAmount: Int {
    case oneHundred = 100
    case twoHundred = 200
    case threeHundred = 300
}

class LendingViewModel: BaseViewModel {
    var availableToWithdraw: [WithdrawalAmount] = [.oneHundred, .twoHundred, .threeHundred]
}
