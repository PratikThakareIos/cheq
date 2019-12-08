//
//  AccountInfoTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ViewModel implements **TableViewCellViewModelProtocol**
 declaring the value for **identifier** is important as we need this to register our tablecells when we initialise subclass of **CTableViewController**
 */
class AccountInfoTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// Every viewModel implementing **TableViewCellViewModelProtocol** must declare this variable
    var identifier: String = "AccountInfoTableViewCell"
    
    /// header of information 
    var subHeader: String = "Full name"
    
    /// actual value that subHeader is referring to
    var information: String = "Chris Bacon" 
}
