//
//  LineSeparatorTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 10/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ViewModel for **LineSeparatorTableViewCell**
 */
class LineSeparatorTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// reuse identifier
    var identifier: String = "LineSeparatorTableViewCell"
    
    /// the height for line sepearator is adjustable by updating this value on ViewModel 
    var height: CGFloat = 0.5
}
