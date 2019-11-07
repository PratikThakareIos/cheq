//
//  CTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

protocol CTableViewCellProtocol {
    func setupConfig()
}

class CTableViewCell: UITableViewCell, CTableViewCellProtocol {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupConfig() {
        // subclass needs to override
    }

    var controller: Any? 
    var viewModel: TableViewCellViewModelProtocol?
}
