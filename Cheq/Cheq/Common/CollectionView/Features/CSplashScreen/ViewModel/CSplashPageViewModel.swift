//
//  CSplashPageViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum SplashImage: String {
    case budget = "splash/budgetImage"
    case spending = "splash/spendingImage"
    case cheqpay = "splash/cheqPayImage"
}

enum SplashText: String {
    case budget = "splash/budgetText"
    case spending = "splash/spendingText"
    case cheqpay = "splash/cheqPayText"
}

class CSplashPageViewModel: BaseViewModel {
    var splashImage: SplashImage = .budget
    var splashText: SplashText = .budget
    var bgColor: UIColor = .white
}
