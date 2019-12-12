//
//  AgreemnentItemTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 14/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ViewModel for AgreementItemTableViewCell. **AgreementItemTableViewCell** is expandable view for showing the Loan agreement during the lending stage. **Keep in mind, during the time of documentation, the agreement flow is in progress of implementation**
 */
class AgreementItemTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// reuse identifier
    var identifier: String = "AgreementItemTableViewCell"
    
    /// title of the agreement
    var title: String = "Loan agreenment"
    
    /// message body of the agreement, this should be coming back from backend
    var message: String = "Cheq Pty Ltd provides you with the ability to borrow up to $300 on each pay cycle on Cheq Pty Ltd provides you with the ability to borrow up to $300 on each pay cycle on. Cheq Pty Ltd provides you with the ability to borrow up to $300 on each pay cycle on Cheq Pty Ltd provides you with the ability to borrow up to $300 on each pay cycle on. Cheq Pty Ltd provides you with the ability to borrow up to $300 on each pay cycle on Cheq Pty Ltd provides you with the ability to borrow up to $300 on each pay cycle on"
    
    /// text on expand/compress toggle text
    var readMoreTitle: String = "Read more"
    var readLessTitle: String = "Read less"
    
    /// toggle for expand/compress 
    var expanded: Bool = false
}
