//
//  CTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
all table view cells should implement **CTableViewCellProtocol**
 */
protocol CTableViewCellProtocol {
    func setupConfig()
}

/**
 CTableViewCell should be subclassed by any new tableview cell developed for the app. So that all tableview cell follows the same usage and pattern for consistency. All **CTableViewCell** subclasses should be placed inside **TableViewCell** group under **View**.
 */
class CTableViewCell: UITableViewCell, CTableViewCellProtocol {

    /// this method is called when we initialise by Xib
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /// place holder method that needs to be override
    func setupConfig() {
        // subclass needs to override
    }
    
    /// certain tableview cell may need animation when it is first displayed, this is a place holder method to encapsulate any animations we want. Subclasses should be overriding this method.
    func animate() {
        // subclass can override to put in animation
        // this gets call when "cellWillDisplay" is triggered in UITableviewdelegate
    }

    /// all **CTableViewCell** should have a viewModel that follows **TableViewCellViewModelProtocol**, so that **CTableViewController** can handle all the cells with expected interface
    var viewModel: TableViewCellViewModelProtocol?
}
