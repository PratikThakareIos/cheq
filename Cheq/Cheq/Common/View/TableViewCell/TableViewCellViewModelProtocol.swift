//
//  TableViewCellViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 Protocol for tableviewcell viewModels. We need to ensure **identifier** is defined and matches the reuse identifier defined in the corresponding **xib** file for the table view cell.
*/
protocol TableViewCellViewModelProtocol {
    
    /// make sure **identifier** matches whats defined in **xib** 
    var identifier: String { get }
}
