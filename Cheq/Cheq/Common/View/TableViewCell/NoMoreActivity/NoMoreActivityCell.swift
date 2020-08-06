//
//  NoMoreActivityCell.swift
//  Cheq
//
//  Created by Amit.Rawal on 29/06/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class NoMoreActivityCell: CTableViewCell {

    /// cellHeight
    @IBOutlet weak var cellHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = NoMoreActivityViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    /// call **setupConfig** after viewModel is updated
    override func setupConfig() {
        self.backgroundColor = .clear
        let vm = self.viewModel as! NoMoreActivityViewModel
        cellHeight.constant = vm.height
    }
    
}
