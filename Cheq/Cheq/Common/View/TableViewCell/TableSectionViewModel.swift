//
//  TableSectionViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 TableSectionViewModel is data structure for representing table section. This is used by viewModel of viewControllers that subclass from **CTableViewController**
 */
class TableSectionViewModel {
    
    /// title of section on tableview, this can be leave as empty if title is not needed
    var title = ""
    
    /// rows are made up of Array of table view cell viewModels that implements **TableViewCellViewModelProtocol** 
    var rows = [TableViewCellViewModelProtocol]()
}
