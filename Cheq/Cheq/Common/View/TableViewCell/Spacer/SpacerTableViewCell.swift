//
//  SpacerTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 16/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 use **SpacerTableViewCell** to create spacing between cells 
 */
class SpacerTableViewCell: CTableViewCell {
    
    /// cellHeight
    @IBOutlet weak var cellHeight: NSLayoutConstraint! 

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = SpacerTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// call **setupConfig** after viewModel is updated
    override func setupConfig() {
        self.backgroundColor = .clear
        let vm = self.viewModel as! SpacerTableViewCellViewModel
        cellHeight.constant = vm.height
    }
    
}
