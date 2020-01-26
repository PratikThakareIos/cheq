//
//  SpacerTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 16/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ViewModel for **SpacerTableViewCell**
 */
class SpacerTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// reuse identifier 
    var identifier = "SpacerTableViewCell"
    
    /// update height to determine spacerTableViewCell
    var height: CGFloat = 20.0
}
