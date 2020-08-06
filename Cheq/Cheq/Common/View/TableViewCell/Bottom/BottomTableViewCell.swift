//
//  BottomTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 BottomTableViewCell is a tableview cell representing the bottom border of a rounded corner rectangle embedding a list of transaction cells. Refer to Spending, Lending screens. Using **BottomTableViewCell** and **TopTableViewCell** means the data Array to build the tableview **CTableViewController** can be simplified into a 1 section with array rows instead of multiple sections with multiple rows.
 */
class BottomTableViewCell: CTableViewCell {

    /// refer to **xib**
    @IBOutlet weak var bottom: UIView!

    /// init method called when init from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        /// Initialization code
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// setupConfig stylize the cell, notice we don't rely on viewModel here. The viewModel is purely for consistency to be handle by **CTableViewController** 
    override func setupConfig() {
        self.backgroundColor = .clear
        self.bottom.backgroundColor = AppConfig.shared.activeTheme.altTextColor
        self.bottom.layer.cornerRadius = bottom.frame.size.height / 2 //AppConfig.shared.activeTheme.defaultCornerRadius
        self.bottom.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
}
