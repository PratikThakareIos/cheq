//
//  AvatarTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 avatar image cell
 */
class AvatarTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// identifier
    var identifier: String = "AvatarTableViewCell"
    
    /// name of the image, defaulted to **accountEmoji**
    var image = "accountEmoji"
}
