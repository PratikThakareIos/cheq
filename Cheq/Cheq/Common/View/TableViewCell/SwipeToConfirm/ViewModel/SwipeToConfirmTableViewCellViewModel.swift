//
//  SwipeToConfirmTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 15/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class SwipeToConfirmTableViewCellViewModel: TableViewCellViewModelProtocol {
    var identifier: String = "SwipeToConfirmTableViewCell"
    var textInBackground: String = "Swipe to agree and cash out..."
    var buttonTitle: String = "Agree"
    var footerText: String = "By swiping right you agree to the terms of the loan and Direct debit agreements"
}
