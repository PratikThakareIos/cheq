//
//  LineSeparatorTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 10/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 LineSeparatorTableViewCell is used whenever we need a line separator
 */
class LineSeparatorTableViewCell: CTableViewCell {
    
    /// line is a thin UIView
    @IBOutlet weak var lineView: UIView!
    
    /// constraint for the thickness of the line
    @IBOutlet weak var height: NSLayoutConstraint! 
    
    /// called when initialised using **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        /// Initialization code
        self.viewModel = LineSeparatorTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    /// setupConfig updates the UI according to the viewModel
    override func setupConfig() {
        let viewModel = self.viewModel as! LineSeparatorTableViewCellViewModel
        self.lineView.backgroundColor = AppConfig.shared.activeTheme.lightGrayScaleColor
        self.height.constant = viewModel.height
    }
}
