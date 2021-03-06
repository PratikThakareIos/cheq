//
//  SwipeToConfirmTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 15/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ViewModel for **SwipeToConfirmTableViewCell**
 */
class SwipeToConfirmTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// reuse identifier
    var identifier: String = "SwipeToConfirmTableViewCell"
    
    /// this is the text behind the swipe button
    var textInBackground: String = "Swipe to agree and cash out…"
    
    /// the text on top of the swipe button
    var buttonTitle: String = "Agree"
    
    /// the footer text underneath the swipe UI
    var footerText: String = "By swiping right you agree to our Terms & conditions" //"By swiping right you agree to the terms of the loan and Direct debit agreements"

    /// the header text underneath the swipe UI
    var headerText: String = "Read through the Terms & conditions and Direct debit agreement before proceeding..."
    
    /// bool for accepting the agreement
    var isAgreementAccpeted: Bool = false
    
    var isSwipeConfirmaed: Bool = false
    
    
    
}
